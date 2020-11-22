TERMUX_PKG_HOMEPAGE=https://github.com/tadfisher/pass-otp
TERMUX_PKG_DESCRIPTION="A pass extension for managing one-time-password (OTP) tokens"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/tadfisher/pass-otp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5720a649267a240a4f7ba5a6445193481070049c1d08ba38b00d20fc551c3a67
TERMUX_PKG_DEPENDS="debianutils, oathtool, pass"
TERMUX_PKG_SUGGESTS="libqrencode"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	export BASHCOMPDIR=$TERMUX_PREFIX/etc/bash_completion.d
}
