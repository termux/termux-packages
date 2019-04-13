TERMUX_PKG_HOMEPAGE=http://scripts.sil.org/teckitdownloads
TERMUX_PKG_DESCRIPTION="TECkit is a library for encoding conversion"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.5.9
TERMUX_PKG_SHA256=9c9f77ed40e2fcfbbb82e88b78fee2233c58e2ecfd3f3201bfa4b13ea6b5c970
TERMUX_PKG_SRCURL=https://github.com/silnrsi/teckit/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_expat_XML_ExpatVersion=no"

termux_step_pre_configure() {
	./autogen.sh
}
