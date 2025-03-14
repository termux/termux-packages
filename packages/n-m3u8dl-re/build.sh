TERMUX_PKG_HOMEPAGE="https://github.com/nilaoda/N_m3u8DL-RE"
TERMUX_PKG_DESCRIPTION="Cross-Platform, modern and powerful stream downloader for MPD/M3U8/ISM"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.0~beta"
TERMUX_PKG_SRCURL="https://github.com/nilaoda/N_m3u8DL-RE/archive/refs/tags/v$(echo ${TERMUX_PKG_VERSION} | sed 's/~/-/g').tar.gz"
TERMUX_PKG_SHA256="6cbad6b6fda2733099cabb3cc1f89884984bdfb644416f14713d9bcdd0e55676"
TERMUX_PKG_BUILD_DEPENDS="dotnet-runtime-9.0, dotnet-sdk-9.0, dotnet-targeting-pack-9.0"
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_RECOMMENDS="python-yt-dlp"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
TERMUX_DOTNET_VERSION=9.0

termux_step_pre_configure() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	termux_setup_dotnet
}

termux_step_make() {
	dotnet publish src/N_m3u8DL-RE \
	--no-self-contained \
	--runtime "$DOTNET_TARGET_NAME" \
	--output build/ \
	-p:DisableUnsupportedError=true
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/n_m3u8dl-re
}
