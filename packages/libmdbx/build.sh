TERMUX_PKG_HOMEPAGE=https://libmdbx.dqdkfa.ru/
TERMUX_PKG_DESCRIPTION="An extremely fast, compact, powerful, embedded, transactional key-value database"
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.12.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://gitflic.ru/project/erthink/libmdbx.git
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
