TERMUX_PKG_HOMEPAGE=http://sqlmap.org
TERMUX_PKG_DESCRIPTION="open source penetration testing tool that automates the process of detecting and exploiting SQL injection flaws and taking over of database servers"
TERMUX_PKG_VERSION=1.1.11
TERMUX_PKG_SRCURL=https://github.com/sqlmapproject/sqlmap/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c99f626f34e947dae14248bb6a7a989ec85c8909aef03ff7ff96fe4cb021b8eb
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="python2" 

termux_step_post_make_install () {
     mkdir -p $TERMUX_PREFIX/share/sqlmap
     mv ./* $TERMUX_PREFIX/share/sqlmap/
     echo "$PREFIX/bin/python2 $PREFIX/share/sqlmap/sqlmap.py" > $TERMUX_PREFIX/bin/sqlmap
     chmod +x $TERMUX_PREFIX/bin/sqlmap
} 
