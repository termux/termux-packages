TERMUX_PKG_HOMEPAGE="https://github.com/jackett/jackett"
TERMUX_PKG_DESCRIPTION="API Support for your favorite torrent trackers"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24.394"
TERMUX_PKG_SRCURL="https://github.com/Jackett/Jackett/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=13a52642570aa2ad347b052566db18b7eaa120c4edd912919b8fe1fc16e31e04
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-9.0, dotnet-targeting-pack-9.0"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-9.0, dotnet-host, dotnet-runtime-9.0"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SERVICE_SCRIPT=("jackett" "exec ${TERMUX_PREFIX}/bin/jackett --DataFolder ${TERMUX_ANDROID_HOME}/.config/jackett 2>&1")
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/jackett/README.md
lib/jackett/LICENSE
lib/jackett/jackett.pdb
lib/jackett/Jackett.Common.pdb
lib/jackett/DateTimeRoutines.pdb
"

termux_step_pre_configure() {
	TERMUX_DOTNET_VERSION=9.0
	termux_setup_dotnet
}

termux_step_make() {
	dotnet publish src/Jackett.Server \
	--framework "net${TERMUX_DOTNET_VERSION}" \
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
	rm -fr "${TERMUX_PREFIX}/lib/jackett"
	mkdir -p "${TERMUX_PREFIX}/lib"
	cp -r build "${TERMUX_PREFIX}/lib/jackett"
	cat > $TERMUX_PREFIX/bin/jackett <<-HERE
	#!$TERMUX_PREFIX/bin/sh
	exec dotnet $TERMUX_PREFIX/lib/jackett/jackett.dll --NoUpdates "\$@"
	HERE
	chmod u+x $TERMUX_PREFIX/bin/jackett
}
