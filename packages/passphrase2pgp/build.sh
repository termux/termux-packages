TERMUX_PKG_HOMEPAGE=https://github.com/skeeto/passphrase2pgp
TERMUX_PKG_DESCRIPTION="Generate EdDSA/cv25519 private key in GnuPG/SSH format reproducibly per hash of user given passphrase"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/skeeto/passphrase2pgp/releases/download/v$TERMUX_PKG_VERSION/passphrase2pgp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=dfed400dc3c5d5547a117dc91cc068bc1613daa0396089f6f66a51190b9889d7
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	mkdir bin
	go build -o ./bin -trimpath
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.*
}
