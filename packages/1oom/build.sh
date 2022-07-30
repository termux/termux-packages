TERMUX_PKG_HOMEPAGE=https://gitlab.com/Tapani_/1oom
TERMUX_PKG_DESCRIPTION="A Master of Orion (1993) game engine recreation"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://gitlab.com/Tapani_/1oom/-/archive/v${TERMUX_PKG_VERSION}/1oom-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a4273966dde5f3296c08f903ad2e12f522b7d536919bc00e4a0a1d69d457ced0
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--disable-uiclassic
--disable-hwsdl1
--disable-hwsdl1audio
--disable-hwsdl1gl
--disable-hwsdl2
--disable-hwsdl2audio
--disable-hwalleg4
"

termux_step_pre_configure() {
	autoreconf -fi
}
