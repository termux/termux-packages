
TERMUX_PKG_HOMEPAGE=https://www.metasploit.com/
TERMUX_PKG_DESCRIPTION="framework for pentesting"
TERMUX_PKG_VERSION=4.16.2
TERMUX_PKG_SRCURL=https://github.com/rapid7/metasploit-framework/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=564072e633da3243252c3eb2cd005e406c005e0e4bbff56b22f7ae0640a3ee34
TERMUX_PKG_FOLDERNAME=metasploit-framework-$TERMUX_PKG_VERSION
#TERMUX_PKG_DEPENDS=
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	return
}

termux_step_make () {
        gem install --install-dir $TERMUX_PREFIX/lib/ruby/gems/2.4.0 bundler --platform arm-linux
	
        #gem install --install-dir TERMUX_PREFIX/lib/ruby/gems/2.4.0 nokogiri -- --use-system-libraries --install-dir $TERMUX_PREFIX/lib/ruby/gems/2.4.0 --platform arm-linux
        echo $TERMUX_PKG_SRCDIR
        ls
        cd $TERMUX_PKG_SRCDIR
        gem unpack grpc -v 1.4.1
        cd $TERMUX_PKG_BUILDDIR/grpc-1.4.1
	patch -p1 < /home/builder/termux-packages/packages/metasploit-framework/extconf.patch.grpc
        gem build $TERMUX_PKG_SRCDIR/grpc-1.4.1/grpc.gemspec
        gem install $TERMUX_PKG_SRCDIR/grpc-1.4.1.gem --install-dir $TERMUX_PREFIX/lib/ruby/gems/2.4.0 --platform arm-linux
        
        #cd $TERMUX_PKG_BUILDDIR
        cd $TERMUX_PKG_SRCDIR
        echo $('ls')
        #bundle install -j5

        ln -s $TERMUX_PKG_SRCDIR/msfconsole $TERMUX_PREFIX/bin/
}

termux_step_make_install () {
	return
}
