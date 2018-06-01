TERMUX_PKG_HOMEPAGE=https://hub.github.com/
TERMUX_PKG_DESCRIPTION="Command-line wrapper for git that makes you better at GitHub"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/github/hub/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=69e48105f7287537e7afaf969825666c1f09267eae3507515151900487342fae
TERMUX_PKG_DEPENDS="git"
TERMUX_PKG_BUILD_IN_SRC=yes
termux_step_pre_configure() {
	termux_download \
https://github.com/github/hub/releases/download/v2.3.0/hub-linux-amd64-2.3.0.tgz \
$TERMUX_PKG_CACHEDIR/hub-linux-amd64-$TERMUX_PKG_VERSION.tgz \
45b50fc52cf203dc16e4866217c8d0ca70b5f78668b4218e6697b118bcfce490
	tar xf $TERMUX_PKG_CACHEDIR/hub-linux-amd64-$TERMUX_PKG_VERSION.tgz -C $TERMUX_PKG_TMPDIR
}
termux_step_make() {
	termux_setup_golang
	make 
}
termux_step_make_install(){
	cd $TERMUX_PKG_TMPDIR/hub-linux-amd64-$TERMUX_PKG_VERSION
	./install
	cp $TERMUX_PKG_SRCDIR/bin/hub $TERMUX_PREFIX/bin
}
