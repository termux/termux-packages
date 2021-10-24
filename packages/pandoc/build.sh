TERMUX_PKG_HOMEPAGE=https://pandoc.org/
TERMUX_PKG_DESCRIPTION="Universal markup converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.13
TERMUX_PKG_REVISION=2
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	local srcurl
	local sha256

	case "$TERMUX_ARCH" in
		aarch64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-arm64.tar.gz"
			sha256="4f87bfe8a0a626ad0e17d26d42e99a1c0ed7d369cca00366c1b3d97525f57db5"
			;;
		x86_64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-amd64.tar.gz"
			sha256="7404aa88a6eb9fbb99d9803b80170a3a546f51959230cc529c66a2ce6b950d4c"
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
