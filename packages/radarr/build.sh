TERMUX_PKG_HOMEPAGE="https://radarr.video"
TERMUX_PKG_DESCRIPTION="A PVR for Usenet and BitTorrent users (server)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.2.0.10390"
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL="https://github.com/Radarr/Radarr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=79802cbabfcd1e0c18319e0ccf36dc8f2521b8914ba2b020357fdbccc7fab9a7
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-9.0, dotnet-targeting-pack-9.0, nodejs, yarn"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-9.0, dotnet-host, dotnet-runtime-9.0, mono, libesqlite3, libcurl, ffmpeg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=(
	"radarr"
	"exec ${TERMUX_PREFIX}/bin/radarr -nobrowser 2>&1"
)
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_pre_configure() {
	# Remove global.json to allow using system dotnet version
	rm -f global.json

	TERMUX_DOTNET_VERSION=9.0
	termux_setup_dotnet
	termux_setup_nodejs

	# Patch Directory.Build.props to disable TreatWarningsAsErrors and ignore vulnerabilities
	sed -i 's/<TreatWarningsAsErrors>true<\/TreatWarningsAsErrors>/<TreatWarningsAsErrors>false<\/TreatWarningsAsErrors>/g' src/Directory.Build.props
	sed -i 's/<EnforceCodeStyleInBuild>true<\/EnforceCodeStyleInBuild>/<EnforceCodeStyleInBuild>false<\/EnforceCodeStyleInBuild>/g' src/Directory.Build.props
	sed -i 's/<AnalysisLevel>.*<\/AnalysisLevel>/<AnalysisLevel>none<\/AnalysisLevel>/g' src/Directory.Build.props
	sed -i 's/<GenerateDocumentationFile>true<\/GenerateDocumentationFile>/<GenerateDocumentationFile>false<\/GenerateDocumentationFile>/g' src/Directory.Build.props
	sed -i '/<NoWarn>$(NoWarn);CS1591<\/NoWarn>/a \    <NoWarn>$(NoWarn);NU1901;NU1902;NU1903;NU1904;NU1605</NoWarn>' src/Directory.Build.props
	sed -i '/<PropertyGroup>/a \    <RunAnalyzersDuringBuild>false</RunAnalyzersDuringBuild>' src/Directory.Build.props

	# Force all projects to target .NET 9.0
	find src -name "*.csproj" -exec sed -i 's/<TargetFrameworks>.*<\/TargetFrameworks>/<TargetFrameworks>net9.0<\/TargetFrameworks>/g' {} +
	find src -name "*.csproj" -exec sed -i 's/<TargetFramework>.*<\/TargetFramework>/<TargetFramework>net9.0<\/TargetFramework>/g' {} +

	# Update Microsoft.Extensions and specific System packages to 9.0.0 for compatibility with .NET 9.0
	find src -name "*.csproj" -exec sed -i 's/Include="Microsoft\.Extensions\.\([^"]*\)" Version="[0-9.]*"/Include="Microsoft.Extensions.\1" Version="9.0.0"/g' {} +
	find src -name "*.csproj" -exec sed -i 's/Include="System\.ServiceProcess\.ServiceController" Version="[0-9.]*"/Include="System.ServiceProcess.ServiceController" Version="9.0.0"/g' {} +

	# Remove obsolete System.* package references that are built into .NET 9.0
	find src -name "*.csproj" -exec sed -i '/Include="System\.\(ValueTuple\|Memory\|Runtime\.Loader\|Threading\.Tasks\.Extensions\)"/d' {} +

	# Build UI
	export NODE_OPTIONS="--max-old-space-size=4096"
	yarn install
	yarn build --env production
}

termux_step_make() {
	local COMMON_ARGS=(
		--framework "net${TERMUX_DOTNET_VERSION}"
		--no-self-contained
		--runtime "${DOTNET_TARGET_NAME}"
		--configuration Release
		--output build/
		--verbosity minimal
		-m:1
		-nodeReuse:false
		-p:UseSharedCompilation=false
		-p:Platform=Posix
		-p:DebugType=None
		-p:PublishRepositoryUrl=false
		-p:EmbedAllSources=false
		-p:AssemblyVersion="${TERMUX_PKG_VERSION}"
		-p:FileVersion="${TERMUX_PKG_VERSION}"
		-p:InformationalVersion="${TERMUX_PKG_VERSION}"
		-p:Version="${TERMUX_PKG_VERSION}"
	)

	dotnet publish src/NzbDrone.Console/Radarr.Console.csproj "${COMMON_ARGS[@]}"

	# Radarr.Mono is dynamically loaded at runtime on Linux/macOS
	dotnet publish src/NzbDrone.Mono/Radarr.Mono.csproj "${COMMON_ARGS[@]}"

	dotnet build-server shutdown
}

termux_step_make_install() {
	# Remove bundled native libs that we want to use from system
	rm -f build/{libe_sqlite3,libMonoPosixHelper}.so*

	rm -rf "${TERMUX_PREFIX}/lib/radarr"
	mkdir -p "${TERMUX_PREFIX}/lib/radarr"

	# Copy build artifacts
	cp -r build/* "${TERMUX_PREFIX}/lib/radarr/"

	# Copy UI files
	mkdir -p "${TERMUX_PREFIX}/lib/radarr/UI"
	cp -r _output/UI/* "${TERMUX_PREFIX}/lib/radarr/UI/"

	# Create symlinks for ffmpeg/ffprobe
	ln -sf "${TERMUX_PREFIX}/bin/ffmpeg" "${TERMUX_PREFIX}/lib/radarr/ffmpeg"
	ln -sf "${TERMUX_PREFIX}/bin/ffprobe" "${TERMUX_PREFIX}/lib/radarr/ffprobe"

	# Create launch script
	cat > "${TERMUX_PREFIX}/bin/radarr" <<-HERE
		#!${TERMUX_PREFIX}/bin/sh
		exec dotnet "${TERMUX_PREFIX}/lib/radarr/Radarr.dll" "\$@"
	HERE
	chmod u+x "${TERMUX_PREFIX}/bin/radarr"
}
