TERMUX_PKG_HOMEPAGE="https://officecli.ai"
TERMUX_PKG_DESCRIPTION="CLI for reading and writing Office documents (.docx, .xlsx, .pptx) via a document DOM API"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.157"
TERMUX_PKG_SRCURL="https://github.com/iOfficeAI/OfficeCLI/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=cfd858ca32cc3ecb51b16b882ab2614517921c4b141674b82b0883eeb07a3754
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_DOTNET_VERSION=10.0
TERMUX_PKG_DEPENDS="dotnet-host, dotnet-runtime-10.0"
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_dotnet
}

termux_step_make() {
	dotnet publish src/officecli/officecli.csproj \
		--framework "net${TERMUX_DOTNET_VERSION}" \
		--runtime "$DOTNET_TARGET_NAME" \
		--output "$TERMUX_PKG_BUILDDIR/build" \
		--no-self-contained \
		--configuration Release \
		-p:PublishTrimmed=false \
		-p:PublishSingleFile=false \
		-p:RunAnalyzers=false \
		-p:AssemblyVersion="${TERMUX_PKG_VERSION}" \
		-p:FileVersion="${TERMUX_PKG_VERSION}" \
		-p:InformationalVersion="${TERMUX_PKG_VERSION}" \
		-p:Version="${TERMUX_PKG_VERSION}"

	dotnet build-server shutdown
	termux_dotnet_kill
}

termux_step_make_install() {
	[[ -n "$TERMUX_PREFIX" ]] || termux_error_exit "TERMUX_PREFIX is unset, this shouldn't even be possible."
	[[ -n "$TERMUX_PKG_NAME" ]] || termux_error_exit "TERMUX_PKG_NAME is unset, this shouldn't even be possible."

	rm -rf "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"
	mkdir -p "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"
	cp -r "${TERMUX_PKG_BUILDDIR}/build"/* "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}/"

	mkdir -p "${TERMUX_PREFIX}/bin"
	ln -sf "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}/officecli" "${TERMUX_PREFIX}/bin/officecli"

	# Remove debug files
	rm -f "${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"/*.pdb
}
