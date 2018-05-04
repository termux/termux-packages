TERMUX_PKG_HOMEPAGE=http://znc.in
TERMUX_PKG_DESCRIPTION="An advanced IRC bouncer"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_MAINTAINER=raku-cat
TERMUX_PKG_SHA256=c07e31439ac6b948a577bd61a9d5f61a6d191d387423779b937aa1404051b96f
TERMUX_PKG_SRCURL=https://znc.in/releases/znc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, readline, openssl, python, tcl, perl, python, libicu, swig, readline, libsasl, bthread"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWANT_ZLIB=true -DWANT_OPENSSL=true -DWANT_PYTHON=true -DWANT_TCL=true -DWANT_SWIG=true -DPERL_EXECUTABLE=/usr/bin/perl"
TERMUX_PKG_FORCE_CMAKE=yes

#termux_step_pre_configure() {
#    mkdir repo
#    git clone --bare https://github.com/znc/znc.git repo
#    mkdir .git
#    mv repo/* .git/
#    git init
#    git pull
#    git reset HEAD
#    git submodule update --init --recursive
#}