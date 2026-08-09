TERMUX_PKG_HOMEPAGE=https://lux.lumen-labs.org
TERMUX_PKG_DESCRIPTION="A package manager for Lua, similar to luarocks"
TERMUX_PKG_LICENSE="LGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.40.4"
TERMUX_PKG_SRCURL="https://github.com/lumen-oss/lux/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d439792fe799918d97ad172a6d1a8ec8e73d789ac3db9ebac5ac167626a6b446
TERMUX_PKG_DEPENDS="bzip2, gpgme, libgit2, libgpg-error, lua54, openssl, xz-utils"
TERMUX_PKG_PROVIDES="lx"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_pkg_auto_update() {
	# based on `termux_github_api_get_tag.sh`
	# fetch newest tags
	local newest_tags newest_tag
	newest_tags="$(curl -d "$(cat <<-EOF | tr '\n' ' '
	{
		"query": "query {
			repository(owner: \"lumen-oss\", name: \"lux\") {
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

	[[ -z "${newest_tag}" ]] && termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${newest_tag}"
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	cd "${TERMUX_PKG_SRCDIR}" || termux_error_exit "Couldn't enter source code directory: ${TERMUX_PKG_SRCDIR}"

	termux_setup_rust

	termux_download_ubuntu_packages libgpgme-dev libassuan-dev

	local HOSTBUILD_ROOTFS="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages"
	local HOSTBUILD_ARCH_LIBDIR="/usr/lib/x86_64-linux-gnu"

	find "${HOSTBUILD_ROOTFS}" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${HOSTBUILD_ROOTFS}/usr|g"
	# delete all static libraries to prevent errors:
	# rust-lld: error: undefined symbol: assuan_set_flag
	# referenced by engine-assuan.o:(llass_new) in archive
	# /home/builder/.termux-build/lux-cli/host-build/ubuntu_packages
	# /usr/lib/x86_64-linux-gnu/libgpgme.a
	find "${HOSTBUILD_ROOTFS}" -type f -name '*.a' -delete
	find "${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_LIBDIR}" -xtype l \
		-exec sh -c "ln -snvf ${HOSTBUILD_ARCH_LIBDIR}/\$(readlink \$1) \$1" sh {} \;

	PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_LIBDIR}/pkgconfig"
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu

	cargo fetch --locked

	# build shell completions
	cargo run --package xtask --release --frozen -- dist-completions

	# preserve the hostbuilt shell completions
	rm -rf "${TERMUX_PKG_HOSTBUILD_DIR}/dist/"
	cp -r "${TERMUX_PKG_SRCDIR}/target/dist/" "${TERMUX_PKG_HOSTBUILD_DIR}/"
}

termux_step_pre_configure() {
	# software does not officially support cross-compilation, but for some reason, it appears to work anyway
	# https://github.com/lumen-oss/lux/blob/c794f476cb459df5bcb6e971c0c6f76e6a2a4dd4/lux-lib/src/lua_rockspec/platform.rs#L72
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		echo "WARNING: $TERMUX_PKG_NAME's upstream project does not officially support cross-compilation!"
	fi

	termux_setup_rust

	# ld: error: undefined symbol: __atomic_compare_exchange
	# ld: error: undefined symbol: __atomic_load
	# ld: error: undefined symbol: __atomic_is_lock_free
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi

	cargo fetch --locked --target "$CARGO_TARGET_NAME"
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
