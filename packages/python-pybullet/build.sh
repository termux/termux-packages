TERMUX_PKG_HOMEPAGE=https://pybullet.org/
TERMUX_PKG_DESCRIPTION="Python interface for Bullet physics simulation and robotics"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="3.25"
TERMUX_PKG_SRCURL=https://github.com/bulletphysics/bullet3/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77
TERMUX_PKG_DEPENDS="libx11, mesa, opengl, python, python-numpy"
TERMUX_PKG_BUILD_DEPENDS="libx11, mesa-dev"
_NUMPY_VERSION=$(
	. $TERMUX_SCRIPTDIR/packages/python-numpy/build.sh
	echo $TERMUX_PKG_VERSION
)
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="build, setuptools, wheel, 'numpy==$_NUMPY_VERSION'"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	:
}

termux_step_make_install() {
	cross-pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR"
}
