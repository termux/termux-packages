TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/apt-file
TERMUX_PKG_DESCRIPTION="search for files within packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/a/apt-file/apt-file_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=376a4b63604c1d89b71deebc05fdd231b76655bd867abe1111c0f8d36fe9ed0a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="apt, libapt-pkg-perl, libregexp-assemble-perl, perl"
TERMUX_PKG_REPLACES="whatprovides"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="DESTDIR=$TERMUX_PREFIX BINDIR=$TERMUX_PREFIX/bin \
				MANDIR=$TERMUX_PREFIX/share/man/man1"


termux_pkg_auto_update() {
	local latest_version
	latest_version="$(
		curl -fsSL --retry 5 "https://sources.debian.org/api/src/apt-file/" |
			jq -r '.versions[] | select(.suites | index("sid")) | .version'
	)"
	if [[ -z "$latest_version" ]]; then
		echo "WARN: Unable to get the latest version." >&2
		return
	fi
	termux_pkg_upgrade_version "$latest_version"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/bash_completion.d/
	cp $TERMUX_PKG_SRCDIR/debian/bash-completion \
		$TERMUX_PREFIX/etc/bash_completion.d/apt-file
}
