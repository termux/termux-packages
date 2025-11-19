TERMUX_PKG_HOMEPAGE=https://wiki.debian.org/apt-file
TERMUX_PKG_DESCRIPTION="search for files within packages"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/a/apt-file/apt-file_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2ab7109340054f0073c690d62d055c31bf69e1f50fb65b080bbf0d4ae572dae7
TERMUX_PKG_DEPENDS="apt, libapt-pkg-perl, libregexp-assemble-perl, perl"
TERMUX_PKG_REPLACES="whatprovides"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="DESTDIR=$TERMUX_PREFIX BINDIR=$TERMUX_PREFIX/bin \
				MANDIR=$TERMUX_PREFIX/share/man/man1"


termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/bash_completion.d/
	cp $TERMUX_PKG_SRCDIR/debian/bash-completion \
		$TERMUX_PREFIX/etc/bash_completion.d/apt-file
}
