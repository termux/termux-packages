TERMUX_PKG_HOMEPAGE=https://pandoc.org/
TERMUX_PKG_DESCRIPTION="Universal markup converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.13
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_make_install() {
	local srcurl
	local sha256

	case "$TERMUX_ARCH" in
		aarch64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-arm64.tar.gz"
			sha256="678c09ac4227c88b491f6e75491e6da871fd08d79b8c0f0ee37b611f01ad3d25"
			;;
		x86_64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-amd64.tar.gz"
			sha256="db556c98cf207d2fddc088d12d2e2f367d9401784d4a3e914b068fa895dcf3f0"
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
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/pandoc
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		pandoc --bash-completion > ${TERMUX_PREFIX}/share/bash-completion/completions/pandoc
	EOF
}
