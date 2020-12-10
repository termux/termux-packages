TERMUX_PKG_HOMEPAGE=https://php.net
TERMUX_PKG_DESCRIPTION="Dependency Manager for PHP"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=2.0.8
TERMUX_PKG_DEPENDS="php,unzip"

termux_step_post_make_install() {
    cd 
    EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
    cd
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
    then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
    fi
    
    php composer-setup.php --quiet
    RESULT=$?
    rm composer-setup.php
    mv composer.phar $TERMUX_PREFIX/bin/composer
    exit $RESULT
}
