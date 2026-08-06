TERMUX_PKG_HOMEPAGE=https://github.com/phiresky/ripgrep-all
TERMUX_PKG_DESCRIPTION="Search tool able to locate in PDFs, E-Books, zip, tar.gz, etc"
TERMUX_PKG_LICENSE="AGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.10.10"
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="fzf, ripgrep, xz-utils"
TERMUX_PKG_RECOMMENDS="ffmpeg, graphicsmagick, pandoc, poppler, tesseract"
TERMUX_PKG_SRCURL="https://github.com/phiresky/ripgrep-all/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=17fadc7b73a51608d57f82b4a11f3edc0da87716cc4b302103eed9d4b9010fe5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export CARGO_TARGET_"${env_host}"_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--all-features
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/rga"
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/rga-preproc"
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/rga-fzf"
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/rga-fzf-open"
}
