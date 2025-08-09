TERMUX_PKG_HOMEPAGE=https://nvim-neorocks.github.io/
TERMUX_PKG_DESCRIPTION="A package manager for Lua, similar to luarocks"
TERMUX_PKG_LICENSE="LGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.2"
TERMUX_PKG_SRCURL="https://github.com/nvim-neorocks/lux/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=11c71dc9d2c53c8b5f96b1ae8a829efe3a79bdee1b4541781397070a9deb6fdf
TERMUX_PKG_DEPENDS="bzip2, gpgme, libgit2, libgpg-error, luajit, openssl, xz-utils"
TERMUX_PKG_PROVIDES="lx"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_pkg_auto_update() {
	# based on `termux_github_api_get_tag.sh`
	# fetch newest tags
	local newest_tags newest_tag
	newest_tags="$(curl -d "$(cat <<-EOF | tr '\n' ' '
	{
		"query": "query {
			repository(owner: \"nvim-neorocks\", name: \"lux\") {
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
	# filter only tags having "v" at the start and extract only raw version.
	read -r newest_tag < <(echo "$newest_tags" | grep -Po '(?<=^"v)\d+\.\d+\.\d+' | sort -Vr)

	[[ -z "${newest_tag}" ]] && termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${newest_tag}"
}

# Function to obtain the .deb URL
obtain_deb_url() {
	local url attempt retries wait PAGE deb_url
	url="https://packages.ubuntu.com/noble/amd64/$1/download"
	retries=50
	wait=50

	for ((attempt=1; attempt<=retries; attempt++)); do
		PAGE="$(curl -s "$url")"
		>&2 echo page
		>&2 echo "$PAGE"
		deb_url="$(grep -oE 'https?://.*\.deb' <<< "$PAGE" | head -n1)"
		if [[ -n "$deb_url" ]]; then
				echo "$deb_url"
				return 0
		else
			>&2 echo "Attempt $attempt: Failed to obtain URL. Retrying in $wait seconds..."
		fi
		sleep "$wait"
	done

	termux_error_exit "Failed to obtain URL after $retries attempts."
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi
	# install Ubuntu packages, like in the aosp-libs build.sh, to get gpgme for rust-hostbuilding
	mkdir -p "${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"

	local URL DEB_NAME DEB_LIST

	DEB_LIST=""
	# libgpgme-dev and any dependencies that aren't in the ubuntu builder at time of writing
	DEB_LIST+=" dirmngr"
	DEB_LIST+=" gnupg"
	DEB_LIST+=" gnupg-l10n"
	DEB_LIST+=" gnupg-utils"
	DEB_LIST+=" gpg"
	DEB_LIST+=" gpg-agent"
	DEB_LIST+=" gpg-wks-client"
	DEB_LIST+=" gpgconf"
	DEB_LIST+=" gpgsm"
	DEB_LIST+=" gpgv"
	DEB_LIST+=" keyboxd"
	DEB_LIST+=" libassuan-dev"
	DEB_LIST+=" libgpgme-dev"
	DEB_LIST+=" libgpgme11t64"

	for i in $DEB_LIST; do
		echo "deb: $i"
		URL="$(obtain_deb_url "$i")"
		DEB_NAME="${URL##*/}"
		echo "$URL"
		termux_download "$URL" "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" SKIP_CHECKSUM

		mkdir -p "${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		ar x "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" --output="${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		tar xf "${TERMUX_PKG_TMPDIR}/${DEB_NAME}/data.tar.zst" \
			-C "${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	done

	PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr/lib/x86_64-linux-gnu/pkgconfig"
	RUSTFLAGS="-L${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr/lib/x86_64-linux-gnu"

	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu RUSTFLAGS

	cd "${TERMUX_PKG_SRCDIR}" || termux_error_exit "Couldn't enter source code directory: ${TERMUX_PKG_SRCDIR}"

	termux_setup_rust

	cargo fetch --locked

	# build shell completions
	cargo run --package xtask --release --frozen -- dist-completions

	unset PKG_CONFIG_PATH_x86_64_unknown_linux_gnu RUSTFLAGS

	# preserve the hostbuilt shell completions
	rm -rf "${TERMUX_PKG_HOSTBUILD_DIR}/dist/"
	cp -r "${TERMUX_PKG_SRCDIR}/target/dist/" "${TERMUX_PKG_HOSTBUILD_DIR}/"
}

termux_step_pre_configure() {
	# software does not officially support cross-compilation, but for some reason, it appears to work anyway
	# https://github.com/nvim-neorocks/lux/blob/c794f476cb459df5bcb6e971c0c6f76e6a2a4dd4/lux-lib/src/lua_rockspec/platform.rs#L72
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		echo "WARNING: $TERMUX_PKG_NAME's upstream project does not officially support cross-compilation!"
	fi

	termux_setup_rust

	cargo fetch --locked --target "$CARGO_TARGET_NAME"

	# software does not officially support android, so treat android as linux
	find "$TERMUX_PKG_SRCDIR" -type f | \
		xargs -n 1 sed -i \
		-e 's|target_os = "linux"|target_os = "android"|g'
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release --frozen

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		# build shell completions
		cargo run --package xtask --release --frozen -- dist-completions

		rm -rf "${TERMUX_PKG_HOSTBUILD_DIR}/dist/"
		cp -r "${TERMUX_PKG_SRCDIR}/target/dist/" "${TERMUX_PKG_HOSTBUILD_DIR}/"
	fi
}

termux_step_make_install() {
	local _cargo_target_dir _completions_dir
	_cargo_target_dir="$TERMUX_PKG_BUILDDIR/target"
	_completions_dir="$TERMUX_PKG_HOSTBUILD_DIR/dist"

	install -Dm755 -t "$TERMUX_PREFIX/bin" "$_cargo_target_dir/$CARGO_TARGET_NAME/release/lx"

	install -Dm644 "$_completions_dir/lx.bash" "$TERMUX_PREFIX/share/bash-completion/completions/lx"
	install -Dm644 -t "$TERMUX_PREFIX/share/zsh/site-functions" "$_completions_dir/_lx"
	install -Dm644 -t "$TERMUX_PREFIX/share/fish/vendor_completions.d" "$_completions_dir/lx.fish"
}
