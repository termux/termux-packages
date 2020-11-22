TERMUX_PKG_HOMEPAGE=https://github.com/aeolwyr/tergent
TERMUX_PKG_DESCRIPTION="A cryptoki/PKCS#11 library for Termux that uses Android Keystore as its backend"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/aeolwyr/tergent/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b59cf0ced3f693fb19396a986326963f3763e6bf65d3e56af0a03d206d69428
TERMUX_PKG_DEPENDS="termux-api"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	termux_setup_rust
	cargo build --target=$TERMUX_HOST_PLATFORM --release
	install -Dm600 -t $TERMUX_PREFIX/lib target/${TERMUX_HOST_PLATFORM}/release/libtergent.so
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	echo
	echo "Tergent since v1.x is a library package."
	echo
	echo "Visit https://github.com/aeolwyr/tergent/blob/master/README.md for more information."
	echo
	exit 0
	EOF
}
