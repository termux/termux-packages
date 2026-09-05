TERMUX_PKG_HOMEPAGE=https://learn.microsoft.com/en-us/powershell/
TERMUX_PKG_DESCRIPTION="Cross-platform automation and configuration tool/framework"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.4.19"
TERMUX_PKG_SRCURL=git+https://github.com/PowerShell/PowerShell
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="dotnet-host, dotnet-runtime-8.0, libc++, libpsl-native, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="dotnet-sdk-8.0, dotnet-targeting-pack-8.0"
TERMUX_DOTNET_VERSION=8.0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/PowerShell/PowerShell/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | sed -ne "s|.*/v\(.*\)\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | grep -E '^7\.4\.' | grep -v preview | sort -V | tail -n1)

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	rm -f global.json

	termux_setup_dotnet

	# Setup dependency-gatherer targets for TypeCatalogGen
	mkdir -p src/Microsoft.PowerShell.SDK/obj
	cat <<- TARGETS > src/Microsoft.PowerShell.SDK/obj/Microsoft.PowerShell.SDK.csproj.TypeCatalog.targets
	<Project>
	    <Target Name="_GetDependencies"
	            DependsOnTargets="ResolveAssemblyReferencesDesignTime">
	        <ItemGroup>
	            <_RefAssemblyPath Include="%(_ReferencesFromRAR.OriginalItemSpec)%3B" Condition=" '%(_ReferencesFromRAR.NuGetPackageId)' != 'Microsoft.Management.Infrastructure' "/>
	        </ItemGroup>
	        <WriteLinesToFile File="\$(_DependencyFile)" Lines="@(_RefAssemblyPath)" Overwrite="true" />
	    </Target>
	</Project>
	TARGETS
}

termux_step_make() {
	termux_setup_dotnet

	# Restore projects
	dotnet restore src/Modules/PSGalleryModules.csproj
	dotnet restore src/ResGen
	dotnet restore src/TypeCatalogGen
	dotnet restore src/powershell-unix

	# Generate resource bindings
	(
		cd src/ResGen
		dotnet run --no-restore
	)

	# Generate type catalog
	dotnet msbuild src/Microsoft.PowerShell.SDK/Microsoft.PowerShell.SDK.csproj \
		/t:_GetDependencies \
		"/property:DesignTimeBuild=true;_DependencyFile=${TERMUX_PKG_SRCDIR}/src/TypeCatalogGen/powershell.inc" \
		-m:1 -nodeReuse:false -p:UseSharedCompilation=false /nologo

	(
		cd src/TypeCatalogGen
		dotnet run --no-restore ../System.Management.Automation/CoreCLR/CorePsTypeCatalog.cs powershell.inc
	)

	# Publish PowerShell Core
	dotnet publish src/powershell-unix \
		--configuration Release \
		--output "${TERMUX_PKG_BUILDDIR}/publish" \
		--framework "net${TERMUX_DOTNET_VERSION}" \
		--no-self-contained \
		-m:1 -nodeReuse:false -p:UseSharedCompilation=false -p:PublishReadyToRun=false \
		/nologo

	# Populate bundled modules from NuGet cache
	local NUGET_CACHE
	NUGET_CACHE="$(dotnet nuget locals global-packages -l | awk '{print $2}')"
	if [[ -z "${NUGET_CACHE}" || ! -d "${NUGET_CACHE}" ]]; then
		NUGET_CACHE="${HOME}/.nuget/packages"
	fi

	local modules="
		PackageManagement:packagemanagement
		PowerShellGet:powershellget
		Microsoft.PowerShell.PSResourceGet:microsoft.powershell.psresourceget
		Microsoft.PowerShell.Archive:microsoft.powershell.archive
		PSReadLine:psreadline
		ThreadJob:threadjob
	"

	local mod_dest="${TERMUX_PKG_BUILDDIR}/publish/Modules"
	mkdir -p "${mod_dest}"

	for entry in $modules; do
		local name="${entry%%:*}"
		local pkg="${entry##*:}"
		local ver_dir
		ver_dir="$(find "${NUGET_CACHE}/${pkg}" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n 1)"
		if [[ -n "${ver_dir}" && -d "${ver_dir}" ]]; then
			rm -rf "${mod_dest}/${name}"
			mkdir -p "${mod_dest}/${name}"
			cp -r "${ver_dir}"/* "${mod_dest}/${name}/"
			rm -f "${mod_dest}/${name}"/*.nupkg* "${mod_dest}/${name}"/*.nuspec "${mod_dest}/${name}/System.Runtime.InteropServices.RuntimeInformation.dll"
			rm -rf "${mod_dest}/${name}/fullclr" "${mod_dest}/${name}/_manifest"
		fi
	done

	# Ensure PSReadLine Polyfiller is in the module root so it resolves properly
	if [[ -f "${mod_dest}/PSReadLine/net6plus/Microsoft.PowerShell.PSReadLine.Polyfiller.dll" ]]; then
		cp -f "${mod_dest}/PSReadLine/net6plus/Microsoft.PowerShell.PSReadLine.Polyfiller.dll" "${mod_dest}/PSReadLine/"
	fi

	dotnet build-server shutdown
	termux_dotnet_kill
}

termux_step_make_install() {
	rm -rf "${TERMUX_PREFIX}/lib/powershell"
	mkdir -p "${TERMUX_PREFIX}/lib/powershell"

	# Fix file permissions and copy
	find "${TERMUX_PKG_BUILDDIR}/publish" -name "*.a" -exec chmod a-x "{}" \;
	find "${TERMUX_PKG_BUILDDIR}/publish" -name "*.dll" -exec chmod a-x "{}" \;
	find "${TERMUX_PKG_BUILDDIR}/publish" -name "*.so" -exec chmod a-x "{}" \;
	rm -fv "${TERMUX_PKG_BUILDDIR}/publish/libSystem.IO.Ports.Native.so"

	cp -r "${TERMUX_PKG_BUILDDIR}/publish"/* "${TERMUX_PREFIX}/lib/powershell/"

	# Stub libpsl-native.so
	ln -fsv ../libpsl-native.so "${TERMUX_PREFIX}/lib/powershell/libpsl-native.so"

	# Symlinks for OpenSSL
	ln -fsv ../libcrypto.so "${TERMUX_PREFIX}/lib/powershell/libcrypto.so"
	ln -fsv ../libssl.so "${TERMUX_PREFIX}/lib/powershell/libssl.so"

	# Launcher script
	cat <<- EOL > "${TERMUX_PREFIX}/bin/pwsh"
	#!${TERMUX_PREFIX}/bin/sh
	export LD_LIBRARY_PATH="${TERMUX_PREFIX}/lib/powershell:\${LD_LIBRARY_PATH}"
	exec "${TERMUX_PREFIX}/lib/powershell/pwsh" "\$@"
	EOL
	chmod +x "${TERMUX_PREFIX}/bin/pwsh"
}
