TERMUX_PKG_HOMEPAGE=https://openjdk.java.net
TERMUX_PKG_DESCRIPTION="Java development kit and runtime"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="21.0.6"
TERMUX_PKG_SRCURL=https://github.com/openjdk/jdk21u/archive/refs/tags/jdk-${TERMUX_PKG_VERSION}-ga.tar.gz
TERMUX_PKG_SHA256=9fec30f33b3a85c982cf8c1a6d99d296b2eef4e627e8586c3e42b9692983f5e9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-shmem, libandroid-spawn, libiconv, libjpeg-turbo, zlib, littlecms"
TERMUX_PKG_BUILD_DEPENDS="cups, fontconfig, libxrandr, libxt, xorgproto"
# openjdk-21-x is recommended because X11 separation is still very experimental.
TERMUX_PKG_RECOMMENDS="ca-certificates-java, openjdk-21-x, resolv-conf"
TERMUX_PKG_SUGGESTS="cups"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false
# currently zgc and shenandoahgc would be auto enabled in server variant,
# while these features is not supported on arm.
# only leave lto here.
__jvm_features="link-time-opt"

termux_pkg_auto_update() {
	# based on `termux_github_api_get_tag.sh`
	# fetch latest tags
	local latest_tags="$(curl -d "$(cat <<-EOF | tr '\n' ' '
	{
		"query": "query {
			repository(owner: \"openjdk\", name: \"jdk21u\") {
				refs(refPrefix: \"refs/tags/\", first: 20, orderBy: {
					field: TAG_COMMIT_DATE, direction: DESC
				})
				{ edges { node { name } } }
			}
		}"
	}
	EOF
	)" \
		-H "Authorization: token ${GITHUB_TOKEN}" \
		-H "Accept: application/vnd.github.v3+json" \
		--silent \
		--location \
		--retry 10 \
		--retry-delay 1 \
		https://api.github.com/graphql \
		| jq '.data.repository.refs.edges[].node.name')"
	# filter only tags having "-ga" and extract only raw version.
	local latest_tag="$(echo "$latest_tags" \
		| grep -P "\d+\.\d+\.\d+-ga" \
		| grep -oP "\d+\.\d+\.\d+")"
	# we need only one result from the top.
	latest_tag="$(echo "$latest_tag" | head -n 1)"

	[[ -z "${latest_tag}" ]] && termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_pre_configure() {
	unset JAVA_HOME
}

termux_step_configure() {
	local jdk_ldflags="-L${TERMUX_PREFIX}/lib \
		-Wl,-rpath=$TERMUX_PREFIX/lib/jvm/java-21-openjdk/lib \
		-Wl,-rpath=${TERMUX_PREFIX}/lib -Wl,--enable-new-dtags"
	bash ./configure \
		--disable-precompiled-headers \
		--disable-warnings-as-errors \
		--enable-option-checking=fatal \
		--with-version-pre="" \
		--with-version-opt="" \
		--with-jvm-variants=server \
		--with-jvm-features="${__jvm_features}" \
		--with-debug-level=release \
		--openjdk-target=$TERMUX_HOST_PLATFORM \
		--with-toolchain-type=clang \
		--with-extra-cflags="$CFLAGS $CPPFLAGS -DLE_STANDALONE -D__ANDROID__=1 -D__TERMUX__=1" \
		--with-extra-cxxflags="$CXXFLAGS $CPPFLAGS -DLE_STANDALONE -D__ANDROID__=1 -D__TERMUX__=1" \
		--with-extra-ldflags="${jdk_ldflags} -Wl,--as-needed -landroid-shmem -landroid-spawn" \
		--with-cups-include="$TERMUX_PREFIX/include" \
		--with-fontconfig-include="$TERMUX_PREFIX/include" \
		--with-freetype-include="$TERMUX_PREFIX/include/freetype2" \
		--with-freetype-lib="$TERMUX_PREFIX/lib" \
		--with-x="$TERMUX_PREFIX/include/X11" \
		--x-includes="$TERMUX_PREFIX/include/X11" \
		--x-libraries="$TERMUX_PREFIX/lib" \
		--with-giflib=system \
		--with-lcms=system \
		--with-libjpeg=system \
		--with-libpng=system \
		--with-zlib=system \
		--with-vendor-name="Termux" \
		AR="$AR" \
		NM="$NM" \
		OBJCOPY="$OBJCOPY" \
		OBJDUMP="$OBJDUMP" \
		STRIP="$STRIP" \
		CXXFILT="llvm-cxxfilt" \
		BUILD_CC="/usr/bin/clang-18" \
		BUILD_CXX="/usr/bin/clang++-18" \
		BUILD_NM="/usr/bin/llvm-nm-18" \
		BUILD_AR="/usr/bin/llvm-ar-18" \
		BUILD_OBJCOPY="/usr/bin/llvm-objcopy-18" \
		BUILD_STRIP="/usr/bin/llvm-strip-18" \
		$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make() {
	cd build/linux-${TERMUX_ARCH/i686/x86}-server-release
	make images
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-21-openjdk
	cp -r build/linux-${TERMUX_ARCH/i686/x86}-server-release/images/jdk/* \
		$TERMUX_PREFIX/lib/jvm/java-21-openjdk/
	find $TERMUX_PREFIX/lib/jvm/java-21-openjdk/ -name "*.debuginfo" -delete

	# Dependent projects may need JAVA_HOME.
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-21-openjdk/etc/profile.d
	echo "export JAVA_HOME=$TERMUX_PREFIX/lib/jvm/java-21-openjdk/" > \
		$TERMUX_PREFIX/lib/jvm/java-21-openjdk/etc/profile.d/java.sh
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib/jvm/java-21-openjdk/man/man1
	for manpage in *.1; do
		gzip "$manpage"
	done
}

termux_step_create_debscripts() {
	binaries="$(find $TERMUX_PREFIX/lib/jvm/java-21-openjdk/bin -executable -type f | xargs -I{} basename "{}" | xargs echo)"
	manpages="$(find $TERMUX_PREFIX/lib/jvm/java-21-openjdk/man/man1 -name "*.1.gz" | xargs -I{} basename "{}" | xargs echo)"

	for hook in postinst prerm; do
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			-e "s|@binaries@|${binaries}|g" \
			-e "s|@manpages@|${manpages}|g" \
			"$TERMUX_PKG_BUILDER_DIR/hooks/$TERMUX_PACKAGE_FORMAT/$hook.in" > $hook
		chmod 700 $hook
	done

	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		echo "post_install" > postupg
	fi
}
