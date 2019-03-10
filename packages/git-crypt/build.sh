TERMUX_PKG_HOMEPAGE=https://www.agwa.name/projects/git-crypt/
TERMUX_PKG_DESCRIPTION="git-crypt enables transparent encryption and decryption of files in a git repository."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_MAINTAINER="@jottr"
TERMUX_PKG_SHA256=777c0c7aadbbc758b69aff1339ca61697011ef7b92f1d1ee9518a8ee7702bb78
TERMUX_PKG_SRCURL="https://github.com/AGWA/git-crypt/archive/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DCMAKE_BUILD_TYPE=Release -Dbuild_parse=yes -Dbuild_xmlparser=yes"
TERMUX_PKG_EXTRA_MAKE_ARGS="make ENABLE_MAN=yes"
TERMUX_PKG_DEPENDS="git, openssl"

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
	make
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR
	make install
}
