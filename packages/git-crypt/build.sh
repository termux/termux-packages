TERMUX_PKG_HOMEPAGE=https://www.agwa.name/projects/git-crypt/
TERMUX_PKG_DESCRIPTION="Enables transparent encryption and decryption of files for a git repository"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@jottr"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.agwa.name/projects/git-crypt/downloads/git-crypt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=50f100816a636a682404703b6c23a459e4d30248b2886a5cf571b0d52527c7d8
TERMUX_PKG_DEPENDS="git, libc++, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DCMAKE_BUILD_TYPE=Release -Dbuild_parse=yes -Dbuild_xmlparser=yes"
TERMUX_PKG_EXTRA_MAKE_ARGS="ENABLE_MAN=yes"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# https://github.com/AGWA/git-crypt/issues/232
	CPPFLAGS+=" -DOPENSSL_API_COMPAT=0x30000000L"
	CXXFLAGS+=" $CPPFLAGS"
}
