TERMUX_PKG_HOMEPAGE=https://liba52.sourceforge.io
TERMUX_PKG_DESCRIPTION="library for decoding ATSC A/52 streams."
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE=GPL-2.0
TERMUX_PKG_LICENSE_FILE=COPYING
TERMUX_PKG_VERSION=0.7.4
TERMUX_PKG_SRCURL=https://liba52.sourceforge.io/files/a52dec-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a21d724ab3b3933330194353687df82c475b5dfb997513eef4c25de6c865ec33
TERMUX_PKG_DEPENDS="ndk-sysroot"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--build=aarch64-unknown-linux-gnu"
termux_step_pre_configure() {
	sed '/sys\/soundcard.h/ s/sys/linux/' libao/audio_out_oss.c -i
	${TERMUX_PKG_SRCDIR}/bootstrap
}
