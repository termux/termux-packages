TERMUX_PKG_HOMEPAGE="https://github.com/jackett/jackett"
TERMUX_PKG_DESCRIPTION="API Support for your favorite torrent trackers"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.24.2277"
TERMUX_PKG_SRCURL="https://github.com/Jackett/Jackett/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=71667a30e0ca3052298906ef4db59c20883426f54bd57ad44861ccd3e1b9bfdd
TERMUX_PKG_DEPENDS="aspnetcore-runtime-10.0, dotnet-host, dotnet-runtime-10.0"
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-10.0, dotnet-targeting-pack-10.0"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_SERVICE_SCRIPT=("jackett" "exec ${TERMUX_PREFIX}/bin/jackett --DataFolder ${TERMUX_ANDROID_HOME}/.config/jackett 2>&1")
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
lib/jackett/README.md
lib/jackett/LICENSE
lib/jackett/jackett.pdb
lib/jackett/Jackett.Common.pdb
lib/jackett/DateTimeRoutines.pdb
"

# This auto update function throttles the update frequency
# of the package to set `$update_interval`, this is useful
# for packages that make very frequent tags like `jackett`
# or `llama-cpp` to not spam the commit history, CI and repos.
termux_pkg_auto_update() {
	local origin_url last_autoupdate
	# Throttle auto updates to once a week.
	local update_interval="$((7 * 86400))"

	# Get the git history
	if origin_url="$(git config --get remote.origin.url)"; then
		git fetch --quiet "${origin_url}" || {
			echo "WARN: Unable to fetch '${origin_url}'"
			echo "WARN: Skipping auto update for '$TERMUX_PKG_NAME'"
			return
		}
	fi

	# When was `jackett` last autoupdated? (Unix epoch timestamp)
	last_autoupdate="$(
		git log \
		--author="Termux Github Actions <contact@termux.dev>" \
		-n1 \
		--pretty=format:%at \
		-- "$TERMUX_PKG_BUILDER_DIR/build.sh"
	)"


	if (( last_autoupdate > EPOCHSECONDS - update_interval )); then
		local t days hrs mins secs
		(( t = EPOCHSECONDS - last_autoupdate, days = t/86400, t %= 86400, secs= t%60, t /= 60, mins = t%60, hrs = t/60 ))

		printf 'INFO: Last updated %dd%dh%02dm%02ds ago.\n' "$days" "$hrs" "$mins" "$secs"
		printf 'INFO: Which is less than the desired %sd minimum update interval.\n' "$(( update_interval / 86400 ))"
		return
	fi

	local latest_tag
	latest_tag="$(
		termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}"
	)"

	if [[ -z "${latest_tag}" ]]; then
		termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	fi
	termux_pkg_upgrade_version "${latest_tag}"
}

termux_step_pre_configure() {
	TERMUX_DOTNET_VERSION=10.0
	termux_setup_dotnet

	# Clone, patch, and build custom AngleSharp
	local anglesharp_dir="$TERMUX_PKG_BUILDDIR/AngleSharp-src"
	rm -rf "$anglesharp_dir"
	git clone --depth 1 --branch 1.5.2 https://github.com/AngleSharp/AngleSharp.git "$anglesharp_dir"
	cd "$anglesharp_dir"
	patch -p1 <"$TERMUX_PKG_BUILDER_DIR/anglesharp-jit-fix.diff"
	dotnet build -c Release -f "net${TERMUX_DOTNET_VERSION}" src/AngleSharp/AngleSharp.Core.csproj
	cd "$TERMUX_PKG_SRCDIR"

	# Force all projects to target .NET 10.0
	find src -name "*.csproj" -exec sed -i "s/<TargetFrameworks>.*<\/TargetFrameworks>/<TargetFrameworks>net${TERMUX_DOTNET_VERSION}<\/TargetFrameworks>/g" {} +
	find src -name "*.csproj" -exec sed -i "s/<TargetFramework>.*<\/TargetFramework>/<TargetFramework>net${TERMUX_DOTNET_VERSION}<\/TargetFramework>/g" {} +

	# Update Microsoft.Extensions, Microsoft.AspNetCore and specific System packages to 10.0.0 for compatibility with .NET 10.0
	find src -name "*.csproj" -exec sed -i 's/Include="Microsoft\.Extensions\.\([^"]*\)" Version="[0-9.]*"/Include="Microsoft.Extensions.\1" Version="10.0.0"/g' {} +
	find src -name "*.csproj" -exec sed -i 's/Include="Microsoft\.AspNetCore\.\([^"]*\)" Version="[0-9.]*"/Include="Microsoft.AspNetCore.\1" Version="10.0.0"/g' {} +
	find src -name "*.csproj" -exec sed -i 's/Include="System\.ServiceProcess\.ServiceController" Version="[0-9.]*"/Include="System.ServiceProcess.ServiceController" Version="10.0.0"/g' {} +

	# Remove obsolete System.* package references that are built into .NET 10.0
	find src -name "*.csproj" -exec sed -i '/Include="System\.\(ValueTuple\|Memory\|Runtime\.Loader\|Threading\.Tasks\.Extensions\)"/d' {} +

	# Microsoft.AspNetCore.Http and .WebUtilities don't exist as standalone NuGet packages for .NET 10.
	# Jackett.Common uses Microsoft.NET.Sdk (not .Web) and its FrameworkReference entries are only
	# inside net471/net9.0 conditional blocks — none apply to net10.0. Remove the dead package refs
	# and inject an unconditional FrameworkReference so ASP.NET Core types are available.
	find src -name "*.csproj" -exec sed -i '/Include="Microsoft\.AspNetCore\.\(Http\|WebUtilities\)"/d' {} +
	python3 -c "
import re, sys
path = 'src/Jackett.Common/Jackett.Common.csproj'
content = open(path).read()
inject = '  <ItemGroup>\n    <FrameworkReference Include=\"Microsoft.AspNetCore.App\" />\n  </ItemGroup>\n\n'
content = re.sub(r'(?=\s*<ItemGroup>)', inject, content, count=1)
open(path, 'w').write(content)
"

	# Fix conditional ItemGroup that targets net9.0 in Jackett.Server — update to net10.0 so that
	# packages like Microsoft.AspNetCore.Mvc.NewtonsoftJson are included when building for net10.0.
	find src -name "*.csproj" -exec sed -i "s/'\$(TargetFramework)' == 'net9\.0'/'\$(TargetFramework)' == 'net${TERMUX_DOTNET_VERSION}'/g" {} +
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

	# Overwrite restored AngleSharp.dll with our JIT-patch-compiled one
	cp -f "$TERMUX_PKG_BUILDDIR/AngleSharp-src/src/AngleSharp/bin/Release/net${TERMUX_DOTNET_VERSION}/AngleSharp.dll" build/

	# Lower required .NET version in runtimeconfig.json to allow running on older .NET 10.0.x runtimes
	find build -name "*.runtimeconfig.json" -exec sed -i 's/"version": "10.0.[0-9]*"/"version": "10.0.0"/g' {} +

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
