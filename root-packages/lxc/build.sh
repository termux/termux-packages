TERMUX_PKG_HOMEPAGE=http://linuxcontainers.org/
TERMUX_PKG_DESCRIPTION="Linux Containers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.2.1
TERMUX_PKG_SRCURL=https://linuxcontainers.org/downloads/lxc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5f903986a4b17d607eea28c0aa56bf1e76e8707747b1aa07d31680338b1cc3d4
TERMUX_PKG_DEPENDS="dirmngr, gnupg, libcap, libseccomp, rsync, wget"
TERMUX_PKG_BREAKS="lxc-dev"
TERMUX_PKG_REPLACES="lxc-dev"

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

termux_step_pre_configure() {
	export LIBS="-llog"
}

termux_step_post_make_install() {
	# Simple helper script for mounting cgroups.
	install -Dm755 "$TERMUX_PKG_BUILDER_DIR"/lxc-setup-cgroups.sh \
		"$TERMUX_PREFIX"/bin/lxc-setup-cgroups
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" "$TERMUX_PREFIX"/bin/lxc-setup-cgroups
}
