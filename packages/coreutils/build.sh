TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/coreutils/
TERMUX_PKG_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.10
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/coreutils/coreutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=16535a9adf0b10037364e2d612aad3d9f4eca3a344949ced74d12faf4bd51d25
TERMUX_PKG_DEPENDS="libandroid-selinux, libandroid-support, libgmp, libiconv, openssl (>= 1:3.5.0-1)"
TERMUX_PKG_BREAKS="chroot, busybox (<< 1.30.1-4)"
TERMUX_PKG_REPLACES="chroot, busybox (<< 1.30.1-4)"
TERMUX_PKG_ESSENTIAL=true
# On device build is unsupported as it removes utility 'ln' (and maybe
# something else) in the installation process.
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

# pinky has no usage on Android.
# df does not work either, let system binary prevail.
# users and who doesn't work and does not make much sense for Termux.
# uptime is provided by procps.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_host_operating_system=Android
ac_cv_func_getpass=yes
--disable-xattr
--with-packager=Termux
--enable-no-install-program=pinky,df,users,who,uptime
--enable-single-binary=symlinks
--with-gmp
"

termux_step_pre_configure() {
	# https://android.googlesource.com/platform/bionic/+/master/docs/32-bit-abi.md#is-32_bit-on-lp32-y2038
	if [[ "$TERMUX_ARCH_BITS" == '32' ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-year2038"
	fi

	CPPFLAGS+=" -D__USE_FORTIFY_LEVEL=0"
	LDFLAGS+=" -landroid-selinux"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/libexec/coreutils"
	{ # Set up a wrapper script to be called by `update-alternatives`
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "exec \"$TERMUX_PREFIX/bin/cat\" \"\$@\""
	} > "$TERMUX_PREFIX/libexec/coreutils/cat"
	chmod 700 "$TERMUX_PREFIX/libexec/coreutils/cat"
}
