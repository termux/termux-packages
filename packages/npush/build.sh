TERMUX_PKG_HOMEPAGE=http://npush.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Curses-based logic game similar to Sokoban and Boulder Dash"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Dmitry Marakasov <amdmi3@amdmi3.ru>"
TERMUX_PKG_VERSION=0.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/npush/npush/${TERMUX_PKG_VERSION}/npush-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=f216d2b3279e8737784f77d4843c9e6f223fa131ce1ebddaf00ad802aba2bcd9
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_post_get_source() {
	sed -i -e "s|\"levels|\"${TERMUX_PREFIX}/share/npush/levels|" npush.cpp
}

termux_step_make() {
	$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS -lncurses -o npush npush.cpp
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin/ npush
	install -Dm644 -t $TERMUX_PREFIX/share/npush/levels levels/* 
}
