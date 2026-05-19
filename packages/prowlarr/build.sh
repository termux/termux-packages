TERMUX_PKG_HOMEPAGE="https://prowlarr.com"
TERMUX_PKG_DESCRIPTION="An indexer manager/proxy built on the popular arr stack (server)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.7.5365"
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL="https://github.com/Prowlarr/Prowlarr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=db04bf9da5e515c5a7295a093710cf6763e5990600bb5178684c42781d97fd0d
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-9.0, dotnet-targeting-pack-9.0, nodejs, yarn"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-9.0, dotnet-host, dotnet-runtime-9.0, mono, libesqlite3, libcurl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=(
	"prowlarr"
	"exec ${TERMUX_PREFIX}/bin/prowlarr -nobrowser 2>&1"
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

	dotnet publish src/NzbDrone.Console/Prowlarr.Console.csproj "${COMMON_ARGS[@]}"

	# Prowlarr.Mono is dynamically loaded at runtime on Linux/macOS
	dotnet publish src/NzbDrone.Mono/Prowlarr.Mono.csproj "${COMMON_ARGS[@]}"

	dotnet build-server shutdown
}

termux_step_make_install() {
	# Remove bundled native libs that we want to use from system
	rm -f build/{libe_sqlite3,libMonoPosixHelper}.so*

	rm -rf "${TERMUX_PREFIX}/lib/prowlarr"
	mkdir -p "${TERMUX_PREFIX}/lib/prowlarr"

	# Copy build artifacts
	cp -r build/* "${TERMUX_PREFIX}/lib/prowlarr/"

	# Copy UI files
	mkdir -p "${TERMUX_PREFIX}/lib/prowlarr/UI"
	cp -r _output/UI/* "${TERMUX_PREFIX}/lib/prowlarr/UI/"

	# Create launch script
	cat > "${TERMUX_PREFIX}/bin/prowlarr" <<-HERE
		#!${TERMUX_PREFIX}/bin/sh
		exec dotnet "${TERMUX_PREFIX}/lib/prowlarr/Prowlarr.dll" "\$@"
	HERE
	chmod u+x "${TERMUX_PREFIX}/bin/prowlarr"
}
