TERMUX_PKG_HOMEPAGE=https://github.com/vergoh/vnstat
TERMUX_PKG_DESCRIPTION="A console-based network traffic monitor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Denzy7"
TERMUX_PKG_VERSION=2.12
TERMUX_PKG_SRCURL=https://github.com/vergoh/vnstat/releases/download/v${TERMUX_PKG_VERSION}/vnstat-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b7386b12fc1fc6f47fab31f208b12eda61862e63e229e84e95a6fa80406d2852
TERMUX_PKG_DEPENDS="libsqlite"
TERMUX_PKG_SERVICE_SCRIPT=("vnstat" "exec su -c \"PATH=\$PATH $TERMUX_PREFIX/bin/vnstatd -n 2>&1\"")

# from docker root package: https://github.com/termux/termux-packages/blob/master/root-packages/docker/build.sh
termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/var/service/vnstat/
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "su -c pkill vnstatd"
	} > $TERMUX_PREFIX/var/service/vnstat/finish
	chmod u+x $TERMUX_PREFIX/var/service/vnstat/finish
}
