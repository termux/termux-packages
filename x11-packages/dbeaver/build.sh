TERMUX_PKG_HOMEPAGE=https://dbeaver.io/
TERMUX_PKG_DESCRIPTION="Free universal database tool and SQL client (Community Edition)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="26.2.1"

# Built from four source trees: dbeaver, dbeaver-common (parent POM),
# datadam-api (API module required by product/aggregate/pom.xml since 26.2.1)
# and eclipse.platform.swt. SWT is only used to rebuild the JNI libraries
# because the prebuilt ones are linked against glibc and can not be loaded on
# Android.
# _COMMON_COMMIT, _DATADAM_COMMIT and _SWT_TAG are derived from the version
# and rewritten by termux_pkg_auto_update() at the end of this file. The
# update fails if the dbeaver-common/datadam-api release branch or the SWT
# tag of the new release is missing.
_COMMON_COMMIT="d11df22413e9c48278ee22afbfa9f00f0d54e776"
_DATADAM_COMMIT="3a5981e58e130909df93aa9b0c8b3e406d46812b"
_SWT_TAG="R4_41"

TERMUX_PKG_SRCURL=(
	"https://github.com/dbeaver/dbeaver/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
	"https://github.com/dbeaver/dbeaver-common/archive/${_COMMON_COMMIT}.tar.gz"
	"https://github.com/dbeaver/datadam-api/archive/${_DATADAM_COMMIT}.tar.gz"
	"https://github.com/eclipse-platform/eclipse.platform.swt/archive/refs/tags/${_SWT_TAG}.tar.gz"
)
TERMUX_PKG_SHA256=(
	ef422d1af682471741e3d66999eeb57a91ca2bc418103c29bc6e9e1702efc321
	4a94fc986de5d095eed4f87e9452a039582e593582dd8d5e5a169bea6e43e1aa
	bfda7a080263d624dd473b9005dd220ce919c5ab10ecfffe3cb52512edecf232
	4dae25b05a6431d28e7bb18297a89222e2f5d8b4acb797c7ba692e4dcff5bbd9
)
TERMUX_PKG_AUTO_UPDATE=true

# Upstream bundles JDK 25; Java 21 is the minimum.
TERMUX_PKG_DEPENDS="at-spi2-core, gtk3, libcairo, libx11, libxtst, openjdk-25"
TERMUX_PKG_RECOMMENDS="openjdk-25-x"
TERMUX_PKG_SUGGESTS="termux-x11-nightly"

# Eclipse only ships SWT/GTK for 64-bit CPUs.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false
# Tycho needs several GB of RAM and a host JDK 21+.
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

# shellcheck source=x11-packages/dbeaver/helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

termux_step_post_get_source() {
	# The POMs expect ../dbeaver-common next to the dbeaver source dir.
	local top
	top="$(dirname "$TERMUX_PKG_SRCDIR")"

	if [ -d "$TERMUX_PKG_SRCDIR/dbeaver-common-${_COMMON_COMMIT}" ]; then
		rm -rf "$top/dbeaver-common"
		mv "$TERMUX_PKG_SRCDIR/dbeaver-common-${_COMMON_COMMIT}" "$top/dbeaver-common"
	fi
	if [ -d "$TERMUX_PKG_SRCDIR/datadam-api-${_DATADAM_COMMIT}" ]; then
		rm -rf "$top/datadam-api"
		mv "$TERMUX_PKG_SRCDIR/datadam-api-${_DATADAM_COMMIT}" "$top/datadam-api"
	fi
	if [ -d "$TERMUX_PKG_SRCDIR/eclipse.platform.swt-${_SWT_TAG}" ]; then
		rm -rf "$top/eclipse.platform.swt"
		mv "$TERMUX_PKG_SRCDIR/eclipse.platform.swt-${_SWT_TAG}" "$top/eclipse.platform.swt"
	fi

	[ -f "$top/dbeaver-common/pom.xml" ] || termux_error_exit "dbeaver-common sources not found in $top"
	[ -f "$top/datadam-api/apis/pom.xml" ] || termux_error_exit "datadam-api sources not found in $top"
	[ -d "$top/eclipse.platform.swt/bundles/org.eclipse.swt" ] || termux_error_exit "SWT sources not found in $top"
}

