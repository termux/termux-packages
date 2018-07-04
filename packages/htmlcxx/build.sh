TERMUX_PKG_HOMEPAGE=https://github.com/dhoerl/htmlcxx
TERMUX_PKG_DESCRIPTION="simple HTML/CSS1 parser library for C++"
TERMUX_PKG_VERSION=0.85
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/h/htmlcxx/htmlcxx_$TERMUX_PKG_VERSION.orig.tar.gz
TERMUX_PKG_SHA256=ab02a0c4addc82f82d564f7d163fe0cc726179d9045381c288f5b8295996bae5
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=""
termux_step_pre_configure() {
	autoreconf -if
}
