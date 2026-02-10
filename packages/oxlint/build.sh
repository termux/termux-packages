TERMUX_PKG_HOMEPAGE=https://oxc.rs/
TERMUX_PKG_DESCRIPTION="Oxc JavaScript linter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.46.0"
TERMUX_PKG_SRCURL="https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=61b2376852b231c42da6f42ca61dc0436eb3040da57f011fc7a6be564934fa84
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_pkg_auto_update() {
	# based on `termux_github_api_get_tag.sh`
	# fetch newest tags
	local newest_tags newest_tag
	newest_tags="$(curl -d "$(cat <<-EOF | tr '\n' ' '
	{
		"query": "query {
			repository(owner: \"oxc-project\", name: \"oxc\") {
				refs(refPrefix: \"refs/tags/\", first: 20, orderBy: {
					field: TAG_COMMIT_DATE, direction: DESC
				})
				{ edges { node { name } } }
			}
		}"
	}
	EOF
	)" \
		-H "Authorization: token ${GITHUB_TOKEN}" \
		-H "Accept: application/vnd.github.v3+json" \
		--silent \
		--location \
		--retry 10 \
		--retry-delay 1 \
		https://api.github.com/graphql \
		| jq '.data.repository.refs.edges[].node.name')"
	# filter only tags having "oxlint_v" and extract only raw version.
	read -r newest_tag < <(echo "$newest_tags" | grep -Po 'oxlint_v\K\d+\.\d+\.\d+' | sort -Vr)

	[[ -z "${newest_tag}" ]] && termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${newest_tag}"
}

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_nodejs
	termux_setup_cmake
	# Dummy CMake toolchain file to workaround build error:
	# error: failed to run custom build command for `libz-ng-sys v1.1.15`
	# ...
	# CMake Error at /home/builder/.termux-build/_cache/cmake-3.28.3/share/cmake-3.28/Modules/Platform/Android-Determine.cmake:217 (message):
	# Android: Neither the NDK or a standalone toolchain was found.
	export TARGET_CMAKE_TOOLCHAIN_FILE="$TERMUX_PKG_BUILDDIR/android.toolchain.cmake"
	touch "$TARGET_CMAKE_TOOLCHAIN_FILE"

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME
	cargo fetch --target "$CARGO_TARGET_NAME"

	# ld.lld: error: undefined symbol: __atomic_load_8
	if [[ "$TERMUX_ARCH" == "i686" ]]; then
		local -u env_host="${CARGO_TARGET_NAME//-/_}"
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release --all-features
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/$CARGO_TARGET_NAME/release/oxlint"
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/$CARGO_TARGET_NAME/release/oxfmt"
}
