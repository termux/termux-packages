TERMUX_PKG_HOMEPAGE=https://github.com/JustArchiNET/ArchiSteamFarm
TERMUX_PKG_DESCRIPTION="ArchiSteamFarm"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1.2.3"
TERMUX_PKG_SRCURL=git+https://github.com/JustArchiNET/ArchiSteamFarm
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="aspnetcore-runtime-9.0, dotnet-host, dotnet-runtime-9.0"
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-9.0, dotnet-targeting-pack-9.0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm"
TERMUX_DOTNET_VERSION=9.0

termux_step_pre_configure() {
	termux_setup_dotnet
	termux_setup_nodejs
}

termux_step_make() {
	./cc.sh
}

termux_step_make_install() {
	ls -l out
	ls -l out/result

	find out -name "*.a" -exec chmod 0644 "{}" \;
	find out -name "*.dll" -exec chmod 0644 "{}" \;
	find out -name "*.so" -exec chmod 0644 "{}" \;

	mkdir -p "${TERMUX_PREFIX}/lib"
	cp -r out/result "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"

	cat <<- EOL > ${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}
	#!${TERMUX_PREFIX}/bin/sh
	exec dotnet "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}/ArchiSteamFarm.dll" "\$@"
	EOL
	chmod 0755 "${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}"
}
