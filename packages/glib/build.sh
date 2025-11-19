TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/glib/
TERMUX_PKG_DESCRIPTION="Library providing core building blocks for libraries and applications written in C"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.86.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/glib/${TERMUX_PKG_VERSION%.*}/glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8a724e970855357ea8101e27727202392a0ffd5410a98336aed54ec59113e611
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libffi, libiconv, pcre2, resolv-conf, zlib, python"
TERMUX_PKG_BREAKS="glib-dev, glib-bin"
TERMUX_PKG_REPLACES="glib-dev, glib-bin"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Druntime_dir=$TERMUX_PREFIX/var/run
-Dlibmount=disabled
-Dman-pages=enabled
-Dtests=false
"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/glib-gettextize
bin/gtester-report
lib/locale
share/gdb/auto-load
share/glib-2.0/gdb
share/glib-2.0/gettext
share/gtk-doc
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
-Ddefault_library=static
-Dintrospection=disabled
-Dlibmount=disabled
-Dtests=false
--prefix ${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}/cross
"
TERMUX_PKG_NO_SHEBANG_FIX_FILES="
opt/glib/cross/bin/gdbus-codegen
opt/glib/cross/bin/glib-genmarshal
opt/glib/cross/bin/glib-gettextize
opt/glib/cross/bin/glib-mkenums
opt/glib/cross/bin/gtester-report
"

termux_step_host_build() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then return; fi

	# XXX: termux_setup_meson is not expected to be called in host build
	AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
	termux_setup_meson
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP

	${TERMUX_MESON} setup ${TERMUX_PKG_SRCDIR} . \
		${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	ninja -j "${TERMUX_PKG_MAKE_PROCESSES}" install

	# termux_step_massage strip does not cover opt dir
	find "${TERMUX_PREFIX}/opt" \
		-path "*/glib/cross/bin/*" \
		-type f -print0 | \
		xargs -0 -r file | grep -E "ELF .+ (executable|shared object)" | \
		cut -d":" -f1 | xargs -r strip --strip-unneeded --preserve-dates
}

termux_step_pre_configure() {
	# always remove this marker because glib-cross' files are installed during termux_step_host_build(),
	# so the command scripts/run-docker.sh ./build-package.sh -a all gtk3 (without -I, with -a all)
	# would otherwise have .../files/usr/bin/glib-compile-resources: Exec format error
	rm -rf $TERMUX_HOSTBUILD_MARKER
	# glib checks for __BIONIC__ instead of __ANDROID__:
	CFLAGS+=" -D__BIONIC__=1"
	_PREFIX="$TERMUX_PKG_TMPDIR/prefix"
	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	rm -rf "$_PREFIX" "$_WRAPPER_BIN"
	mkdir -p "$_PREFIX" "$_WRAPPER_BIN"

	sed '/^export PKG_CONFIG_LIBDIR=/s|$|:'${_PREFIX}'/lib/pkgconfig|' \
		"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
		> "${_WRAPPER_BIN}/pkg-config"
	chmod +x "${_WRAPPER_BIN}/pkg-config"
	export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	export PATH="${_WRAPPER_BIN}:${PATH}"

	# Magic happens here.
	# I borrowed nested building method from https://github.com/termux/termux-packages/blob/1244c75380beefc7f7da9744d55aa88df1640acb/x11-packages/qbittorrent/build.sh#L21-L28
	# and modified termux_step_configure_meson in runtime to make it use another prefix
	# Also I used advice from here https://github.com/termux/termux-packages/issues/20447#issuecomment-2156066062

	# Running a subshell to not mess with variables
	(
		# Building `glib` with `-Dintrospection=disabled` and installing it to temporary directory
		TERMUX_PKG_BUILDDIR="$TERMUX_PKG_TMPDIR/glib-build"
		mkdir -p "$TERMUX_PKG_BUILDDIR"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/"-Dintrospection=enabled"/"-Dintrospection=disabled"}"
		termux_setup_gir

		cd "$TERMUX_PKG_BUILDDIR"
		TERMUX_PREFIX="$_PREFIX" termux_step_configure
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make_install
	)

	# Running a subshell to not mess with variables
	(
		# Building `gobject-introspection` and installing it to temporary directory
		TERMUX_PKG_BUILDER_DIR="$TERMUX_SCRIPTDIR/packages/gobject-introspection"
		TERMUX_PKG_BUILDDIR="$TERMUX_PKG_TMPDIR/gobject-introspection-build"
		TERMUX_PKG_SRCDIR="$TERMUX_PKG_TMPDIR/gobject-introspection-src"
		LDFLAGS+=" -L${_PREFIX}/lib"
		mkdir -p "$TERMUX_PKG_BUILDDIR" "$TERMUX_PKG_SRCDIR"
		# Sourcing another build script for nested build
		. "$TERMUX_PKG_BUILDER_DIR/build.sh"
		cd "$TERMUX_PKG_CACHEDIR"

		termux_step_get_source
		termux_step_get_dependencies_python
		termux_step_patch_package

		termux_step_pre_configure

		cd "$TERMUX_PKG_BUILDDIR"
		TERMUX_PREFIX="$_PREFIX" termux_step_configure
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make
		cd "$TERMUX_PKG_BUILDDIR"
		termux_step_make_install
	)

	# Place the GIR files inside the root of the GIR directory (gir/.) of the package
	termux_setup_gir

	# The package will be built with using gobject-introspection we built before...
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_make_install() {
	local pc_files=$(ls "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig")
	for pc in ${pc_files}; do
		echo "INFO: Patching cross pkgconfig ${pc}"
		sed "s|\${bindir}|${TERMUX_PREFIX}/opt/glib/cross/bin|g" \
			"${TERMUX_PREFIX}/lib/pkgconfig/${pc}" \
			> "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig/${pc}"
	done
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES=(
		'lib/libgio-2.0.so.0'
		'lib/libgirepository-2.0.so.0'
		'lib/libglib-2.0.so.0'
		'lib/libgmodule-2.0.so.0'
		'lib/libgobject-2.0.so.0'
		'lib/libgthread-2.0.so.0'
	)

	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}

termux_step_create_debscripts() {
	for i in postinst prerm triggers; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		echo "post_install" > postupg
	fi
	chmod 644 ./triggers
}
