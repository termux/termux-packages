TERMUX_PKG_HOMEPAGE=https://github.com/composer/composer
TERMUX_PKG_DESCRIPTION="Composer is a tool for dependency management in PHP."
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_VERSION=2
TERMUX_PKG_DEPENDS="php"

termux_step_make_install() {
  if [ -f $TERMUX_PREFIX/composer ]; then
  rm $PREFIX/bin/composer
  else
  curl -sS https://getcomposer.org/installer | php -- --install-dir=$TERMUX_PREFIX/bin --filename=composer
   composer 
  fi

}