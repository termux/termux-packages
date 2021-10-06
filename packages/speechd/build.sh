TERMUX_PKG_HOMEPAGE=https://github.com/brailcom/speechd
TERMUX_PKG_DESCRIPTION="Common interface to speech synthesis"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=056efb80186f2bfc3f6ef468ab9905ca2d652cc2180b13514b752a9d616a6930
TERMUX_PKG_SRCURL=https://github.com/brailcom/speechd/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="dotconf, espeak, glib, libiconv, pulseaudio, python"
TERMUX_PKG_BUILD_DEPENDS="libiconv-static, libsndfile-static"

##
## Note: package needs patching for proper fix of pthread_cancel usage.
## Right now it uses pthread_kill(t, 0) which does nothing and is not
## correct solution to the missing pthread_cancel on Android OS.
## See package "calcurse" for example of proper pthread_cancel replacement.
##

# Fails to find generated headers
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--with-pulse
--with-espeak-ng
"

# spd-conf needs python stuff, so remove for now
TERMUX_PKG_RM_AFTER_INSTALL="bin/spd-conf"

# We cannot run cross-compiled programs to get help message, so disable
# man-page generation with help2man
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="ac_cv_prog_HELP2MAN="
 
termux_step_pre_configure () {
	_PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	./build.sh
}

termux_step_post_massage() {
	mv lib/python3* lib/python$_PYTHON_VERSION
}
