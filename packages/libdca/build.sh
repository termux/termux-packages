TERMUX_PKG_HOMEPAGE=https://www.videolan.org/developers/libdca.html
TERMUX_PKG_DESCRIPTION="libdca is a free library for decoding DTS"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="COPYING"
TERMUX_PKG_VERSION=0.0.7
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/libdca/-/archive/${TERMUX_PKG_VERSION}/libdca-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=758a025db36356d5df829d2204f7aca618c7dfbe1e5d98ab633df33a6e32d61a
TERMUX_PKG_DEPENDS="ndk-sysroot"
termux_step_pre_configure() {
	cd ${TERMUX_PKG_SRCDIR} &&
		sed '/sys\/soundcard.h/ s/sys/linux/' libao/audio_out_oss.c -i
	${TERMUX_PKG_SRCDIR}/bootstrap
}
