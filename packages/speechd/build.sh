TERMUX_PKG_HOMEPAGE=https://github.com/brailcom/speechd
TERMUX_PKG_DESCRIPTION="Common interface to speech synthesis"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.4"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=628d4446894b47f0df099123924c1070180b5b5b09c5b637ebe80d8578fba92f
TERMUX_PKG_SRCURL=https://github.com/brailcom/speechd/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="dotconf, espeak, glib, libiconv, libltdl, libsndfile, pulseaudio, python, speechd-data"
TERMUX_PKG_BUILD_DEPENDS="libiconv-static, libsndfile-static"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SETUP_PYTHON=true

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

termux_step_pre_configure() {
	export am_cv_python_pythondir="${TERMUX_PREFIX}/lib/python${TERMUX_PYTHON_VERSION}/site-packages"
	export am_cv_python_pyexecdir="$am_cv_python_pythondir"
	./build.sh
}

termux_step_post_massage() {
	find lib -name '*.la' -delete
}
