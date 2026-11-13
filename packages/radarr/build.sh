TERMUX_PKG_HOMEPAGE="https://radarr.video"
TERMUX_PKG_DESCRIPTION="A PVR for Usenet and BitTorrent users (server)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.0.2.10888"
TERMUX_PKG_SRCURL="https://github.com/Radarr/Radarr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d71e54d54980fb740528aa4184f750b53f60fded66151d0332b646a56fcbb6de
TERMUX_PKG_BUILD_DEPENDS="aspnetcore-targeting-pack-10.0, dotnet-targeting-pack-10.0, nodejs, yarn"
TERMUX_PKG_DEPENDS="aspnetcore-runtime-10.0, dotnet-host, dotnet-runtime-10.0, libesqlite3, libcurl, ffmpeg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=(
	"radarr"
	"exec ${TERMUX_PREFIX}/bin/radarr -nobrowser 2>&1"
)
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_DOTNET_VERSION=10.0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_pre_configure() {
	# Remove global.json to allow using system dotnet version
	rm -f global.json

	termux_setup_dotnet
	termux_setup_nodejs

	# Create a host wrapper for yarn since the one in $TERMUX_PREFIX/bin
	# has a shebang pointing to the target node
	local bin="$TERMUX_PKG_BUILDDIR/_bin"
	mkdir -p "$bin"
	local yarn="$bin/yarn"
	cat >"$yarn" <<-EOF
		#!/bin/sh
		exec node $TERMUX_PREFIX/share/yarn/bin/yarn.js "\$@"
	EOF
	chmod 0755 "$yarn"
	export PATH="$bin:$PATH"

	# Patch Directory.Build.props to disable TreatWarningsAsErrors and ignore vulnerabilities
	sed -i 's/<TreatWarningsAsErrors>true<\/TreatWarningsAsErrors>/<TreatWarningsAsErrors>false<\/TreatWarningsAsErrors>/g' src/Directory.Build.props
	sed -i 's/<EnforceCodeStyleInBuild>true<\/EnforceCodeStyleInBuild>/<EnforceCodeStyleInBuild>false<\/EnforceCodeStyleInBuild>/g' src/Directory.Build.props
	sed -i 's/<AnalysisLevel>.*<\/AnalysisLevel>/<AnalysisLevel>none<\/AnalysisLevel>/g' src/Directory.Build.props
	sed -i 's/<GenerateDocumentationFile>true<\/GenerateDocumentationFile>/<GenerateDocumentationFile>false<\/GenerateDocumentationFile>/g' src/Directory.Build.props
	sed -i '/<NoWarn>$(NoWarn);CS1591<\/NoWarn>/a \    <NoWarn>$(NoWarn);NU1901;NU1902;NU1903;NU1904;NU1605</NoWarn>' src/Directory.Build.props
	sed -i '/<PropertyGroup>/a \    <RunAnalyzersDuringBuild>false</RunAnalyzersDuringBuild>' src/Directory.Build.props

	# Build UI
	export NODE_OPTIONS="--max-old-space-size=4096"
	yarn install
	yarn build --env production
}

termux_step_make() {
	termux_setup_dotnet
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

	# Lower required .NET version in runtimeconfig.json to allow running on older .NET 10.0.x runtimes
	find build -name "*.runtimeconfig.json" -exec sed -i 's/"version": "10.0.[0-9]*"/"version": "10.0.0"/g' {} +

	dotnet build-server shutdown
}

termux_step_make_install() {
	# Remove bundled native libs (we use system sqlite and provide Android bionic libMono.Unix)
	rm -f build/{libe_sqlite3,libMono.Unix}.so*

	rm -rf "${TERMUX_PREFIX}/lib/radarr"
	mkdir -p "${TERMUX_PREFIX}/lib/radarr"

	# Copy build artifacts
	cp -r build/* "${TERMUX_PREFIX}/lib/radarr/"

	# Install native Android libMono.Unix.so bundled in Openur.Mono.Unix NuGet package
	local nuget_packages_dir="${NUGET_PACKAGES:-$HOME/.nuget/packages}"
	local mono_arch
	case "${TERMUX_ARCH}" in
		aarch64) mono_arch="android-arm64" ;;
		i686)    mono_arch="android-x86" ;;
		x86_64)  mono_arch="android-x64" ;;
	esac

	local nuget_mono_so
	nuget_mono_so=$(find "${nuget_packages_dir}/openur.mono.unix" -path "*/runtimes/${mono_arch}/native/libMono.Unix.so" | head -n1)
	[ -f "${nuget_mono_so}" ] || termux_error_exit "libMono.Unix.so not found for ${mono_arch}"
	cp "${nuget_mono_so}" "${TERMUX_PREFIX}/lib/radarr/libMono.Unix.so"

	# Copy UI files
	mkdir -p "${TERMUX_PREFIX}/lib/radarr/UI"
	cp -r _output/UI/* "${TERMUX_PREFIX}/lib/radarr/UI/"

	# Create symlinks for ffmpeg/ffprobe
	ln -sf "${TERMUX_PREFIX}/bin/ffmpeg" "${TERMUX_PREFIX}/lib/radarr/ffmpeg"
	ln -sf "${TERMUX_PREFIX}/bin/ffprobe" "${TERMUX_PREFIX}/lib/radarr/ffprobe"

	# Create launch script
	cat >"${TERMUX_PREFIX}/bin/radarr" <<-HERE
		#!${TERMUX_PREFIX}/bin/sh
		exec dotnet "${TERMUX_PREFIX}/lib/radarr/Radarr.dll" "\$@"
	HERE
	chmod u+x "${TERMUX_PREFIX}/bin/radarr"
}
