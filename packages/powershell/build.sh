TERMUX_PKG_HOMEPAGE=https://learn.microsoft.com/en-us/powershell/
TERMUX_PKG_DESCRIPTION="Cross-platform automation and configuration tool/framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.4.5"
TERMUX_PKG_SRCURL=git+https://github.com/PowerShell/PowerShell
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="libc++, libpsl-native, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# .../src/powershell-unix/powershell-unix.csproj : error NU1101: Unable to find package Microsoft.NETCore.App.Host.linux-bionic-arm. No packages exist with this id in source(s): dotnet, nuget.org
# .../src/powershell-unix/powershell-unix.csproj : error NU1101: Unable to find package Microsoft.NETCore.App.Host.linux-bionic-x86. No packages exist with this id in source(s): dotnet, nuget.org
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/PowerShell/PowerShell/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | sed -ne "s|.*/v\(.*\)\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | grep -v preview | sort -V | tail -n1)

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	# https://github.com/PowerShell/PowerShell/issues/21385
	# not working for Ubuntu 24.04
	#echo "./tools/install-powershell.sh"
	#./tools/install-powershell.sh

	# remove below once above is solved
	curl -L https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/p/powershell-preview/powershell-preview_7.5.0-preview.5-1.deb_amd64.deb -o $TERMUX_PKG_CACHEDIR/powershell.deb
	/usr/bin/sudo apt install -y $TERMUX_PKG_CACHEDIR/powershell.deb
	dpkg -L powershell-preview
	ln -fsv /usr/bin/pwsh-preview ${TERMUX_PKG_TMPDIR}/pwsh
	PATH="${TERMUX_PKG_TMPDIR}:${PATH}"

	command -v pwsh

	export DOTNET_TARGET_NAME="linux-bionic-${TERMUX_ARCH}"
	case "${TERMUX_ARCH}" in
	aarch64) DOTNET_TARGET_NAME="linux-bionic-arm64" ;;
	i686) DOTNET_TARGET_NAME="linux-bionic-x86" ;;
	x86_64) DOTNET_TARGET_NAME="linux-bionic-x64" ;;
	esac

	export CONFIG="Release"
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		CONFIG="Debug"
	fi
}

termux_step_make() {
	pwsh -Command "
	Import-Module ./build.psm1
	Start-PSBootstrap
	Start-PSBuild -Configuration ${CONFIG} -Runtime ${DOTNET_TARGET_NAME}
	"
}

termux_step_make_install() {
	pushd src/powershell-unix/bin/${CONFIG}/net8.0/${DOTNET_TARGET_NAME}
	# fix file permission
	find publish -name "*.a" -exec chmod a-x "{}" \;
	find publish -name "*.dll" -exec chmod a-x "{}" \;
	find publish -name "*.so" -exec chmod a-x "{}" \;
	# points to ld-linux-*.so.1, useless?
	${READELF} -d libSystem.IO.Ports.Native.so
	rm -fv libSystem.IO.Ports.Native.so
	# copy all the files
	cp -r publish ${TERMUX_PREFIX}/lib/powershell
	popd

	# stub libpsl-native.so that need to be replaced
	ln -fsv ../libpsl-native.so ${TERMUX_PREFIX}/lib/powershell/libpsl-native.so

	# shell script wrapper for
	# System.Security.Cryptography.Native.OpenSsl
	# to find and dlopen libssl.so
	ln -fsv ../libcrypto.so ${TERMUX_PREFIX}/lib/powershell/libcrypto.so
	ln -fsv ../libssl.so ${TERMUX_PREFIX}/lib/powershell/libssl.so
	cat <<- EOL > "${TERMUX_PREFIX}/bin/pwsh"
	#!${TERMUX_PREFIX}/bin/sh
	export LD_LIBRARY_PATH=${TERMUX_PREFIX}/lib/powershell:\${LD_LIBRARY_PATH}
	exec "${TERMUX_PREFIX}/lib/powershell/pwsh" "\$@"
	EOL
	chmod +x "${TERMUX_PREFIX}/bin/pwsh"

	unset CONFIG DOTNET_TARGET_NAME
}
