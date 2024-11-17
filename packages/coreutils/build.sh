TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/coreutils/
TERMUX_PKG_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.5
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/coreutils/coreutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cd328edeac92f6a665de9f323c93b712af1858bc2e0d88f3f7100469470a1b8a
TERMUX_PKG_DEPENDS="libandroid-selinux, libandroid-support, libgmp, libiconv"
TERMUX_PKG_BREAKS="chroot, busybox (<< 1.30.1-4)"
TERMUX_PKG_REPLACES="chroot, busybox (<< 1.30.1-4)"
TERMUX_PKG_ESSENTIAL=true

# pinky has no usage on Android.
# df does not work either, let system binary prevail.
# $PREFIX/bin/env is provided by busybox for shebangs to work directly.
# users and who doesn't work and does not make much sense for Termux.
# uptime is provided by procps.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_host_operating_system=Android
ac_cv_func_getpass=yes
--disable-xattr
--enable-no-install-program=pinky,df,users,who,uptime
--enable-single-binary=symlinks
--with-gmp
"

termux_step_pre_configure() {
	# https://android.googlesource.com/platform/bionic/+/master/docs/32-bit-abi.md#is-32_bit-on-lp32-y2038
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-year2038"
	fi

	CPPFLAGS+=" -D__USE_FORTIFY_LEVEL=0"
	LDFLAGS+=" -landroid-selinux"

	# On device build is unsupported as it removes utility 'ln' (and maybe
	# something else) in the installation process.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}
