TERMUX_PKG_HOMEPAGE=https://github.com/wwmm/easyeffects
TERMUX_PKG_DESCRIPTION="Audio effects for PulseAudio applications"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Do not upgrade to EasyEffects version.
TERMUX_PKG_VERSION=4.8.6
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/wwmm/easyeffects/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3eb69c43a5a3e7a7551e06afd6efb537e7551cc35f138a6cb6c4fc68edd1e843
TERMUX_PKG_DEPENDS="boost, glib, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gstreamer, gtk3, gtkmm3, libbs2b, libc++, libebur128, librnnoise, libsndfile, libzita-convolver, lilv, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, libsamplerate"

termux_step_pre_configure() {
	case "$TERMUX_PKG_VERSION" in
		4.*|*:4.* ) ;;
		* ) termux_error_exit "Dubious version '$TERMUX_PKG_VERSION' for package '$TERMUX_PKG_NAME'." ;;
	esac

	export BOOST_ROOT=$TERMUX_PREFIX
}
