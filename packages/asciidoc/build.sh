TERMUX_PKG_HOMEPAGE=https://asciidoc.org
TERMUX_PKG_DESCRIPTION="Text document format for short documents, articles, books and UNIX man pages."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.0.4
TERMUX_PKG_SRCURL=https://github.com/asciidoc/asciidoc-py3/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9e269f336a71e8685d03a00c71b55ca029eed9f7baf1afe67c447be32206b176
TERMUX_PKG_DEPENDS="docbook-xsl, libxml2-utils, python, xsltproc"
TERMUX_PKG_SUGGESTS="w3m"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vfi
}
