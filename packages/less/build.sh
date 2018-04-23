TERMUX_PKG_HOMEPAGE=http://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
TERMUX_PKG_VERSION=530
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=503f91ab0af4846f34f0444ab71c4b286123f0044a4964f1ae781486c617f2e2
TERMUX_PKG_SRCURL=http://www.greenwoodsoftware.com/less/less-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses, pcre"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-regex=pcre"
