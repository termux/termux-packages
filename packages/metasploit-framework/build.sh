TERMUX_PKG_HOMEPAGE=https://metasploit.com/
TERMUX_PKG_DESCRIPTION="The metasploit framework is an open source computer security project that provides information about security vulnerabilities and aids in penetration testing and IDS signature development"
TERMUX_PKG_VERSION=4.16.2
TERMUX_PKG_DEPENDS="autoconf, bison, clang, coreutils, curl, findutils, git, apr, apr-util, libffi-dev, libgmp-dev, libpcap-dev, postgresql-dev, readline-dev, libsqlite-dev, openssl-dev, libtool, libxml2-dev, libxslt-dev, ncurses-dev, pkg-config, postgresql-contrib, wget, make, ruby-dev, libgrpc-dev, termux-tools, ncurses-utils, ncurses, unzip, zip, tar"
TERMUX_PKG_SRCURL=https://github.com/rapid7/metasploit-framework/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=564072e633da3243252c3eb2cd005e406c005e0e4bbff56b22f7ae0640a3ee34
TERMUX_PKG_FOLDERNAME=metasploit-framework-$TERMUX_PKG_VERSION

termux_step_post_massage () {
	local MSFDIR=$TERMUX_PKG_MASSAGEDIR$TERMUX_PREFIX/share/metasploit-framework
	mkdir -p $MSFDIR
	mv $TERMUX_PKG_SRCDIR/* $MSFDIR
	cd $MSFDIR
	
	# Skip rbnacl
	sed '/rbnacl/d' -i Gemfile.lock
	sed '/rbnacl/d' -i metasploit-framework.gemspec

	# Skip grpc
	sed '/grpc/d' -i Gemfile.lock
	sed '/grpc/d' -i metasploit-framework.gemspec

	for MSF in $(ls msf*); do ln -sf $MSF $TERMUX_PREFIX/bin/$MSF;done
}

termux_step_create_debscripts () {
	## POST INSTALL:
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "cd $TERMUX_PREFIX/share/metasploit-framework" >> postinst
	echo 'gem install bundler' >> postinst
	echo 'gem install nokogiri -- --use-system-libraries' >> postinst
	echo 'bundle' >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}


