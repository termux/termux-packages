TERMUX_PKG_HOMEPAGE=http://www.portaudio.com
TERMUX_PKG_DESCRIPTION="portaudio io via pulseaudio"
TERMUX_PKG_VERSION=20180920
_commit=1fa9e3f955b73ff1d41437f35f2724ff9e7ef319
TERMUX_PKG_SHA256=64223bb2f5ab28466551c227e411871f549d162614ebe06a2d0fcfce77d85df0
TERMUX_PKG_SRCURL=https://github.com/illuusio/assembla-mirror-portaudio-pulseaudio/archive/$_commit.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DPA_USE_ALSA=OFF  -DPA_BUILD_EXAMPLES=ON -DPA_USE_PULSEAUDIO=ON -DPA_BUILD_TESTS=ON"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_DEPENDS="pulseaudio"
termux_step_post_make_install() {
	cp examples/pa* $TERMUX_PREFIX/bin
}
