TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/coreutils/
TERMUX_PKG_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=8.31
TERMUX_PKG_REVISION=4
TERMUX_PKG_SHA256=ff7a9c918edce6b4f4b2725e3f9b37b0c4d193531cac49a48b56c4d0d3a9e9fd
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/coreutils/coreutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="libiconv"

# pinky has no usage on Android.
# df does not work either, let system binary prevail.
# $PREFIX/bin/env is provided by busybox for shebangs to work directly.
# users and who doesn't work and does not make much sense for Termux.
# uptime is provided by procps.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_host_operating_system=Android
ac_cv_func_getpass=yes
--disable-xattr
--enable-no-install-program=pinky,df,chroot,env,users,who,uptime
--enable-single-binary=symlinks
--without-gmp
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DDEFAULT_TMPDIR=\\\"$TERMUX_PREFIX/tmp\\\""
	CPPFLAGS+=" -D__USE_FORTIFY_LEVEL=0"
}
