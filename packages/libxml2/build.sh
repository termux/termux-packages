TERMUX_PKG_HOMEPAGE=http://www.xmlsoft.org
TERMUX_PKG_DESCRIPTION="Library for parsing XML documents"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.14.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libxml2/${TERMUX_PKG_VERSION%.*}/libxml2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=353f3c83535d4224a4e5f1e88c90b5d4563ea8fec11f6407df640fd28fc8b8c6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-http
--with-legacy
--with-python
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc"
TERMUX_PKG_DEPENDS="libiconv, liblzma, zlib"
TERMUX_PKG_BUILD_DEPENDS="python"
TERMUX_PKG_BREAKS="libxml2-dev"
TERMUX_PKG_REPLACES="libxml2-dev"

termux_step_pre_configure() {
	# SOVERSION suffix is needed for SONAME of shared libs to avoid conflict
	# with system ones (in /system/lib64 or /system/lib):
	sed -i 's/^\(linux\*android\)\*)/\1-notermux)/' configure
}

termux_step_post_massage() {
	# Check if SONAME is properly set:
	if ! readelf -d lib/libxml2.so | grep -q '(SONAME).*\[libxml2\.so\.'; then
		termux_error_exit "SONAME for libxml2.so is not properly set."
	fi

	local _SOVERSION=16
	if [[ ! -e "lib/libxml2.so.${_SOVERSION}" ]]; then
		echo "ERROR - Expected: lib/libxml2.so.${_SOVERSION}" >&2
		echo "ERROR - Found   : $(find lib/libxml2* -regex '.*so\.[0-9]+')" >&2
		termux_error_exit "Not proceeding with update."
	fi
}
