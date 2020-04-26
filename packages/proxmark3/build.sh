TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
_COMMIT=011f973e7ff145ee0f6ccf58c850765513c43d04
TERMUX_PKG_VERSION=2020.04.24-g${_COMMIT:0:8}
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/RfidResearchGroup/proxmark3/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=dc3c7a317d8ff24b304d9e85c1c43f30c854e85296ee2834f3bcbf0ef8745bbd
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
