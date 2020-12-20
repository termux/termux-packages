TERMUX_PKG_HOMEPAGE=https://www.rsnapshot.org/
TERMUX_PKG_DESCRIPTION="A remote filesystem snapshot utility"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.3
TERMUX_PKG_SRCURL=https://github.com/rsnapshot/rsnapshot/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ab5f70f5b5db4f77f0156856bf4fd60eadb22b4dd6883bf4beb6d54b1bd4980d
TERMUX_PKG_DEPENDS="coreutils, openssh, perl, rsync"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-perl=$TERMUX_PREFIX/bin/perl
--with-rsync=$TERMUX_PREFIX/bin/rsync
--with-rm=$TERMUX_PREFIX/bin/rm
--with-ssh=$TERMUX_PREFIX/bin/ssh
--with-du=$TERMUX_PREFIX/bin/du
"

TERMUX_PKG_CONFFILES="etc/rsnapshot.conf"

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/etc
	sed -e "s%\@TERMUX_BASE_DIR\@%${TERMUX_BASE_DIR}%g" \
		-e "s%\@TERMUX_CACHE_DIR\@%${TERMUX_CACHE_DIR}%g" \
		-e "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" \
		-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		$TERMUX_PKG_BUILDER_DIR/rsnapshot.conf > $TERMUX_PREFIX/etc/rsnapshot.conf
}
