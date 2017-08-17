TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/oath-toolkit/
TERMUX_PKG_DESCRIPTION="One-time password components"
TERMUX_PKG_VERSION=2.6.2
TERMUX_PKG_SRCURL=http://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b03446fa4b549af5ebe4d35d7aba51163442d255660558cd861ebce536824aa0
TERMUX_PKG_DEPENDS="xmlsec"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pam"
