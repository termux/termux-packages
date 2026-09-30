TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/findutils/
TERMUX_PKG_DESCRIPTION="Utilities to find files meeting specified criteria and perform various actions on the files which are found"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.11.0
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/findutils/findutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bfd19cb06cc71f3352d567e90284d8cdac02ac89774bbeadf0b533b0c11432fd
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_GROUPS="base-devel"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_func_fflush_stdin=no
SORT_SUPPORTS_Z=yes
SORT=$TERMUX_PREFIX/bin/sort
"

# Remove locale and updatedb which in Termux is provided by mlocate:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/locate
bin/updatedb
share/man/man1/locate.1.gz
share/man/man1/updatedb.1.gz
share/man/man5/locatedb.5.gz
"

termux_step_pre_configure() {
	# This is needed for find to implement support for the
	# -fstype parameter by parsing /proc/self/mountinfo:
	CPPFLAGS+=" -DMOUNTED_GETMNTENT1=1"

	# https://android.googlesource.com/platform/bionic/+/master/docs/32-bit-abi.md#is-32_bit-on-lp32-y2038
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-year2038"
	fi
}
