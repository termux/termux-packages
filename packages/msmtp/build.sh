TERMUX_PKG_HOMEPAGE=https://marlam.de/msmtp/
TERMUX_PKG_DESCRIPTION="Lightweight SMTP client"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=bd730cbf000d1b8382849ea21d569a387e63f936be00dc07c569f67915e53ccd
TERMUX_PKG_SRCURL=https://marlam.de/msmtp/releases/msmtp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libgnutls, libidn"

termux_step_pre_configure () {
	LDFLAGS=" -L${TERMUX_PREFIX}/lib -llog"
	autoreconf -if
}
