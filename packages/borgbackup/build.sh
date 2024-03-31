TERMUX_PKG_HOMEPAGE=https://www.borgbackup.org/
TERMUX_PKG_DESCRIPTION="Deduplicating and compressing backup program"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.8"
TERMUX_PKG_SRCURL=https://github.com/borgbackup/borg/releases/download/${TERMUX_PKG_VERSION}/borgbackup-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d39d22b0d2cb745584d68608a179b6c75f7b40e496e96feb789e41d34991f4aa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libacl, liblz4, openssl, python, xxhash, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython, wheel"
TERMUX_PKG_PYTHON_TARGET_DEPS="msgpack==1.0.5"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install $TERMUX_PKG_PYTHON_TARGET_DEPS
	EOF
}
