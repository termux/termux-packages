TERMUX_PKG_HOMEPAGE="https://logging.apache.org/log4cxx/latest_stable/index.html"
TERMUX_PKG_DESCRIPTION="A logging framework for C++ patterned after Apache log4j"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_SRCURL="https://github.com/apache/logging-log4cxx/archive/refs/tags/rel/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d7f8d5af5f69e26b99de61fe1585bc48713ced78d18eb0979bb4844d21aed253
TERMUX_PKG_DEPENDS="libc++, libxml2, apr-util, apr, libexpat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DBUILD_TESTING=OFF
"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
