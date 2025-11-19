TERMUX_PKG_HOMEPAGE=https://www.surina.net/soundtouch/
TERMUX_PKG_DESCRIPTION="An open-source audio processing library for changing the Tempo, Pitch and Playback Rates of audio streams or files"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.surina.net/soundtouch/soundtouch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=43b23dfac2f64a3aff55d64be096ffc7b73842c3f5665caff44975633a975a99
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
