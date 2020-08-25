TERMUX_PKG_HOMEPAGE=https://github.com/WindSoilder/hors
TERMUX_PKG_DESCRIPTION="Instant coding answers via the command line (howdoi in rust)"
TERMUX_PKG_LICENSE="GPLv3"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_VERSION=0.6.9
TERMUX_PKG_SRCURL=https://github.com/WindSoilder/hors/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a4737bc04b77d035b7b57d99cad875e709044ef829febdf9da87a6dde67d8c79
termux_step_make() {
	termux_setup_rust

	cd "$TERMUX_PKG_SRCDIR"
        Cargo install hors
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin "$HOME"/.cargo/bin/hors
	install -Dm600 -t "$TERMUX_PREFIX"/share/doc/hors/ "$TERMUX_PKG_SRCDIR"/README*
}
