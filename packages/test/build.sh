TERMUX_PKG_DESCRIPTION="empty test packet for build system "
TERMUX_PKG_VERSION=0
TERMUX_PKG_LICENSE="WTFPL"

termux_step_pre_configure() {
# echo $TERMUX_PREFIX
# echo $TERMUX_PREFIX_CLASSICAL
# echo $TERMUX_TOPDIR
# exit
$TERMUX_ON_DEVICE_BUILD && test TERMUX_PREFIX = TERMUX_PREFIX_CLASSICAL && echo unsafe prefix detected && exit
pwd
touch a
# touch configure.in
# exit
}

termux_step_post_make_install() {
	pwd
	mkdir -p $TERMUX_PREFIX
	cp $TERMUX_PKG_SRCDIR/* $TERMUX_PREFIX/
# install -Dm700 -t $TERMUX_PREFIX/ $TERMUX_PKG_SRCDIR/a
# cat $TERMUX_PKG_SRCDIR/configure.in
}
