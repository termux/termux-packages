TERMUX_PKG_HOMEPAGE=https://pipewire.org/
TERMUX_PKG_DESCRIPTION="A server and user space API to deal with multimedia pipelines"
TERMUX_PKG_LICENSE="MIT, LGPL-2.1, LGPL-3.0, GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.82"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/${TERMUX_PKG_VERSION}/pipewire-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=18ecba7174bf9f5da39cdf749e6cf260bd09b6831ba2f8165b20771cd10af4e5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, glib, libc++, liblua54, libopus, libsndfile, libwebrtc-audio-processing, lilv, ncurses, openssl, readline, pulseaudio, alsa-lib, oboe"


# 'media-session' session-managers is disabled as it requires alsa.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgstreamer=disabled
-Dgstreamer-device-provider=disabled
-Dtests=disabled
-Dexamples=disabled
-Dpipewire-alsa=enabled
-Dalsa=enabled
-Dpipewire-jack=enabled
-Djack=disabled
-Ddbus=disabled
-Dsession-managers=['wireplumber']
-Dffmpeg=enabled
-Dwireplumber:system-lua=true
-Dwireplumber:system-lua-version=54
"

termux_step_post_get_source() {
	sed -i "s|@TERMUX_PKG_BUILDER_DIR@|${TERMUX_PKG_BUILDER_DIR}|g" \
		"${TERMUX_PKG_BUILDER_DIR}"/0001-reallocarray.patch
}

termux_step_pre_configure() {
	# Our aaudio modules need libaaudio.so from a later android api version:
	if [ $TERMUX_PKG_API_LEVEL -lt 26 ]; then
		local _libdir="$TERMUX_PKG_TMPDIR/libaaudio"
		rm -rf "${_libdir}"
		mkdir -p "${_libdir}"
		cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/26/libaaudio.so" \
			"${_libdir}"
		LDFLAGS+=" -L${_libdir}"
	fi
	cp $TERMUX_PKG_BUILDER_DIR/module-*.c* $TERMUX_PKG_SRCDIR/src/modules
	cp $TERMUX_PKG_BUILDER_DIR/module-protocol-pulse/* $TERMUX_PKG_SRCDIR/src/modules/module-protocol-pulse/modules
	
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
}
