TERMUX_PKG_HOMEPAGE=https://github.com/agnostic-apollo/tudo
TERMUX_PKG_DESCRIPTION="A wrapper script to drop to the supported shells or execute shell script files or their text passed as an argument as the Termux app (u<userid>_a<appid>) user in the Termux app"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@agnostic-apollo"
TERMUX_PKG_VERSION=1.0.0

# FIXME: Fix urls
TERMUX_PKG_SRCURL=file:///home/builder/termux-packages/sources/tudo
TERMUX_PKG_SHA256=SKIP_CHECKSUM

#TERMUX_PKG_SRCURL=https://github.com/agnostic-apollo/tudo/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SHA256=xxx

TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="TUDO_PKG__VERSION=${TERMUX_PKG_VERSION} TUDO_PKG__ARCH=${TERMUX_ARCH} \
TERMUX__NAME=${TERMUX__NAME} TERMUX__LNAME=${TERMUX__LNAME} \
TERMUX_APP__NAME=${TERMUX_APP__NAME} TERMUX_APP__PACKAGE_NAME=${TERMUX_APP__PACKAGE_NAME} \
TERMUX__ROOTFS=${TERMUX__ROOTFS} TERMUX__HOME=${TERMUX__HOME} TERMUX__PREFIX=${TERMUX__PREFIX} \
TERMUX_ENV__S_ROOT=${TERMUX_ENV__S_ROOT} \
TERMUX_ENV__SS_TERMUX=${TERMUX_ENV__SS_TERMUX} TERMUX_ENV__S_TERMUX=${TERMUX_ENV__S_TERMUX} \
TERMUX_ENV__SS_TERMUX_APP=${TERMUX_ENV__SS_TERMUX_APP} TERMUX_ENV__S_TERMUX_APP=${TERMUX_ENV__S_TERMUX_APP}"

termux_step_install_license() {
	mkdir -p "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/licenses"
	mv "$TERMUX_PKG_SRCDIR/LICENSE" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/copyright"
	mv "$TERMUX_PKG_SRCDIR/licenses/agnostic-apollo__tudo__MIT.md" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/licenses/"
}
