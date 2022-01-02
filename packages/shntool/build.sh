TERMUX_PKG_HOMEPAGE=http://shnutils.freeshell.org/shntool/
TERMUX_PKG_DESCRIPTION="A multi-purpose WAVE data processing and reporting utility"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.10
TERMUX_PKG_SRCURL=http://shnutils.freeshell.org/shntool/dist/src/shntool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=74302eac477ca08fb2b42b9f154cc870593aec8beab308676e4373a5e4ca2102

termux_step_pre_configure() {
	autoreconf -fi
}
