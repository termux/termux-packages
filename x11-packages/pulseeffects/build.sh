TERMUX_PKG_HOMEPAGE=https://github.com/wwmm/easyeffects
TERMUX_PKG_DESCRIPTION="Audio effects for PulseAudio applications"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Do not upgrade to EasyEffects version.
TERMUX_PKG_VERSION=4.8.7
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/wwmm/easyeffects/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d841f27df87b99747349be6b8de62d131422369908fcb57a81f39590437a8099
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="boost, glib, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gstreamer, gtk3, gtkmm3, libbs2b, libc++, libebur128, librnnoise, libsndfile, libzita-convolver, lilv, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, glib-cross, libsamplerate"

termux_step_pre_configure() {
	case "$TERMUX_PKG_VERSION" in
		4.*|*:4.* ) ;;
		* ) termux_error_exit "Dubious version '$TERMUX_PKG_VERSION' for package '$TERMUX_PKG_NAME'." ;;
	esac

	export BOOST_ROOT=$TERMUX_PREFIX

	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	mkdir -p "${_WRAPPER_BIN}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH="${_WRAPPER_BIN}:${PATH}"
}
