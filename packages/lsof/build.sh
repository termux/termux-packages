TERMUX_PKG_HOMEPAGE=https://github.com/lsof-org/lsof
TERMUX_PKG_DESCRIPTION="Lists open files for running Unix processes"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.96.5"
TERMUX_PKG_SRCURL=https://github.com/lsof-org/lsof/archive/${TERMUX_PKG_VERSION}/lsof-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9030af1123ff052ab69e12ef55b8a17dc47ac4bccfba85ee1ca1f31acf29607
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libtirpc"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	LSOF_CC="$CC" ./Configure -n linux
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin/ lsof
	install -Dm600 Lsof.8 $TERMUX_PREFIX/share/man/man8/lsof.8
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/license.txt
}
