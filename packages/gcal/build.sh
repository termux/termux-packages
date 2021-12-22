TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gcal/
TERMUX_PKG_DESCRIPTION="Program for calculating and printing calendars"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gcal/gcal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=91b56c40b93eee9bda27ec63e95a6316d848e3ee047b5880ed71e5e8e60f61ab
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_spawn_h=no
"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_post_make_install() {
	# XXX: share/info/dir is currently included in emacs.
	# We should probably make texinfo regenerate that file
	# just as the man package does with the man database.
	rm -f $TERMUX_PREFIX/share/info/dir
}
