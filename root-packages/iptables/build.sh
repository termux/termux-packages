TERMUX_PKG_HOMEPAGE=https://www.netfilter.org/projects/iptables
TERMUX_PKG_DESCRIPTION="Program used to configure the Linux 2.4 and later kernel packet filtering ruleset"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.8
TERMUX_PKG_SRCURL=https://www.netfilter.org/projects/iptables/files/iptables-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=71c75889dc710676631553eb1511da0177bbaaf1b551265b912d236c3f51859f
TERMUX_PKG_DEPENDS="libmnl, libnftnl, libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-xt-lock-name=$TERMUX_PREFIX/var/run/xtables.lock
"

termux_step_pre_configure() {
	export CFLAGS+=" -Dindex=strchr -Drindex=strrchr -D__STDC_FORMAT_MACROS=1"
}
