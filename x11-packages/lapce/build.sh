TERMUX_PKG_HOMEPAGE=https://lapce.dev
TERMUX_PKG_DESCRIPTION="Lightning-fast and Powerful Code Editor"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.5
TERMUX_PKG_SRCURL=https://github.com/lapce/lapce/archive/v${TERMUX_PKG_VERSION}/lapce-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3b8357653eda77b2c85306ba9f7202e539987ada4a7b5be2018b142bb23be7e4
TERMUX_PKG_DEPENDS="freetype, fontconfig, libexpat, gtk3, libxcb"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
  termux_setup_cmake

	cargo build --release \
		--jobs "$TERMUX_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--all-features
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SCRDIR/target/"${CARGO_TARGET_NAME}"/release/lapce $TERMUX_PREFIX/bin/lapce
	install -Dm700 $TERMUX_PKG_SRCDIR/extra/linux/dev.lapce.lapce.desktop "$TERMUX_PREFIX"/share/applications/dev.lapce.lapce.desktop
	install -Dm700 $TERMUX_PKG_SRCDIR/extra/linux/dev.lapce.lapce.metainfo.xml $TERMUX_PREFIX/share/metainfo/dev.lapce.lapce.metainfo.xml
	install -DM700 $TERMUX_PKG_SCRDIR/extra/images/logo.png $TERMUX_PREFIX/share/pixmaps/dev.lapce.lapce.png
}
