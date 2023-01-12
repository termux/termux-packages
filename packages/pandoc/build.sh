TERMUX_PKG_HOMEPAGE=https://pandoc.org/
TERMUX_PKG_DESCRIPTION="Universal markup converter"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.19.2
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_make_install() {
	local srcurl
	local sha256

	case "$TERMUX_ARCH" in
		aarch64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-arm64.tar.gz"
			sha256="43f364915b9da64905fc3f6009f5542f224e54fb24f71043ef5154540f1a3983"
			;;
		x86_64)
			srcurl="https://github.com/jgm/pandoc/releases/download/${TERMUX_PKG_VERSION}/pandoc-${TERMUX_PKG_VERSION}-linux-amd64.tar.gz"
			sha256="9d55c7afb6a244e8a615451ed9cb02e6a6f187ad4d169c6d5a123fa74adb4830"
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
