TERMUX_PKG_HOMEPAGE=https://roundcube.net/
TERMUX_PKG_DESCRIPTION="Browser-based multilingual IMAP webmail client"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="1.7.6"
TERMUX_PKG_SRCURL="https://github.com/roundcube/roundcubemail/releases/download/${TERMUX_PKG_VERSION}/roundcubemail-${TERMUX_PKG_VERSION}-complete.tar.gz"
TERMUX_PKG_SHA256=0168085bf0bfeeb5d4eca3b9730effbe610dbdb380a68567d292fec51f09db36
TERMUX_PKG_DEPENDS="apache2, php, php-apache"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/roundcube/config.inc.php"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	rm -rf "$TERMUX_PREFIX/share/roundcube"
	mkdir -p "$TERMUX_PREFIX/share/roundcube"
	cp -a "$TERMUX_PKG_SRCDIR"/* "$TERMUX_PREFIX/share/roundcube/"
	mkdir -p "$TERMUX_PREFIX/etc/roundcube"
	DES_KEY="$(openssl rand -base64 24)"
	cat > "$TERMUX_PREFIX/etc/roundcube/config.inc.php" <<-EOF
		<?php
		\$config = [];
		\$config['db_dsnw'] = 'sqlite:///$TERMUX_PREFIX/var/lib/roundcube/roundcube.sqlite?mode=0640';
		\$config['temp_dir'] = '$TERMUX_PREFIX/var/lib/roundcube/temp/';
		\$config['log_dir'] = '$TERMUX_PREFIX/var/log/roundcube/';
		\$config['des_key'] = '$DES_KEY';
		\$config['cipher_method'] = 'AES-256-CBC';
		\$config['default_host'] = 'localhost';
	EOF
	ln -sf "$TERMUX_PREFIX/etc/roundcube/config.inc.php" "$TERMUX_PREFIX/share/roundcube/config/"
	mkdir -p "$TERMUX_PREFIX/etc/apache2/conf.d"
	sed -e "s%\\@TERMUX_PREFIX\\@%${TERMUX_PREFIX}%g" "$TERMUX_PKG_BUILDER_DIR/roundcube.conf" \
		> "$TERMUX_PREFIX/etc/apache2/conf.d/roundcube.conf"
	mkdir -p "$TERMUX_PREFIX/var/lib/roundcube/temp" "$TERMUX_PREFIX/var/lib/roundcube/sessions" "$TERMUX_PREFIX/var/log/roundcube"
	touch "$TERMUX_PREFIX/var/lib/roundcube/temp/.placeholder" "$TERMUX_PREFIX/var/lib/roundcube/sessions/.placeholder" "$TERMUX_PREFIX/var/log/roundcube/.placeholder"
	php -l "$TERMUX_PREFIX/etc/roundcube/config.inc.php"
}
