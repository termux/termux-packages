TERMUX_PKG_HOMEPAGE="https://gnucash.org"
TERMUX_PKG_DESCRIPTION="Personal and small-business financial-accounting software"
TERMUX_PKG_LICENSE="GPL-2.0-or-later" # with OpenSSL linking exceptions
TERMUX_PKG_LICENSE_FILE="LICENSE"     # specified for additional nuance.
TERMUX_PKG_MAINTAINER="@acozzette <acozzette@google.com>"
TERMUX_PKG_VERSION="5.12"
TERMUX_PKG_SRCURL="https://github.com/Gnucash/gnucash/releases/download/${TERMUX_PKG_VERSION}/gnucash-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256="b35b4756be12bcfdbed54468f30443fa53f238520a9cead5bde2e6c4773fbf39"
TERMUX_PKG_DEPENDS="boost, gettext, guile, glib, gtk3, libxml2, libxslt, perl, swig, webkit2gtk-4.1, xsltproc, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, googletest"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_SQL=OFF
-DWITH_OFX=OFF
-DWITH_AQBANKING=OFF
-DCMAKE_C_FLAGS=-Wno-format-security
"
