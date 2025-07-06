TERMUX_PKG_HOMEPAGE=https://github.com/traviscross/mtr
TERMUX_PKG_DESCRIPTION="Network diagnostic tool"
TERMUX_PKG_LICENSE="GPL-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="BSDCOPYING, COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.96"
TERMUX_PKG_SRCURL=https://github.com/traviscross/mtr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73e6aef3fb6c8b482acb5b5e2b8fa7794045c4f2420276f035ce76c5beae632d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gtk"

termux_step_pre_configure() {
	cp ${TERMUX_PKG_BUILDER_DIR}/hsearch/* ${TERMUX_PKG_SRCDIR}/portability

	cd ${TERMUX_PKG_SRCDIR}
	./bootstrap.sh
}
