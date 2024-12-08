TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/glib/
TERMUX_PKG_DESCRIPTION="Library providing core building blocks for libraries and applications written in C"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.82.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/glib/${TERMUX_PKG_VERSION%.*}/glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ab45f5a323048b1659ee0fbda5cecd94b099ab3e4b9abf26ae06aeb3e781fd63
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libffi, libiconv, pcre2, resolv-conf, zlib"
TERMUX_PKG_BUILD_DEPENDS="gobject-introspection"
TERMUX_PKG_BREAKS="glib-dev"
TERMUX_PKG_REPLACES="glib-dev"
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
	# glib checks for __BIONIC__ instead of __ANDROID__:
	CFLAGS+=" -D__BIONIC__=1"

	termux_setup_gir

	# Workaround: Remove cyclic dependency between gir and glib
	sed -i "/Requires:/d" "${TERMUX_PREFIX}/lib/pkgconfig/gobject-introspection-1.0.pc"
}

termux_step_post_make_install() {
	local pc_files=$(ls "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig")
	for pc in ${pc_files}; do
		echo "INFO: Patching cross pkgconfig ${pc}"
		sed "s|\${bindir}|${TERMUX_PREFIX}/opt/glib/cross/bin|g" \
			"${TERMUX_PREFIX}/lib/pkgconfig/${pc}" \
			> "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig/${pc}"
	done

	# Workaround: Restore deleted line in pre-configure step
	echo "Requires: glib-2.0 gobject-2.0" >> "${TERMUX_PREFIX}/lib/pkgconfig/gobject-introspection-1.0.pc"
}

termux_step_post_massage() {
	rm -v lib/pkgconfig/gobject-introspection-1.0.pc
}

termux_step_create_debscripts() {
	for i in postinst postrm triggers; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
