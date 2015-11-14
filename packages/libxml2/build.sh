TERMUX_PKG_HOMEPAGE=http://www.xmlsoft.org
TERMUX_PKG_DESCRIPTION="Library for parsing XML documents"
TERMUX_PKG_VERSION=2.9.2
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=ftp://xmlsoft.org/libxml2/libxml2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-python"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc bin/xml2-config bin/xmlcatalog lib/xml2Conf.sh share/man/man1/xml2-config.1 share/man/man1/xmlcatalog.1"
TERMUX_PKG_DEPENDS="liblzma"
