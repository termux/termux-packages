TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gnucap/gnucap.html
TERMUX_PKG_DESCRIPTION="The Gnu Circuit Analysis Package"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=20210107
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.com/gnucap/gnucap/-/archive/${TERMUX_PKG_VERSION}/gnucap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d2c24a66c7e60b379727c9e9487ed1b4a3532646b3f4cc03c6a4305749e3348b
TERMUX_PKG_DEPENDS="libc++, readline"
TERMUX_PKG_BREAKS="gnucap-dev"
TERMUX_PKG_REPLACES="gnucap-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build () {
	cp -r $TERMUX_PKG_SRCDIR/* .
	./configure
	(cd lib && make)
	(cd modelgen && make)
}

termux_step_pre_configure () {
	sed -i "s%@TERMUX_PKG_HOSTBUILD_DIR@%$TERMUX_PKG_HOSTBUILD_DIR%g" $TERMUX_PKG_SRCDIR/apps/Make1
}

termux_step_configure () {
	$TERMUX_PKG_SRCDIR/configure --prefix=$TERMUX_PREFIX
}
