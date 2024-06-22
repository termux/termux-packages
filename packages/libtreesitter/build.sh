TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter
TERMUX_PKG_DESCRIPTION="An incremental parsing system for programming tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=("0.22.6" # tree-sitter
                    "0.1.0"  # lua
                    "0.2.3"  # markdown
                    "0.4.0"  # vim
                    "3.0.0") # vimdoc
TERMUX_PKG_SRCURL=("https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
                   "https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz"
                   "https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v${TERMUX_PKG_VERSION[2]}.tar.gz"
                   "https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v${TERMUX_PKG_VERSION[3]}.tar.gz"
                   "https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v${TERMUX_PKG_VERSION[4]}.tar.gz")
TERMUX_PKG_SHA256=(e2b687f74358ab6404730b7fb1a1ced7ddb3780202d37595ecd7b20a8f41861f
                   230cfcbfa74ed1f7b8149e9a1f34c2efc4c589a71fe0f5dc8560622f8020d722
                   4909d6023643f1afc3ab219585d4035b7403f3a17849782ab803c5f73c8a31d5
                   9f856f8b4a10ab43348550fa2d3cb2846ae3d8e60f45887200549c051c66f9d5
                   a639bf92bf57bfa1cdc90ca16af27bfaf26a9779064776dd4be34c1ef1453f6c)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	local idx project version checksum project_repo latest_tag
	# for each entry in the SRCURLs, check the version
	for (( idx = 0; idx < ${#TERMUX_PKG_SRCURL[*]}; idx++ )); do
		project="${TERMUX_PKG_SRCURL[$idx]}"
		version="${TERMUX_PKG_VERSION[$idx]}"
		checksum="${TERMUX_PKG_SHA256[$idx]}"

		# get the repo URL
		project_repo="$(grep -oE 'https://github.com/[^/]*/[^/]*' <<< "$project")"
		# fetch the latest tag and extract the version
		latest_tag="$(git ls-remote --tags "$project_repo" | awk 'END {print $2}' | LC_COLLATE=C grep -oE '[0-9.]+')"

		# the sed expression in termux_pkg_upgrade_version() actually handles arrays just fine.
		# as does the one in update-checksum
		echo "$project_repo" # I like knowing what we are updating
		termux_pkg_upgrade_version "$latest_tag"
	done
}

termux_step_pre_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local TS_SOVERSION=0

	# New SO version is the major version of the package
	if [[ "${TERMUX_PKG_VERSION[0]}" != "$TS_SOVERSION".* ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release

	local idx=0 project url
	for parser in tree-sitter-{lua,markdown,vim,vimdoc}; do
		(( idx++ ))
		( # borrowed from Arch
		# https://gitlab.archlinux.org/archlinux/packaging/packages/tree-sitter-lua/-/blob/main/PKGBUILD
			cd "$TERMUX_PKG_SRCDIR/${parser}-${TERMUX_PKG_VERSION[$idx]}"
			project="${TERMUX_PKG_SRCURL[$idx]}" # yes this is duplicated code, no I don't think we should make it DRY.
			url="$(grep -oE 'https://github.com/[^/]*/[^/]*' <<< "$project")"

			tree-sitter generate --no-bindings src/grammar.json
			make PREFIX="$TERMUX_PREFIX" PARSER_URL="$url"1
		)
	done
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" target/${CARGO_TARGET_NAME}/release/tree-sitter
	install -Dm644 -t "$TERMUX_PREFIX/usr/lib/${parser}.so" "${parser}.so"
}
