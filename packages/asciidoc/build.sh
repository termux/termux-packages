TERMUX_PKG_HOMEPAGE=https://asciidoc.org
TERMUX_PKG_DESCRIPTION="Text document format for short documents, articles, books and UNIX man pages."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.1.0
TERMUX_PKG_SRCURL=https://github.com/asciidoc/asciidoc-py3/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5056c20157349f8dc74f005b6e88ccbf1078c4e26068876f13ca3d1d7d045fe7
TERMUX_PKG_DEPENDS="docbook-xsl, libxml2-utils, python, xsltproc"
TERMUX_PKG_SUGGESTS="w3m"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vfi
}
