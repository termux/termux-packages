TERMUX_PKG_HOMEPAGE=https://erthink.github.io/libmdbx/
TERMUX_PKG_DESCRIPTION="An extremely fast, compact, powerful, embedded, transactional key-value database"
TERMUX_PKG_LICENSE="OpenLDAP"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT, LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.11.4
TERMUX_PKG_SRCURL=https://github.com/erthink/libmdbx.git
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
