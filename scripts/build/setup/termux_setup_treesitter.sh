termux_setup_treesitter() {
	local TERMUX_TREE_SITTER_VERSION
	TERMUX_TREE_SITTER_VERSION="$(. "$TERMUX_SCRIPTDIR/packages/tree-sitter/build.sh"; echo "$TERMUX_PKG_VERSION")"
	TERMUX_TREE_SITTER_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${TERMUX_TREE_SITTER_VERSION}/tree-sitter-linux-x64.gz"
	local TERMUX_TREE_SITTER_SHA256=c300ea9f2ca368186ce1308793aaad650c3f6db78225257cbb5be961aeff4038

	local TERMUX_TREE_SITTER_GZNAME="tree-sitter-linux-x64.gz"
	local TERMUX_TREE_SITTER_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${TERMUX_TREE_SITTER_VERSION}/${TERMUX_TREE_SITTER_GZNAME}"
	TERMUX_TREE_SITTER_DIR="${TERMUX_SCRIPTDIR}/build-tools/tree-sitter-${TERMUX_TREE_SITTER_VERSION}"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		local TREE_SITTER_INSTALL_COMMAND=""
		case "$TERMUX_APP_PACKAGE_MANAGER" in
			"apt")
				if [[ "$(dpkg-query -W -f '${db:Status-Status}\n' tree-sitter 2>/dev/null)" != "installed" ]]; then
					TREE_SITTER_INSTALL_COMMAND="apt update && apt install tree-sitter"
				fi
			;;
			"pacman")
				if ! pacman -Q tree-sitter 2>/dev/null; then
					TREE_SITTER_INSTALL_COMMAND="pacman -Syu tree-sitter"
				fi
			;;
		esac
		if (( ${#TREE_SITTER_INSTALL_COMMAND} )); then
			echo "Package 'tree-sitter' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install tree-sitter"
			echo
			echo "  $TREE_SITTER_INSTALL_COMMAND"
			echo
			exit 1
		fi
		return
	fi

	if [[ ! "$( "${TERMUX_TREE_SITTER_DIR}/bin/tree-sitter" --version | cut -f2 -d' ')" == "$TERMUX_TREE_SITTER_VERSION" ]]; then
		echo "termux_step_setup_treesitter: installing tree-sitter $TERMUX_TREE_SITTER_VERSION"
		termux_download "${TERMUX_TREE_SITTER_URL}" \
			"${TERMUX_PKG_TMPDIR}/${TERMUX_TREE_SITTER_GZNAME}" \
			"${TERMUX_TREE_SITTER_SHA256}"

		gunzip "$TERMUX_PKG_TMPDIR/${TERMUX_TREE_SITTER_GZNAME}"
		mv -v "$TERMUX_PKG_TMPDIR"/{tree-sitter-linux-x64,tree-sitter}
		install -Dm700 "$TERMUX_PKG_TMPDIR/tree-sitter" "$TERMUX_TREE_SITTER_DIR/bin/tree-sitter"
	else
		echo "termux_step_setup_treesitter: tree-sitter $TERMUX_TREE_SITTER_VERSION is already installed"
		echo "$TERMUX_TREE_SITTER_DIR/bin/tree-sitter"
	fi
	export PATH="${TERMUX_TREE_SITTER_DIR}/bin:${PATH}"

}
