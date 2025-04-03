TERMUX_PKG_HOMEPAGE="https://github.com/jackett/jackett"
TERMUX_PKG_DESCRIPTION="API Support for your favorite torrent trackers"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.1722"
TERMUX_PKG_SRCURL="https://github.com/Jackett/Jackett/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8d9dc73922b90d773bc88ecd310e7d878a31aad0f5cf60458813c1d1a03f323c
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-8.0, dotnet-targeting-pack-8.0"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-8.0, dotnet-host, dotnet-runtime-8.0"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SERVICE_SCRIPT=("jackett" "exec ${TERMUX_PREFIX}/bin/jackett --DataFolder ${TERMUX_ANDROID_HOME}/.config/jackett 2>&1")
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/jackett/README.md
lib/jackett/LICENSE
lib/jackett/jackett.pdb
lib/jackett/Jackett.Common.pdb
lib/jackett/DateTimeRoutines.pdb
"

termux_step_pre_configure() {
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
	cat > $TERMUX_PREFIX/bin/jackett <<-HERE
	#!$TERMUX_PREFIX/bin/sh
	exec dotnet $TERMUX_PREFIX/lib/jackett/jackett.dll --NoUpdates "\$@"
	HERE
	chmod u+x $TERMUX_PREFIX/bin/jackett
}
