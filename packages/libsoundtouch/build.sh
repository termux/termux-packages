TERMUX_PKG_HOMEPAGE=https://www.surina.net/soundtouch/
TERMUX_PKG_DESCRIPTION="An open-source audio processing library for changing the Tempo, Pitch and Playback Rates of audio streams or files"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.1"
TERMUX_PKG_SRCURL=https://www.surina.net/soundtouch/soundtouch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e07abf20ce8f95850c280132e1f61ad400fc1f4011b7fac698a503de6aab6733
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
