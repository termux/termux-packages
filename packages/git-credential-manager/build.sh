TERMUX_PKG_HOMEPAGE="https://aka.ms/gcm"
TERMUX_PKG_DESCRIPTION="Cross-platform Git credential storage for multiple hosting providers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.1"
TERMUX_PKG_SRCURL="https://github.com/git-ecosystem/git-credential-manager/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fb51d6c47996c624e95b4ee08fddac8bc7da2b45233b085ce1bd534719017ece
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_DOTNET_VERSION=10.0
TERMUX_PKG_DEPENDS="dotnet-host, dotnet-runtime-10.0"
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_dotnet
}

termux_step_make() {
	dotnet publish src/git-credential-manager/git-credential-manager.csproj \
	--framework "net${TERMUX_DOTNET_VERSION}" \
	--no-self-contained \
	--runtime "$DOTNET_TARGET_NAME" \
	--configuration Release \
	-p:PublishTrimmed=false \
	-p:AssemblyVersion="${TERMUX_PKG_VERSION}" \
	-p:FileVersion="${TERMUX_PKG_VERSION}" \
	-p:InformationalVersion="${TERMUX_PKG_VERSION}" \
	-p:Version="${TERMUX_PKG_VERSION}"
	dotnet build-server shutdown
	termux_dotnet_kill
}

# The concern about preventing `rm -rf "${TERMUX_PREFIX}/lib"` from expanding to
# `rm -rf "/lib/"` is valid, but the suggested remedy of `${var:?}` is not how we
# prefer to handle null value errors.
# shellcheck disable=SC2115
termux_step_make_install() {
	# Sanity check the variables used in the `rm`'s below, just in case.
	[[ -n "$TERMUX_PREFIX" ]] || termux_error_exit "TERMUX_PREFIX is unset, this shouldn't even be possible."
	[[ -n "$TERMUX_PKG_NAME" ]] || termux_error_exit "TERMUX_PKG_NAME is unset, this shouldn't even be possible."

	rm -rf "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"
	mkdir -p "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"
	cp -r "out/publish/git-credential-manager/release_${DOTNET_TARGET_NAME}"/* "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"
	ln -sf "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}/git-credential-manager" "$TERMUX_PREFIX/bin"

	# Remove translations
	rm -rf "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"/*/
	# Remove debug files
	rm "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"/*.pdb
	# Remove duplicate license
	rm "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}/NOTICE"
}
