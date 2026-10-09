TERMUX_PKG_HOMEPAGE="https://cleanuparr.com"
TERMUX_PKG_DESCRIPTION="Queue cleaner and management companion for the *arr suite"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.9"
TERMUX_PKG_SRCURL=(
	"https://github.com/Cleanuparr/Cleanuparr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
	"https://github.com/Cleanuparr/Transmission.API.RPC/archive/1d2548c3c888a2d8b0a2bf4fbefe2f91e981e263.tar.gz"
	"https://github.com/Cleanuparr/qbittorrent-net-client/archive/b36a3ca40c83776f9f1b86a56e46ae718e2cf96f.tar.gz"
)
TERMUX_PKG_SHA256=(
	f4c5e5aec43c76ab1edc6652a3d7a3d06113073fd7e4c94baf2c46f4d5e26c3a
	f300d496200dc1f35f58c1966e9aaa2442487f66b2b9b4188948d81e159488ea
	25ff0192ff04c38fea7a9527f44c45729a0b5d206110105ee874e2a308ff1393
)
TERMUX_PKG_DEPENDS="aspnetcore-runtime-10.0, dotnet-host, dotnet-runtime-10.0, libesqlite3"
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-10.0, dotnet-targeting-pack-10.0, nodejs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_DOTNET_VERSION=10.0
TERMUX_PKG_SERVICE_SCRIPT=(
	"cleanuparr"
	"exec ${TERMUX_PREFIX}/bin/cleanuparr 2>&1"
)

termux_step_pre_configure() {
	termux_setup_dotnet
	termux_setup_nodejs

	local _local_feed="${TERMUX_PKG_BUILDDIR}/_nuget_local"
	mkdir -p "${_local_feed}"

	local _trans_dir="${TERMUX_PKG_SRCDIR}/Transmission.API.RPC-1d2548c3c888a2d8b0a2bf4fbefe2f91e981e263"
	dotnet pack "${_trans_dir}/Transmission.API.RPC/Transmission.API.RPC.csproj" \
		-c Release -o "${_local_feed}"

	local _qbit_dir="${TERMUX_PKG_SRCDIR}/qbittorrent-net-client-b36a3ca40c83776f9f1b86a56e46ae718e2cf96f"
	dotnet build "${_qbit_dir}/src/QBittorrent.Client/QBittorrent.Client.csproj" \
		-c Release
	cp "${_qbit_dir}/src/QBittorrent.Client/bin/Release/"*.nupkg "${_local_feed}/"

	cat <<-EOF > "${TERMUX_PKG_SRCDIR}/code/backend/nuget.config"
		<?xml version="1.0" encoding="utf-8"?>
		<configuration>
		  <packageSources>
		    <clear />
		    <add key="LocalFeed" value="${_local_feed}" />
		    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
		  </packageSources>
		</configuration>
	EOF

	pushd "${TERMUX_PKG_SRCDIR}/code/frontend"
	npm ci
	npm run build
	popd

	mkdir -p "${TERMUX_PKG_SRCDIR}/code/backend/Cleanuparr.Api/wwwroot"
	cp -r "${TERMUX_PKG_SRCDIR}/code/frontend/dist/ui/browser/"* "${TERMUX_PKG_SRCDIR}/code/backend/Cleanuparr.Api/wwwroot/"
}

termux_step_make() {
	dotnet publish "${TERMUX_PKG_SRCDIR}/code/backend/Cleanuparr.Api/Cleanuparr.Api.csproj" \
		--configuration Release \
		--runtime "${DOTNET_TARGET_NAME}" \
		--output "${TERMUX_PKG_BUILDDIR}/build" \
		--no-self-contained \
		-p:PublishReadyToRun=false \
		-p:DebugType=None

	dotnet build-server shutdown
}

termux_step_make_install() {
	rm -f "${TERMUX_PKG_BUILDDIR}/build/"libe_sqlite3.so*

	rm -rf "${TERMUX_PREFIX}/lib/cleanuparr"
	mkdir -p "${TERMUX_PREFIX}/lib/cleanuparr"
	cp -r "${TERMUX_PKG_BUILDDIR}/build/"* "${TERMUX_PREFIX}/lib/cleanuparr/"

	mkdir -p "${TERMUX_PREFIX}/bin"
	cat >"${TERMUX_PREFIX}/bin/cleanuparr" <<-EOF
		#!${TERMUX_PREFIX}/bin/sh
		export CLEANUPARR_CONFIG_PATH="\${CLEANUPARR_CONFIG_PATH:-\$HOME/.config/cleanuparr}"
		mkdir -p "\$CLEANUPARR_CONFIG_PATH"
		cd "${TERMUX_PREFIX}/lib/cleanuparr"
		exec dotnet "${TERMUX_PREFIX}/lib/cleanuparr/Cleanuparr.dll" "\$@"
	EOF
	chmod 0755 "${TERMUX_PREFIX}/bin/cleanuparr"
}
