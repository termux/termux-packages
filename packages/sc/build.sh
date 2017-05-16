TERMUX_PKG_HOMEPAGE=https://github.com/dkastner/sc
TERMUX_PKG_DESCRIPTION="a venerable spreadsheet calculator"
TERMUX_PKG_VERSION=7.16
TERMUX_PKG_SRCURL=http://ibiblio.org/pub/Linux/apps/financial/spreadsheet/sc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1997a00b6d82d189b65f6fd2a856a34992abc99e50d9ec463bbf1afb750d1765
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes
# cannot find libc.so
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_post_configure() {
	LDFLAGS=${LDFLAGS/-march=armv7-a/-mtune=native}
	LDFLAGS=${LDFLAGS/-Wl,--fix-cortex-a8/}
}
