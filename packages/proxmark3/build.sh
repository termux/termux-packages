TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
_COMMIT=bf975af358e1694bd48f37458e709b05311bf92c
TERMUX_PKG_VERSION=2020.03.01-g${_COMMIT:0:8}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/RfidResearchGroup/proxmark3/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=e27b4b77cf64ba83046719f969d0bcb0d2f8e36d4567cfd8e26005a8bdbf6689
TERMUX_PKG_BUILD_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC="true"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"

termux_step_make() {
	LD=$CC
	make PLATFORM=PM3OTHER client -j $TERMUX_MAKE_PROCESSES LDLIBS="-L$TERMUX_PREFIX/lib -lreadline -lm"
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/client/proxmark3 \
		"$TERMUX_PREFIX"/bin/proxmark3
}
