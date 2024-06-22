TERMUX_PKG_HOMEPAGE=https://www.rsnapshot.org/
TERMUX_PKG_DESCRIPTION="A remote filesystem snapshot utility"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.5"
TERMUX_PKG_SRCURL=https://github.com/rsnapshot/rsnapshot/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8ef500e2eaee85a37fb8000f73b3b1325569fcfe940a7e8ea66a8f243cb289a3
TERMUX_PKG_AUTO_UPDATE=true
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
