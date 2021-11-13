TERMUX_PKG_HOMEPAGE=https://pandoc.org/
TERMUX_PKG_DESCRIPTION="Universal markup converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.16.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	local srcurl
	local sha256

	case "$TERMUX_ARCH" in
		aarch64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-arm64.tar.gz"
			sha256="c1130d917fb6e8c9a29cadc52ef9e4c4405450868d5f7dd3018f413755ac2b31"
			;;
		x86_64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-amd64.tar.gz"
			sha256="3fe3d42179af289d4f5452b9317d2bc9cd139a4f33a37f68d70e128f1d415aa4"
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
