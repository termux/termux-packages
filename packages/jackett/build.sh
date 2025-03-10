TERMUX_PKG_HOMEPAGE="https://github.com/jackett/jackett"
TERMUX_PKG_DESCRIPTION="API Support for your favorite torrent trackers"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.1468"
TERMUX_PKG_SRCURL="https://github.com/Jackett/Jackett/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="19a3017691273a6505a2a64046e5459b97e080e7469d9cab2f246bc04e62a40e"
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-8.0, dotnet-targeting-pack-8.0"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-8.0, dotnet-host, dotnet-runtime-8.0"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=("jackett" "exec ${TERMUX_PREFIX}/bin/jackett --DataFolder ${TERMUX_ANDROID_HOME}/.config/jackett 2>&1")
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
TERMUX_PKG_RM_AFTER_INSTALL="
lib/jackett/libMono.Unix.so
lib/jackett/README.md
lib/jackett/LICENSE
lib/jackett/jackett.pdb
lib/jackett/Jackett.Common.pdb
lib/jackett/DateTimeRoutines.pdb
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
	mkdir -p "${TERMUX_PREFIX}/lib/jackett"
	cp -r build/* "${TERMUX_PREFIX}/lib/jackett"
	cat > "$TERMUX_PREFIX/bin/jackett" <<-EOF
	#!$TERMUX_PREFIX/bin/sh
	exec dotnet $TERMUX_PREFIX/lib/jackett/jackett.dll --NoUpdates "\$@"
	EOF
	chmod u+x "$TERMUX_PREFIX/bin/jackett"
}
