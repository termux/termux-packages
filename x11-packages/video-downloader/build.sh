TERMUX_PKG_HOMEPAGE="https://github.com/Unrud/video-downloader"
TERMUX_PKG_DESCRIPTION="Download videos from websites like YouTube and many others (based on yt-dlp)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.31"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/Unrud/video-downloader/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="9cdfdb1cb84455d9d231890aefb29ad82441fe27d6e8b6419412e7d5ee1189b3"
TERMUX_PKG_DEPENDS="ffmpeg, libadwaita, librsvg, pygobject, python, python-yt-dlp"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_meson

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_download_ubuntu_packages librsvg2-bin librsvg2-2
		export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
		export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
		export PATH="${HOSTBUILD_ROOTFS}/usr/bin:$PATH"
	fi
}
