TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research - RRG/Iceman repo"
TERMUX_PKG_LICENSE="GPL-2.0"
_COMMIT=cfcb0494590d8dbe611e9e1eaf60f52495fd69de
TERMUX_PKG_VERSION=2020.02.23-g${_COMMIT:0:8}
TERMUX_PKG_SRCURL=https://github.com/RfidResearchGroup/proxmark3/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=7a935b34a4a9f35fc58330bc2356276a6667cc5f4f4f128244e5f8354935844f
TERMUX_PKG_BUILD_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC="true"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"

termux_step_make() {
	LD=$CC
	make client -j $TERMUX_MAKE_PROCESSES LDLIBS="-L$TERMUX_PREFIX/lib -lreadline -lm"
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/client/proxmark3 \
		"$TERMUX_PREFIX"/bin/proxmark3
}
