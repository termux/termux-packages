TERMUX_PKG_DESCRIPTION="empty test packet for build system "
TERMUX_PKG_VERSION=0
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_NO_ELF_CLEANER=true

termux_step_pre_configure() {
# echo $TERMUX_PREFIX
# echo $TERMUX_PREFIX_CLASSICAL
echo TERMUX_TOPDIR=$TERMUX_TOPDIR
# exit
# $TERMUX_ON_DEVICE_BUILD && test TERMUX_PREFIX = TERMUX_PREFIX_CLASSICAL && echo unsafe prefix detected && exit
echo pwd=
pwd
# touch a
# touch configure.in
# exit
test=123
$TERMUX_CONTINUE_BUILD || termux_error_exit I failed redo with -c 
}

termux_step_post_make_install() {
	test $test = 123 || echo test != 123
	pwd
	mkdir -p $TERMUX_PREFIX
	# cp $TERMUX_PKG_SRCDIR/* $TERMUX_PREFIX/
# install -Dm700 -t $TERMUX_PREFIX/ $TERMUX_PKG_SRCDIR/a
# cat $TERMUX_PKG_SRCDIR/configure.in
mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/usr
touch $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/usr/a
}

termux_step_extract_into_massagedir() {
$TERMUX_ON_DEVICE_BUILD && echo skip prefix folder scan on device to save the memory chip 
}

# termux_step_post_massage() {
termux_step_post_finish_build() {
	echo
echo -e '\e[1m post massage  \e[0m'
	echo TERMUX_PKG_PACKAGEDIR=$TERMUX_PKG_PACKAGEDIR
	ls $TERMUX_PKG_PACKAGEDIR
	tar tf $TERMUX_PKG_PACKAGEDIR/data.*
	dpkg -c $TERMUX_OUTPUT_DIR/test* | grep /DEBIAN/control && termux_error_exit 
	echo done
}
