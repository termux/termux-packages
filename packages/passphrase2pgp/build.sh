TERMUX_PKG_HOMEPAGE=https://github.com/skeeto/passphrase2pgp
TERMUX_PKG_DESCRIPTION="Generate EdDSA/cv25519 private key in GnuPG/SSH format reproducibly per hash of user given passphrase"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/skeeto/passphrase2pgp/releases/download/v$TERMUX_PKG_VERSION/passphrase2pgp-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=1fad02633910f0d091c9529d85bd575d2ccc5aa7de9855ea3824a4d197ecf400
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
