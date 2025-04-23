TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/apt-file
TERMUX_PKG_DESCRIPTION="search for files within packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://salsa.debian.org/apt-team/apt-file/-/archive/debian/${TERMUX_PKG_VERSION}/apt-file-debian-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a8aefe029e0ac76a0f8dd312fa1254ec4435d88184c8d51c0029432962d0939f
TERMUX_PKG_DEPENDS="apt, libapt-pkg-perl, libregexp-assemble-perl, perl"
TERMUX_PKG_REPLACES="whatprovides"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
	DESTDIR=$TERMUX_PREFIX
	BINDIR=$TERMUX_PREFIX/bin
	MANDIR=$TERMUX_PREFIX/share/man/man1
"

termux_step_post_make_install() {
	install -Dm644 "$TERMUX_PKG_SRCDIR/debian/bash-completion" \
		"$TERMUX_PREFIX/etc/bash_completion.d/apt-file"
}
