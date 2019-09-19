TERMUX_PKG_HOMEPAGE=https://github.com/traviscross/mtr
TERMUX_PKG_DESCRIPTION="Network diagnostic tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.93
TERMUX_PKG_SRCURL=https://github.com/traviscross/mtr/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3a1ab330104ddee3135af3cfa567b9608001c5deecbf200c08b545ed6d7a4c8f
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gtk"

termux_step_pre_configure() {
	cp ${TERMUX_PKG_BUILDER_DIR}/hsearch/* ${TERMUX_PKG_SRCDIR}/portability

	cd ${TERMUX_PKG_SRCDIR}
	./bootstrap.sh
}
