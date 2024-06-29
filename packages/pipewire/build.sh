TERMUX_PKG_HOMEPAGE=https://pipewire.org/
TERMUX_PKG_DESCRIPTION="A server and user space API to deal with multimedia pipelines"
TERMUX_PKG_LICENSE="MIT, LGPL-2.1, LGPL-3.0, GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/${TERMUX_PKG_VERSION}/pipewire-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=a78516611257429633a1e020566cf03150a73d58c54e67bff936fd103d5bc6ce
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, glib, libc++, liblua54, libopus, libsndfile, libwebrtc-audio-processing, lilv, ncurses, openssl, pulseaudio, readline"

# 'media-session' session-managers is disabled as it requires alsa.
# Since we are building without x11, dbus is disabled.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgstreamer=disabled
-Dgstreamer-device-provider=disabled
-Dtests=disabled
-Dexamples=disabled
-Dpipewire-alsa=disabled
-Dalsa=disabled
-Dpipewire-jack=disabled
-Djack=disabled
-Ddbus=disabled
-Dsession-managers=['wireplumber']
-Dffmpeg=enabled
-Dwireplumber:system-lua=true
-Dwireplumber:system-lua-version=54
"

termux_step_pre_configure() {
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

	sed -i "s/'-Werror=strict-prototypes',//" ${TERMUX_PKG_SRCDIR}/meson.build
	CFLAGS+=" -Dindex=strchr -Drindex=strrchr"
	sed "s|@TERMUX_PKG_BUILDER_DIR@|${TERMUX_PKG_BUILDER_DIR}|g" \
		"${TERMUX_PKG_BUILDER_DIR}"/reallocarray.diff | patch -p1
}
