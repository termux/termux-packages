TERMUX_PKG_HOMEPAGE=https://pandoc.org/
TERMUX_PKG_DESCRIPTION="Universal markup converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.18
TERMUX_PKG_REVISION=0
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	local srcurl
	local sha256

	case "$TERMUX_ARCH" in
		aarch64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-arm64.tar.gz"
			sha256="a48160539c27c6a35413667b064f9af154d59ad592563dcaab8a07d427bda594"
			;;
		x86_64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-amd64.tar.gz"
			sha256="103df36dc21081b7205d763ef7705e340eb0ea7e18694239b328a549892cc007"
			;;
		*)
			termux_error_exit "Unsupported arch: $TERMUX_ARCH"
			;;
	esac

	termux_download "$srcurl" "pandoc-${TERMUX_PKG_VERSION}.tar.gz" "$sha256"
	tar xf "pandoc-${TERMUX_PKG_VERSION}.tar.gz"
	cd "pandoc-${TERMUX_PKG_VERSION}"

	install -Dm700 "./bin/pandoc" "$TERMUX_PREFIX/bin/pandoc"
	install -Dm600 "./share/man/man1/pandoc.1.gz" "$TERMUX_PREFIX/share/man/man1/pandoc.1.gz"
}
