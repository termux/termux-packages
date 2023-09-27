TERMUX_PKG_HOMEPAGE=https://devel.ringlet.net/editors/hexer/
TERMUX_PKG_DESCRIPTION="A multi-buffer editor for binary files for Unix-like systems that displays its buffer(s) as a hex dump"
TERMUX_PKG_LICENSE="non-free"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.6
TERMUX_PKG_SRCURL=https://devel.ringlet.net/files/editors/hexer/hexer-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e6b84ace5283825943f88ce7ec4ae836ec15ba41978b3a858d6d478cfe09ff94
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
PREFIX=$TERMUX_PREFIX
MANDIR=$TERMUX_PREFIX/share/man/man1
INSTALLBIN=install
"

termux_step_post_configure() {
	cat >> config.h <<-EOF
		#if defined __ANDROID__ && __ANDROID_API__ < 26
		#define getpwent() (NULL)
		#define setpwent() ((void)0)
		#endif
	EOF

	make CPPFLAGS= CFLAGS= LDFLAGS= bin2c
}
