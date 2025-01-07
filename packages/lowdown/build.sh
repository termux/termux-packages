TERMUX_PKG_HOMEPAGE="https://kristaps.bsd.lv/lowdown"
TERMUX_PKG_DESCRIPTION="Markdown utilities and library (fork of hoedown -> sundown -> libsoldout)"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL="https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=75bf8ddc66f6c75ebb64131ced1e729983a38f866a93878fc1753df93330e0ef
#TERMUX_PKG_BUILD_DEPENDS="libseccomp" ## it is merely a checkdepends for now and we dont run check during build
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAKE_INSTALL_TARGET="install install_libs" ## add "regress" target if one wanna run check
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology

termux_step_configure() {
	## avoid hard-linking during make
	sed -Ee 's%^([\t ]*ln) -f (lowdown lowdown-diff)$%\1 -srf \2%' -i Makefile

	## not an autoconf script
	./configure \
		LDFLAGS="$LDFLAGS" \
		CPPFLAGS="$CPPFLAGS" \
		PREFIX="$TERMUX_PREFIX" \
		MANDIR="$TERMUX_PREFIX/share/man"
}
