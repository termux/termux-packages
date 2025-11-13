TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home
TERMUX_PKG_DESCRIPTION="Library for parsing XML documents"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.15.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libxml2/${TERMUX_PKG_VERSION%.*}/libxml2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c008bac08fd5c7b4a87f7b8a71f283fa581d80d80ff8d2efd3b26224c39bc54c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SETUP_PYTHON=true
# disabled due to compiler warnings
#	-Dthread-alloc=enabled
#	-Dtls=enabled
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-Ddocs=enabled
	-Dhttp=enabled
	-Dicu=enabled
	-Dlegacy=enabled
"
# Python bindings
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-Dpython=enabled
"
# `xmllint` history support
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	-Dhistory=enabled
	-Dreadline=enabled
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/doc/libxml2/html
share/doc/libxml2/xmlcatalog.html
share/doc/libxml2/xmllint.html
"
TERMUX_PKG_DEPENDS="libandroid-glob, libiconv, libicu, zlib"
TERMUX_PKG_BUILD_DEPENDS="python, readline"
TERMUX_PKG_BREAKS="libxml2-dev"
TERMUX_PKG_REPLACES="libxml2-dev"

termux_step_configure() {
	LDFLAGS+=" -landroid-glob"
	# This directory is usually made by doxygen
	# and python/generator.py expects it to be there.
	mkdir -p "$TERMUX_PKG_BUILDDIR/python/doc/xml"
	# # SOVERSION suffix is needed for SONAME of shared libs to avoid conflict
	# # with system ones (in /system/lib64 or /system/lib):
	export TERMUX_MESON_ENABLE_SOVERSION=1
	termux_step_configure_meson
}

termux_step_post_massage() {
	# Check if SONAME is properly set:
	if ! readelf -d lib/libxml2.so | grep -q '(SONAME).*\[libxml2\.so\.'; then
		termux_error_exit "SONAME for libxml2.so is not properly set."
	fi

	# If this has been bumped, remember to rebuild all reverse dependencies of libxml2!
	# `./scripts/bin/revbump --dependencies libxml2` can find them for you.
	local _SOVERSION=16
	if [[ ! -e "lib/libxml2.so.${_SOVERSION}" ]]; then
		echo "ERROR - Expected: lib/libxml2.so.${_SOVERSION}" >&2
		echo "ERROR - Found   : $(find lib/libxml2* -regex '.*so\.[0-9]+')" >&2
		termux_error_exit "Not proceeding with update."
	fi
}
