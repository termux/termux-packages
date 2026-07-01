TERMUX_PKG_HOMEPAGE=https://github.com/prefix-dev/pixi
TERMUX_PKG_DESCRIPTION="A cross-platform, multi-language package manager and workflow tool"
TERMUX_PKG_LICENSE="BSD-3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.63.2"
TERMUX_PKG_SKIP_SRC_ARCHIVE=true
TERMUX_PKG_AUTO_UPDATE=true

# Provide a dummy SRCURL for auto-update functionality
TERMUX_PKG_SRCURL=https://github.com/prefix-dev/pixi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz

termux_pkg_auto_update() {
	# Fetch latest release information from GitHub API
	local api_url="https://api.github.com/repos/prefix-dev/pixi/releases/latest"
	local latest_version=$(curl -s "${api_url}" | jq -r .tag_name | sed 's/^v//')

	if [[ -z "${latest_version}" ]] || [[ "${latest_version}" == "null" ]]; then
		echo "WARN: Unable to fetch latest version from GitHub API"
		return
	fi

	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: Already at latest version ${TERMUX_PKG_VERSION}"
		return
	fi

	echo "INFO: Updating pixi from ${TERMUX_PKG_VERSION} to ${latest_version}"
	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	# Download pre-built static binaries based on architecture
	case "$TERMUX_ARCH" in
		aarch64)
			PIXI_BINARY_URL="https://github.com/prefix-dev/pixi/releases/download/v${TERMUX_PKG_VERSION}/pixi-aarch64-unknown-linux-musl.tar.gz"
			PIXI_BINARY_SHA256="dbde6dbc2806602171e17305ce005e1aed519f2f2461a7cafd0093e92b7e7681"
			;;
		x86_64)
			PIXI_BINARY_URL="https://github.com/prefix-dev/pixi/releases/download/v${TERMUX_PKG_VERSION}/pixi-x86_64-unknown-linux-musl.tar.gz"
			PIXI_BINARY_SHA256="b2a9e26bb6c80fe00618a02e7198dec222e1fbcec61e04c11b6e6538089ab100"
			;;
		*)
			termux_error_exit "Unsupported architecture: $TERMUX_ARCH"
			;;
	esac

	# Download the binary
	termux_download "$PIXI_BINARY_URL" \
		"$TERMUX_PKG_CACHEDIR/pixi-${TERMUX_ARCH}.tar.gz" \
		"$PIXI_BINARY_SHA256"

	# Extract the binary
	cd "$TERMUX_PKG_CACHEDIR"
	tar -xzf "pixi-${TERMUX_ARCH}.tar.gz"

	# Make sure the binary is executable
	chmod +x pixi

	# Download license file
	termux_download \
		"https://raw.githubusercontent.com/prefix-dev/pixi/v${TERMUX_PKG_VERSION}/LICENSE" \
		"$TERMUX_PKG_CACHEDIR/LICENSE" \
		SKIP_CHECK
}

termux_step_make() {
	# Nothing to build, using pre-compiled binary
	:
}

termux_step_make_install() {
	# Install the pixi binary
	install -Dm755 "$TERMUX_PKG_CACHEDIR/pixi" "$TERMUX_PREFIX/bin/pixi"

	# Install license
	install -Dm644 "$TERMUX_PKG_CACHEDIR/LICENSE" "$TERMUX_PREFIX/share/licenses/$TERMUX_PKG_NAME/LICENSE"

	# Install shell completions if available in the extracted archive
	if [ -f "$TERMUX_PKG_CACHEDIR/completion.bash" ]; then
		install -Dm644 "$TERMUX_PKG_CACHEDIR/completion.bash" "$TERMUX_PREFIX/share/bash-completion/completions/pixi"
	fi

	if [ -f "$TERMUX_PKG_CACHEDIR/completion.zsh" ]; then
		install -Dm644 "$TERMUX_PKG_CACHEDIR/completion.zsh" "$TERMUX_PREFIX/share/zsh/site-functions/_pixi"
	fi

	if [ -f "$TERMUX_PKG_CACHEDIR/completion.fish" ]; then
		install -Dm644 "$TERMUX_PKG_CACHEDIR/completion.fish" "$TERMUX_PREFIX/share/fish/vendor_completions.d/pixi.fish"
	fi
}