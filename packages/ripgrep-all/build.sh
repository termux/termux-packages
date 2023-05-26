TERMUX_PKG_HOMEPAGE=https://github.com/phiresky/ripgrep-all
TERMUX_PKG_DESCRIPTION="Search tool able to locate in PDFs, E-Books, zip, tar.gz, etc"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION="1.0.0-alpha.4"
TERMUX_PKG_DEPENDS="ripgrep, fzf"
TERMUX_PKG_RECOMMENDS="ffmpeg, poppler, sqlite"
TERMUX_PKG_SRCURL=https://github.com/phiresky/ripgrep-all/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a8c6a680e03a29ebc1c4ce1fea1150c251adfded54d21a2898f2954277f635a3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	termux_setup_rust

	RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rga
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rga-preproc
	install -m755 $TERMUX_PKG_BUILDER_DIR/rga-fzf  $TERMUX_PREFIX/bin/rga-fzf
}
