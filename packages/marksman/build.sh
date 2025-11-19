TERMUX_PKG_HOMEPAGE="https://github.com/artempyanykh/marksman"
TERMUX_PKG_DESCRIPTION="LSP language server for editing Markdown files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="2024.12.18"
TERMUX_PKG_SRCURL="git+https://github.com/artempyanykh/marksman"
TERMUX_PKG_GIT_BRANCH="main"
TERMUX_PKG_DEPENDS="dotnet-host, dotnet-runtime-8.0"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_post_get_source() {
	git fetch --tags
	git checkout "${TERMUX_PKG_VERSION//\./-}"
}

termux_step_pre_configure() {
	termux_setup_dotnet
}

termux_step_make() {
	dotnet publish \
	--framework "net8.0" \
	--no-self-contained \
	--runtime "$DOTNET_TARGET_NAME" \
	--configuration Release \
	-p:AssemblyVersion="${TERMUX_PKG_VERSION}" \
	-p:FileVersion="${TERMUX_PKG_VERSION}" \
	-p:InformationalVersion="${TERMUX_PKG_VERSION}" \
	-p:Version="${TERMUX_PKG_VERSION}"
	dotnet build-server shutdown
}

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/lib/marksman"
	cp -r "Marksman/bin/Release/net8.0/$DOTNET_TARGET_NAME/publish"/*.dll "${TERMUX_PREFIX}/lib/marksman"
	cp    "Marksman/bin/Release/net8.0/$DOTNET_TARGET_NAME/publish/marksman.runtimeconfig.json" "${TERMUX_PREFIX}/lib/marksman/"
	cat > "$TERMUX_PREFIX/bin/marksman" <<-HERE
	#!$TERMUX_PREFIX/bin/sh
	exec dotnet $TERMUX_PREFIX/lib/marksman/marksman.dll "\$@"
	HERE
	chmod u+x "$TERMUX_PREFIX/bin/marksman"
}
