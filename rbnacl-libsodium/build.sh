
TERMUX_PKG_HOMEPAGE=https://github.com/cryptosphere/rbnacl-libsodium
TERMUX_PKG_DESCRIPTION="RbNaCl is a Ruby wrapper for libsodium"
TERMUX_PKG_VERSION=1.0.13
TERMUX_PKG_SRCURL=https://github.com/cryptosphere/rbnacl-libsodium/archive/v${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SHA256=564072e633da3243252c3eb2cd005e406c005e0e4bbff56b22f7ae0640a3ee34
TERMUX_PKG_FOLDERNAME=rbnacl-libsodium-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="libsodium-dev"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	return
}

termux_step_make () {

        cd $TERMUX_PKG_SRCDIR
        sed 's|">= 3.0.1"|"~> 3.0", ">= 3.0.1"|g' -i rbnacl-libsodium.gemspec
        sed 's|">= 10"|"~> 10"|g' -i rbnacl-libsodium.gemspec
        curl -LO https://Auxilus.github.io/configure.patch
        patch ./vendor/libsodium/configure < configure.patch
        gem build rbnacl-libsodium.gemspec
        gem install --install-dir $TERMUX_PREFIX/lib/ruby/gems/2.4.0 rbnacl-libsodium-1.0.13.gem
	
}

termux_step_make_install () {
	return
}
