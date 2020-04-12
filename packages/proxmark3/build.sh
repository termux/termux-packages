TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
_COMMIT=682bded18abdee81a6064f5ef4dbc69c1f38de09
TERMUX_PKG_VERSION=2020.04.12-g${_COMMIT:0:8}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/RfidResearchGroup/proxmark3/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=2f6bc40f012b2df305c137deff8cf6369a422611d26c261e1fafa32729432531
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
