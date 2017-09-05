TERMUX_PKG_HOMEPAGE=https://www.metasploit.com/
TERMUX_PKG_DESCRIPTION="framework for pentesting"
TERMUX_PKG_VERSION=4.16.2
# Depend on coreutils for bin/env
TERMUX_PKG_DEPENDS="wget, ruby, curl"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	
	cd $PREFIX/share/
        wget https://Auxilus.github.io/metasploit.sh
	
}
