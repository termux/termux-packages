TERMUX_PKG_HOMEPAGE=https://www.phpmyadmin.net
TERMUX_PKG_DESCRIPTION="A PHP tool for administering MySQL databases"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.0
TERMUX_PKG_SRCURL=https://files.phpmyadmin.net/phpMyAdmin/$TERMUX_PKG_VERSION/phpMyAdmin-$TERMUX_PKG_VERSION-all-languages.tar.xz
TERMUX_PKG_SHA256=66da31ca295f06182ac3f2e6e96057dc824c459baedf4b29de6ed0d3be039230
TERMUX_PKG_DEPENDS="apache2, php"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/phpmyadmin/config.inc.php"

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/share/phpmyadmin
	mkdir -p $TERMUX_PREFIX/share/phpmyadmin
	cp -a $TERMUX_PKG_SRCDIR/* $TERMUX_PREFIX/share/phpmyadmin/
	mkdir -p $TERMUX_PREFIX/etc/phpmyadmin
	cp $TERMUX_PKG_SRCDIR/config.sample.inc.php $TERMUX_PREFIX/etc/phpmyadmin/config.inc.php
	ln -s $TERMUX_PREFIX/etc/phpmyadmin/config.inc.php $TERMUX_PREFIX/share/phpmyadmin
	mkdir -p $TERMUX_PREFIX/etc/apache2/conf.d
	sed -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PKG_BUILDER_DIR/phpmyadmin.conf \
		> $TERMUX_PREFIX/etc/apache2/conf.d/phpmyadmin.conf
}
