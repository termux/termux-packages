TERMUX_PKG_HOMEPAGE=https://github.com/vergoh/vnstat
TERMUX_PKG_DESCRIPTION="A console-based network traffic monitor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Denzy7"
TERMUX_PKG_VERSION="2.14"
TERMUX_PKG_SRCURL=https://github.com/vergoh/vnstat/releases/download/v${TERMUX_PKG_VERSION}/vnstat-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ba2119b3c6f780775135f9c9fa7236867da67e2f93649f1313319b9cf48f87c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libsqlite"
TERMUX_PKG_SERVICE_SCRIPT=("vnstat" "exec su -c \"PATH=\$PATH $TERMUX_PREFIX/bin/vnstatd -n 2>&1\"")

# from dockerd root package: https://github.com/termux/termux-packages/blob/master/root-packages/dockerd/build.sh
termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/var/service/vnstat/
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "su -c pkill vnstatd"
	} > $TERMUX_PREFIX/var/service/vnstat/finish
	chmod u+x $TERMUX_PREFIX/var/service/vnstat/finish
}
