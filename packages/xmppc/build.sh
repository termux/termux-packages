TERMUX_PKG_HOMEPAGE=https://codeberg.org/Anoxinon_e.V./xmppc
TERMUX_PKG_DESCRIPTION="Command Line Interface Tool for XMPP"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="j.r <j.r@jugendhacker.de>"
TERMUX_PKG_VERSION=0.1.2
TERMUX_PKG_SRCURL=https://codeberg.org/Anoxinon_e.V./xmppc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=05259ec5cba25f693edfe01389a3405835404539c7817fb208c201e29480e6b7
TERMUX_PKG_DEPENDS="libstrophe, glib, gpgme"

termux_step_pre_configure() {
	./bootstrap.sh
}
