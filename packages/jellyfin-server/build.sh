TERMUX_PKG_HOMEPAGE="https://jellyfin.org"
TERMUX_PKG_DESCRIPTION="A free media system for organizing and streaming media"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.10.5"
TERMUX_PKG_SRCURL="https://github.com/jellyfin/jellyfin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="1dd19f501a4f61b1370951efb76373ad29e9b5a76a6dae445fbfae2ed2648786"
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-8.0, dotnet-targeting-pack-8.0"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-8.0, dotnet-host, dotnet-runtime-8.0, ffmpeg, sqlite"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=(
	"jellyfin"
	"${TERMUX_PREFIX}/bin/dotnet ${TERMUX_PREFIX}/share/jellyfin/jellyfin.dll --datadir ${TERMUX_ANDROID_HOME}/jellyfin"
)
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	termux_setup_dotnet
}

termux_step_make() {
	dotnet publish Jellyfin.Server --configuration Release --runtime $DOTNET_TARGET_NAME --output builddir --no-self-contained
}

termux_step_make_install() {
	install -Dm700 builddir/jellyfin.dll "${TERMUX_PREFIX}/share/jellyfin/jellyfin.dll"
	cp -r builddir "${TERMUX_PREFIX}/lib/jellyfin"
}
