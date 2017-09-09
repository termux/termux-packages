TERMUX_PKG_HOMEPAGE=https://ngrok.com
TERMUX_PKG_DESCRIPTION="creates a secure tunnel from a public endpoint to a locally running web service"
TERMUX_PKG_VERSION=1.7.1
TERMUX_PKG_SRCURL=https;//Auxilus.github.io/${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SHA256=564072e633da3243252c3eb2cd005e406c005e0e4bbff56b22f7ae0640a3ee34
TERMUX_PKG_FOLDERNAME=ngrok
#TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	return
}

termux_step_make () {

    cd $TERMUX_PKG_SRCDIR
    ls
    cp ngrok $TERMUX_PREFIX/bin/
    $TERMUX_PREFIX/ngrok
} 

termux_step_make_install () {
	return
}
