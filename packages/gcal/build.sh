TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gcal/
TERMUX_PKG_DESCRIPTION="Program for calculating and printing calendars"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=91b56c40b93eee9bda27ec63e95a6316d848e3ee047b5880ed71e5e8e60f61ab
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gcal/gcal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_KEEP_INFOPAGES=yes

termux_step_post_make_install() {
	# XXX: share/info/dir is currently included in emacs.
	# We should probably make texinfo regenerate that file
	# just as the man package does with the man database.
	rm -f $TERMUX_PREFIX/share/info/dir
}
