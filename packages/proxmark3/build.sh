TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
_COMMIT=cf47e50267b7dd15a2228a8bee23a6a80fd34c26
TERMUX_PKG_VERSION=2020.03.19-g${_COMMIT:0:8}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/RfidResearchGroup/proxmark3/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=d39acfbc9db013ded7686073fda49d32e0bced6ad5960eb5430aca819a64e1d8
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
