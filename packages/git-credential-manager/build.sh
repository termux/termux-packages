TERMUX_PKG_HOMEPAGE="https://aka.ms/gcm"
TERMUX_PKG_DESCRIPTION="Cross-platform Git credential storage for multiple hosting providers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/git-ecosystem/git-credential-manager/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=aba0b06b59daa1cd8a16bd9e1ca31a6d9da73e524fe8c045f3acbd0000be1b5e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_DOTNET_VERSION=8.0
TERMUX_PKG_DEPENDS="dotnet-host, dotnet-runtime-8.0"
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_dotnet
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
	mkdir -p "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"
	cp -r "out/shared/Git-Credential-Manager/bin/Release/net${TERMUX_DOTNET_VERSION}/${DOTNET_TARGET_NAME}/publish"/* "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"
	ln -sf "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}/git-credential-manager" "$TERMUX_PREFIX/bin"

	# Remove translations
	rm -rf "${TERMUX_PREFIX:?}/lib/${TERMUX_PKG_NAME:?}"/*/
	# Remove debug files
	rm "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"/*.pdb
	# Remove duplicate license
	rm "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}/NOTICE"
}
