TERMUX_PKG_HOMEPAGE=https://codeberg.org/Anoxinon_e.V./xmppc
TERMUX_PKG_DESCRIPTION="Command Line Interface Tool for XMPP"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="j.r <j.r@jugendhacker.de>"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://codeberg.org/Anoxinon_e.V./xmppc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=98d68deb57924e5ed06613d8b275fb0bf98aab822fb590fe8d9894410a8544ee
TERMUX_PKG_DEPENDS="libstrophe, glib, gpgme"

termux_step_pre_configure() {
	./bootstrap.sh
}
