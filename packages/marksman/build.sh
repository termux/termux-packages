TERMUX_PKG_HOMEPAGE="https://github.com/artempyanykh/marksman"
TERMUX_PKG_DESCRIPTION="LSP language server for editing Markdown files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="2026.02.08"
TERMUX_PKG_SRCURL="https://github.com/artempyanykh/marksman/archive/refs/tags/${TERMUX_PKG_VERSION//\./-}.tar.gz"
TERMUX_PKG_SHA256=a3ba5f8ef5be5d7ede2ec5ae9f303d2d776f476734ff66254be8e6df0e0f090e
TERMUX_PKG_DEPENDS="dotnet-host, dotnet-runtime-9.0"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/-/./g"

termux_step_pre_configure() {
	TERMUX_DOTNET_VERSION=9.0
	termux_setup_dotnet

	local patch="$TERMUX_PKG_BUILDER_DIR/version.diff"
	echo "Applying patch: $patch"
	sed -e "s%\@TERMUX_PKG_VERSION\@%${TERMUX_PKG_VERSION}%g" \
		"$patch" | patch --silent -p1
}

termux_step_make() {
	dotnet publish \
	--framework "net${TERMUX_DOTNET_VERSION}" \
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
	cp -r "Marksman/bin/Release/net${TERMUX_DOTNET_VERSION}/$DOTNET_TARGET_NAME/publish"/*.dll "${TERMUX_PREFIX}/lib/marksman"
	cp    "Marksman/bin/Release/net${TERMUX_DOTNET_VERSION}/$DOTNET_TARGET_NAME/publish/marksman.runtimeconfig.json" "${TERMUX_PREFIX}/lib/marksman/"
	cat > "$TERMUX_PREFIX/bin/marksman" <<-HERE
	#!$TERMUX_PREFIX/bin/sh
	exec dotnet $TERMUX_PREFIX/lib/marksman/marksman.dll "\$@"
	HERE
	chmod u+x "$TERMUX_PREFIX/bin/marksman"
}
