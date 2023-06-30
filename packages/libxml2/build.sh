TERMUX_PKG_HOMEPAGE=http://www.xmlsoft.org
TERMUX_PKG_DESCRIPTION="Library for parsing XML documents"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.11
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libxml2/${_MAJOR_VERSION}/libxml2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=737e1d7f8ab3f139729ca13a2494fd17bf30ddb4b7a427cf336252cab57f57f7
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-python
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc"
TERMUX_PKG_DEPENDS="libiconv, liblzma, zlib"
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

	# Temporarily break the package so that it is not installed:
	mkdir -p bin
	cat > bin/sh <<-EOF
		#!/bin/sh
		exec /bin/sh "\$@"
	EOF
	chmod 0700 bin/sh
}
