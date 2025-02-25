TERMUX_PKG_HOMEPAGE="https://github.com/jackett/jackett"
TERMUX_PKG_DESCRIPTION="API Support for your favorite torrent trackers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.1452"
TERMUX_PKG_SRCURL="https://github.com/Jackett/Jackett/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="00e9e139ba7ba0194e939c99db17c5cfcaec53d40b70440c561bc6c24bb65b5c"
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-8.0, dotnet-targeting-pack-8.0"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-8.0, dotnet-host, dotnet-runtime-8.0"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=("jackett" 'exec ${PREFIX}/bin/jackett --DataFolder ${HOME}/.config/jackett 2>&1')
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/jackett/libMono.Unix.so
"

termux_step_pre_configure() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	termux_setup_dotnet
}

termux_step_make() {
	dotnet publish src/Jackett.Server \
	--framework "net8.0" \
	--no-self-contained \
	--runtime "$DOTNET_TARGET_NAME" \
	--configuration Release \
	--output build/ \
	/p:AssemblyVersion="${TERMUX_PKG_VERSION}" \
	/p:FileVersion="${TERMUX_PKG_VERSION}" \
	/p:InformationalVersion="${TERMUX_PKG_VERSION}" \
	/p:Version="${TERMUX_PKG_VERSION}"
	dotnet build-server shutdown
}

termux_step_make_install() {
	cp -r build "${TERMUX_PREFIX}/lib/jackett"
	cat > $TERMUX_PREFIX/bin/jackett <<HERE
#!$TERMUX_PREFIX/bin/sh
export LD_LIBRARY_PATH=$TERMUX_PREFIX/lib:\$LD_LIBRARY_PATH
exec $TERMUX_PREFIX/lib/jackett/jackett --NoUpdates "\$@"
HERE
	chmod u+x $TERMUX_PREFIX/bin/jackett
}
