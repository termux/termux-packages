TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/autoconf-archive/
TERMUX_PKG_DESCRIPTION="Autoconf Macro Archive"
TERMUX_PKG_VERSION=09.28
TERMUX_PKG_SRCURL=http://ftp.wayne.edu/gnu/autoconf-archive/autoconf-archive-2017.${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c9fb5845b38b28982a3ef12836f76b35f46799ef4a2e46b48e2bd3c6182fa01
TERMUX_PKG_MAINTAINER="lokesh @hax4us"
TERMUX_PKG_DEPENDS="autoconf"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes


termux_step_post_extract_package () {
		perl -p -i -e "s|/bin/sh|$TERMUX_PREFIX/bin/sh|" m4/*
	}


