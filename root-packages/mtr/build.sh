TERMUX_PKG_HOMEPAGE=https://github.com/traviscross/mtr
TERMUX_PKG_DESCRIPTION="Network diagnostic tool"
TERMUX_PKG_VERSION=0.92
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/traviscross/mtr/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=568a52911a8933496e60c88ac6fea12379469d7943feb9223f4337903e4bc164
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gtk"

termux_step_pre_configure() {
	cp ${TERMUX_PKG_BUILDER_DIR}/hsearch/* ${TERMUX_PKG_SRCDIR}/portability

	cd ${TERMUX_PKG_SRCDIR}
	./bootstrap.sh
}
