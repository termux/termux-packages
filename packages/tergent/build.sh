TERMUX_PKG_HOMEPAGE=https://github.com/danog/tergent
TERMUX_PKG_DESCRIPTION="A cryptoki/PKCS#11 library for Termux that uses Android Keystore as its backend"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/danog/tergent/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3a9b0f27646275de5f344c3209fc563aca9bd685aea9d34388cfaabff07b1956
TERMUX_PKG_DEPENDS="termux-api"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	install -Dm600 -t $TERMUX_PREFIX/lib target/${CARGO_TARGET_NAME}/release/libtergent.so
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/bash
	echo
	echo "Tergent since v1.x has some breaking changes."
	echo
	echo "You will need new keys. See https://github.com/aeolwyr/tergent/blob/master/README.md#upgrading-from-01 for more details on how to upgrade."
	echo
	read -p "Are you sure you're ready to upgrade? [yN] " yn
	case \$yn in
		[Yy]* ) exit 0;;
		* ) exit 1;;
	esac
	EOF
}
