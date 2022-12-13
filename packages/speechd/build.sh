TERMUX_PKG_HOMEPAGE=https://github.com/brailcom/speechd
TERMUX_PKG_DESCRIPTION="Common interface to speech synthesis"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=628d4446894b47f0df099123924c1070180b5b5b09c5b637ebe80d8578fba92f
TERMUX_PKG_SRCURL=https://github.com/brailcom/speechd/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="dotconf, espeak, glib, libiconv, libltdl, libsndfile, pulseaudio, python, speechd-data"
TERMUX_PKG_BUILD_DEPENDS="libiconv-static, libsndfile-static"
TERMUX_PKG_AUTO_UPDATE=true

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
	_PYTHON_VERSION=$(
		source $TERMUX_SCRIPTDIR/packages/python/build.sh
		echo $_MAJOR_VERSION
	)
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate

	export am_cv_python_pythondir="${TERMUX_PREFIX}/lib/python${_PYTHON_VERSION}/site-packages"
	export am_cv_python_pyexecdir="$am_cv_python_pythondir"
	./build.sh
}