termux_step_pre_configure() {
	case "$TERMUX_ARCH" in
		aarch64|x86_64) _SWT_ARCH="$TERMUX_ARCH" ;;
		*) termux_error_exit "Unsupported architecture for SWT/GTK: $TERMUX_ARCH" ;;
	esac

	_WORKSPACE_TOP="$(dirname "$TERMUX_PKG_SRCDIR")"
	_JAVA_TARGET_HOME="$TERMUX_PREFIX/lib/jvm/java-25-openjdk"
}

termux_step_make() {
	# Tycho 5 needs JDK 21+ on the host (default is 17).
	local host_jdk=""
	local candidate
	for candidate in /usr/lib/jvm/java-21-openjdk-* /usr/lib/jvm/java-25-openjdk-*; do
		if [ -x "$candidate/bin/javac" ]; then
			host_jdk="$candidate"
			break
		fi
	done
	[ -n "$host_jdk" ] || termux_error_exit "A host JDK 21+ (/usr/lib/jvm/java-21-openjdk-*) is required to run Tycho"

	(
		export JAVA_HOME="$host_jdk"
		export PATH="$JAVA_HOME/bin:$PATH"
		export MAVEN_OPTS="${MAVEN_OPTS:--Xmx4g}"

		local mvnw="$_WORKSPACE_TOP/dbeaver-common/mvnw"
		chmod +x "$mvnw"

		cd "$TERMUX_PKG_SRCDIR"
		"$mvnw" -B -T1C -DskipTests \
			-f product/aggregate/pom.xml \
			-Pproduct-dbeaver-ce \
			package
	)

	local product_dir
	product_dir="$(__dbeaver_find_product_dir)"
	[ -n "$product_dir" ] || termux_error_exit "Materialized product for linux/gtk/${_SWT_ARCH} not found"

	# Same folders as nativeSourceFolders.properties, minus GLX, WebKit and AWT.
	local swt_root="$_WORKSPACE_TOP/eclipse.platform.swt/bundles/org.eclipse.swt"
	local swt_build="$TERMUX_PKG_TMPDIR/swt-native"

	rm -rf "$swt_build"
	mkdir -p "$swt_build"
	local d
	for d in \
		"Eclipse SWT/common/library" \
		"Eclipse SWT PI/common/library" \
		"Eclipse SWT PI/gtk/library" \
		"Eclipse SWT PI/cairo/library"; do
		cp -a "$swt_root/$d/." "$swt_build/"
	done

	local src_ver
	src_ver="$(. <(grep -E '^(maj_ver|min_ver|rev)=' "$swt_build/make_common.mak"); echo "${maj_ver}${min_ver}r${rev}")"
	local prod_ver
	prod_ver="$(__dbeaver_swt_version_from_product "$product_dir")"
	if [ -n "$prod_ver" ] && [ "$prod_ver" != "$src_ver" ]; then
		termux_error_exit "SWT version mismatch: product uses $prod_ver but $_SWT_TAG sources are $src_ver. Update _SWT_TAG (and its SHA256)."
	fi
	_SWT_LIB_VERSION="${prod_ver:-$src_ver}"

	cd "$swt_build"
	# Upstream uses -Werror; new clang warnings must not break the build.
	sed -i 's/-Werror//' make_linux.mak

	# SWT's own build.sh adds -fPIC, the Termux toolchain does not.
	export CFLAGS="$CFLAGS -fPIC"
	export SWT_JAVA_HOME="$_JAVA_TARGET_HOME"
	export OUTPUT_DIR="$swt_build"
	export MODEL="$_SWT_ARCH"
	export GTK_VERSION=3.0
	make -f make_linux.mak \
		make_swt make_atk make_cairo \
		SWT_VERSION="$_SWT_LIB_VERSION" \
		SWT_PTR_CFLAGS=-DJNI64 \
		SWT_LFLAGS="$LDFLAGS" \
		-j "$TERMUX_PKG_MAKE_PROCESSES"

	ls "$swt_build"/libswt-gtk-*.so "$swt_build"/libswt-pi3-gtk-*.so >/dev/null
}

