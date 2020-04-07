TERMUX_PKG_HOMEPAGE=http://linuxcontainers.org/
TERMUX_PKG_DESCRIPTION="Linux Containers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.0.1
TERMUX_PKG_SRCURL=https://linuxcontainers.org/downloads/lxc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=70bbaac1df097f32ee5493a5e67a52365f7cdda28529f40197d6160bbec4139d
TERMUX_PKG_DEPENDS="gnupg, libcap, libseccomp, rsync, wget"
TERMUX_PKG_BREAKS="lxc-dev"
TERMUX_PKG_REPLACES="lxc-dev"

# Do not build for ARM due to
# error: /home/builder/.termux-build/_cache/android-r20-api-24-v1/bin/../lib/gcc/arm-linux-androideabi/4.9.x/armv7-a/thumb/libgcc_real.a(pr-support.o): multiple definition of '__gnu_unwind_frame'
#TERMUX_PKG_BLACKLISTED_ARCHES="arm"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-distro=termux
--with-runtime-path=$TERMUX_PREFIX/var/run
--disable-apparmor
--disable-selinux
--enable-seccomp
--enable-capabilities
--disable-examples
--disable-werror
"

termux_step_post_make_install() {
	# Simple helper script for mounting cgroups.
	install -Dm755 "$TERMUX_PKG_BUILDER_DIR"/lxc-setup-cgroups.sh \
		"$TERMUX_PREFIX"/bin/lxc-setup-cgroups
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" "$TERMUX_PREFIX"/bin/lxc-setup-cgroups
}
