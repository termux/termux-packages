TERMUX_PKG_HOMEPAGE=https://www.phpmyadmin.net
TERMUX_PKG_DESCRIPTION=" phpMyAdmin is (as the name says) written in PHP and uses MySQL."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=5.0.2
TERMUX_PKG_SRCURL=https://files.phpmyadmin.net/phpMyAdmin/$TERMUX_PKG_VERSION/phpMyAdmin-$TERMUX_PKG_VERSION-all-languages.tar.xz
TERMUX_PKG_SHA256=cbcc78d1499308d9329950fcba2ebaa84c559a934fe54efc027d459d8e4161c8
TERMUX_PKG_DEPENDS="php,apache2"
#TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/usr/share/phpmyadmin
	cp -ra $TERMUX_PKG_SRCDIR/* $TERMUX_PREFIX/usr/share/phpmyadmin
	mkdir $TERMUX_PREFIX/etc/phpmyadmin
	cp $TERMUX_PKG_SRCDIR/config.sample.inc.php $TERMUX_PREFIX/etc/phpmyadmin/config.inc.php
	ln -s $TERMUX_PREFIX/etc/phpmyadmin/config.inc.php $TERMUX_PREFIX/usr/share/phpmyadmin
	cp $TERMUX_PKG_BUILDER_DIR/phpmyadmin.conf $TERMUX_PREFIX/etc/apache2/conf.d

}
