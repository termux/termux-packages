TERMUX_PKG_HOMEPAGE=https://asciidoc.org
TERMUX_PKG_DESCRIPTION="Text document format for short documents, articles, books and UNIX man pages."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=9.0.1
TERMUX_PKG_SRCURL=https://github.com/asciidoc/asciidoc-py3/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73af9ee590b050e9f46ef85eb7756944dffdc9b3333e3e60c153a6e1f1de0ba5
TERMUX_PKG_DEPENDS="docbook-xsl, libxml2-utils, python, xsltproc"
TERMUX_PKG_SUGGESTS="w3m"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vfi
}
