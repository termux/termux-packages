TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/findutils/
TERMUX_PKG_DESCRIPTION="Utilities to find files meeting specified criteria and perform various actions on the files which are found"
TERMUX_PKG_VERSION=4.6.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/findutils/findutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ded4c9f73731cd48fec3b6bdaccce896473b6d8e337e9612e16cf1431bb1169d
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="gl_cv_func_fflush_stdin=yes SORT_SUPPORTS_Z=yes SORT=$TERMUX_PREFIX/bin/applets/sort"
TERMUX_PKG_DEPENDS="libandroid-support"
# Remove locale and updatedb which in Termux is provided by mlocate:
TERMUX_PKG_RM_AFTER_INSTALL="bin/locate bin/updatedb share/man/man1/locate.1 share/man/man1/updatedb.1 share/man/man5/locatedb.5"

termux_step_pre_configure() {
	# This is needed for find to implement support for the
	# -fstype parameter by parsing /proc/self/mountinfo:
	CPPFLAGS+=" -DMOUNTED_GETMNTENT1=1"
}
