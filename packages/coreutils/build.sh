TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/coreutils/
TERMUX_PKG_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
TERMUX_PKG_VERSION=8.29
TERMUX_PKG_SHA256=92d0fa1c311cacefa89853bdb53c62f4110cdfda3820346b59cbd098f40f955e
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/coreutils/coreutils-${TERMUX_PKG_VERSION}.tar.xz
# pinky has no usage on Android.
# df does not work either, let system binary prevail.
# $PREFIX/bin/env is provided by busybox for shebangs to work directly.
# users and who doesn't work and does not make much sense for Termux.
# uptime is provided by procps.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_host_operating_system=Android
--enable-no-install-program=pinky,df,chroot,env,users,who,uptime
--enable-single-binary=symlinks
--without-gmp
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DDEFAULT_TMPDIR=\\\"$TERMUX_PREFIX/tmp\\\""
}
