TERMUX_PKG_HOMEPAGE=https://github.com/traviscross/mtr
TERMUX_PKG_DESCRIPTION="Network diagnostic tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.94
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/traviscross/mtr/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea036fdd45da488c241603f6ea59a06bbcfe6c26177ebd34fff54336a44494b8
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gtk"

termux_step_pre_configure() {
	cp ${TERMUX_PKG_BUILDER_DIR}/hsearch/* ${TERMUX_PKG_SRCDIR}/portability

	cd ${TERMUX_PKG_SRCDIR}
	./bootstrap.sh
}
