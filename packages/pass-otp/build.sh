TERMUX_PKG_HOMEPAGE=https://github.com/tadfisher/pass-otp
TERMUX_PKG_DESCRIPTION="A pass/passage extension for managing one-time-password (OTP) tokens"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
_COMMIT=a364d2a71ad24158a009c266102ce0d91149de67
_COMMIT_DATE=20221228
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.2.0-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=https://github.com/tadfisher/pass-otp/archive/$_COMMIT.tar.gz
TERMUX_PKG_SHA256=02c6fa59b30ee009c62807b763c41df44cc9e4da3e137f1b5774e995ee18e2f6
TERMUX_PKG_DEPENDS="oathtool"
TERMUX_PKG_SUGGESTS="pass | passage, libqrencode"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	export PREFIX=$TERMUX_PREFIX
	export BASHCOMPDIR=$TERMUX_PREFIX/share/bash-completion/completions
	export MANDIR=$TERMUX_PREFIX/share/man
}

termux_step_post_configure() {
	# Replace $PREFIX with $PASS_PREFIX
	# to avoid variable name conflicts with Termux's $PREFIX
	# See: https://github.com/termux/termux-packages/issues/23569
	sed -i "s|PREFIX|PASS_PREFIX|g" otp.bash
}

termux_step_post_make_install() {
	# Symlink for passage
	mkdir -p "$TERMUX_PREFIX/lib/passage/extensions"
	ln -sf $TERMUX_PREFIX/lib/password-store/extensions/otp.bash "$TERMUX_PREFIX/lib/passage/extensions/"
}