termux_step_make_install() {
	local product_dir
	product_dir="$(__dbeaver_find_product_dir)"
	local dest="$TERMUX_PREFIX/opt/dbeaver"

	rm -rf "$dest"
	mkdir -p "$dest"
	cp -a "$product_dir/." "$dest/"

	# glibc ELF launcher, replaced by the script below.
	rm -f "$dest/dbeaver"

	# glibc-linked libjnidispatch.so for every platform; unusable and rejected
	# by the package check.
	find "$dest/plugins" -path "*/com.sun.jna_*" -type f \
		\( -name "*.so" -o -name "*.dll" -o -name "*.dylib" -o -name "*.jnilib" \) -delete

	# Loaded via -Dswt.library.path, before the glibc libs inside the SWT jar.
	install -Dm755 -t "$dest/swt" \
		"$TERMUX_PKG_TMPDIR"/swt-native/libswt-gtk-*.so \
		"$TERMUX_PKG_TMPDIR"/swt-native/libswt-pi3-gtk-*.so \
		"$TERMUX_PKG_TMPDIR"/swt-native/libswt-atk-gtk-*.so \
		"$TERMUX_PKG_TMPDIR"/swt-native/libswt-cairo-gtk-*.so

	cat > "$TERMUX_PREFIX/bin/dbeaver" <<-SCRIPT
	#!$TERMUX_PREFIX/bin/sh
	DBEAVER_HOME="$TERMUX_PREFIX/opt/dbeaver"

	export GDK_BACKEND="\${GDK_BACKEND:-x11}"
	export SWT_GTK3=1

	LAUNCHER_JAR=\$(ls "\$DBEAVER_HOME"/plugins/org.eclipse.equinox.launcher_*.jar | head -n 1)

	set -f
	VMARGS=\$(sed -n '/^-vmargs\$/,\$ { /^-vmargs\$/d; p }' "\$DBEAVER_HOME/dbeaver.ini" | tr '\\n' ' ')
	set +f

	# /tmp does not exist on Android.
	exec "$TERMUX_PREFIX/bin/java" \$VMARGS \\
		-Dswt.library.path="\$DBEAVER_HOME/swt" \\
		-Djava.io.tmpdir="\${TMPDIR:-$TERMUX_PREFIX/tmp}" \\
		-jar "\$LAUNCHER_JAR" "\$@"
	SCRIPT
	chmod 0755 "$TERMUX_PREFIX/bin/dbeaver"

	install -Dm644 "$TERMUX_PKG_SRCDIR/product/community/icons/dbeaver.png" \
		"$TERMUX_PREFIX/share/icons/hicolor/256x256/apps/dbeaver.png"

	install -Dm644 /dev/stdin "$TERMUX_PREFIX/share/applications/dbeaver.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=DBeaver
	Comment=Universal database tool
	Exec=dbeaver
	Icon=dbeaver
	Terminal=false
	Type=Application
	Categories=Development;Database;
	DESKTOP
}

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(termux_github_api_get_tag)"
	[[ -n "${latest_tag}" ]] || termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	[[ "${latest_tag}" =~ ^[0-9]+(\.[0-9]+){2,3}$ ]] ||
		termux_error_exit "Unexpected DBeaver tag '${latest_tag}'"

	# Only rewrite the pins when an update will really happen.
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${latest_tag}" &&
		[[ "${BUILD_PACKAGES}" != "false" && -z "${TERMUX_PKG_UPGRADE_VERSION_DRY_RUN:-}" ]]; then
		__dbeaver_resolve_source_pins "${latest_tag}"
		sed \
			-e "s/^\(_COMMON_COMMIT=\).*/\1\"${_NEW_COMMON_COMMIT}\"/" \
			-e "s/^\(_DATADAM_COMMIT=\).*/\1\"${_NEW_DATADAM_COMMIT}\"/" \
			-e "s/^\(_SWT_TAG=\).*/\1\"${_NEW_SWT_TAG}\"/" \
			-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"
	fi

	termux_pkg_upgrade_version "${latest_tag}"
}
