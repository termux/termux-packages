TERMUX_PKG_HOMEPAGE=https://www.phpmyadmin.net
TERMUX_PKG_DESCRIPTION="A PHP tool for administering MySQL and MariaDB databases"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@williamdes"
TERMUX_PKG_VERSION=5.2.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://files.phpmyadmin.net/phpMyAdmin/$TERMUX_PKG_VERSION/phpMyAdmin-$TERMUX_PKG_VERSION-all-languages.tar.xz
TERMUX_PKG_SHA256=57881348297c4412f86c410547cf76b4d8a236574dd2c6b7d6a2beebe7fc44e3
TERMUX_PKG_DEPENDS="apache2, php, php-apache"
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
	# Variable data folder
	mkdir -p $TERMUX_PREFIX/var/lib/phpmyadmin/sessions
	touch "$TERMUX_PREFIX/var/lib/phpmyadmin/sessions/.placeholder"
	mkdir -p $TERMUX_PREFIX/var/lib/phpmyadmin/tmp
	touch "$TERMUX_PREFIX/var/lib/phpmyadmin/tmp/.placeholder"
	mkdir -p $TERMUX_PREFIX/var/lib/phpmyadmin/uploads
	touch "$TERMUX_PREFIX/var/lib/phpmyadmin/uploads/.placeholder"
	# Custom settings
	sed -i "s,\$cfg\['UploadDir'\] = '';,\$cfg\['UploadDir'\] = '$TERMUX_PREFIX/var/lib/phpmyadmin/uploads';," $TERMUX_PREFIX/etc/phpmyadmin/config.inc.php
	sed -i "s,\$cfg\['SaveDir'\] = '';,\$cfg\['SaveDir'\] = '$TERMUX_PREFIX/var/lib/phpmyadmin/uploads';," $TERMUX_PREFIX/etc/phpmyadmin/config.inc.php
	echo "\$cfg['TempDir'] = '$TERMUX_PREFIX/var/lib/phpmyadmin/tmp';" >> $TERMUX_PREFIX/etc/phpmyadmin/config.inc.php
	# Check for syntax errors
	php -l $TERMUX_PREFIX/etc/phpmyadmin/config.inc.php
}
