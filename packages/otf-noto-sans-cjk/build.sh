TERMUX_PKG_HOMEPAGE=https://github.com/notofonts/noto-cjk
TERMUX_PKG_DESCRIPTION="Noto Sans CJK fonts for Chinese, Japanese and Korean"
TERMUX_PKG_LICENSE="OFL-1.1"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.004"
TERMUX_PKG_SRCURL=(
	https://raw.githubusercontent.com/notofonts/noto-cjk/Sans${TERMUX_PKG_VERSION}/Sans/OTC/NotoSansCJK-Regular.ttc
	https://raw.githubusercontent.com/notofonts/noto-cjk/Sans${TERMUX_PKG_VERSION}/Sans/OTC/NotoSansCJK-Bold.ttc
	https://raw.githubusercontent.com/notofonts/noto-cjk/Sans${TERMUX_PKG_VERSION}/LICENSE
)
TERMUX_PKG_SHA256=(
	b76b0433203017ca80401b2ee0dd69350349871c4b19d504c34dbdd80541690a
	faa5f3656a78b2e2d450d27fe8382c778bc2b6bb5ea29c986664a6a435056ceb
	6a73f9541c2de74158c0e7cf6b0a58ef774f5a780bf191f2d7ec9cc53efe2bf2
)
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_extract_src_archive() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	cp "$TERMUX_PKG_CACHEDIR/LICENSE" "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	install -Dm644 -t "$TERMUX_PREFIX/share/fonts/OTC" "$TERMUX_PKG_CACHEDIR"/NotoSansCJK-{Regular,Bold}.ttc
}
