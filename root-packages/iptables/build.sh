TERMUX_PKG_HOMEPAGE=https://www.netfilter.org/projects/iptables
TERMUX_PKG_DESCRIPTION="Program used to configure the Linux 2.4 and later kernel packet filtering ruleset"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.12"
TERMUX_PKG_SRCURL=https://www.netfilter.org/projects/iptables/files/iptables-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8e7ee962601492de6503d171d4a948092ab18f89f111de72e3037c1f40cfb846
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libmnl, libnftnl, libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-xt-lock-name=$TERMUX_PREFIX/var/run/xtables.lock
"

termux_step_pre_configure() {
	export CFLAGS+=" -Dindex=strchr -Drindex=strrchr -D__STDC_FORMAT_MACROS=1"
}
