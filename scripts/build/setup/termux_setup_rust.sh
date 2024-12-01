# shellcheck shell=bash disable=SC1091 disable=SC2086 disable=SC2155
termux_setup_rust() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		if [[ -z "$(command -v rustc)" ]]; then
			cat <<- EOL
			Package 'rust' is not installed.
			You can install it with

			pkg install rust

			pacman -S rust
			EOL
			exit 1
		fi
		local RUSTC_VERSION=$(rustc --version | awk '{ print $2 }')
		if [[ -n "${TERMUX_RUST_VERSION-}" && "${TERMUX_RUST_VERSION-}" != "${RUSTC_VERSION}" ]]; then
			cat <<- EOL >&2
			WARN: On device build with old rust version is not possible!
			TERMUX_RUST_VERSION = ${TERMUX_RUST_VERSION}
			RUSTC_VERSION       = ${RUSTC_VERSION}
			EOL
		fi
		return
	fi

	if [[ -z "${TERMUX_RUST_VERSION-}" ]]; then
		TERMUX_RUST_VERSION=$(. "${TERMUX_SCRIPTDIR}"/packages/rust/build.sh; echo ${TERMUX_PKG_VERSION})
	fi
	if [[ "${TERMUX_RUST_VERSION}" == *"~beta"* ]]; then
		TERMUX_RUST_VERSION="beta"
	fi

	curl https://sh.rustup.rs -sSfo "${TERMUX_PKG_TMPDIR}"/rustup.sh
	sh "${TERMUX_PKG_TMPDIR}"/rustup.sh -y --default-toolchain "${TERMUX_RUST_VERSION}"

	export PATH="${HOME}/.cargo/bin:${PATH}"

	if [[ -n "${CARGO_TARGET_NAME-}" ]]; then
		rustup target add "${CARGO_TARGET_NAME}"
	fi
}
