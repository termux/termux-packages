TERMUX_PKG_HOMEPAGE=http://asciidoc.org
TERMUX_PKG_DESCRIPTION="Text document format for writing notes, documentation, articles, books, ebooks, slideshows, web pages, man pages and blogs"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=8.6.10
TERMUX_PKG_SRCURL=https://github.com/asciidoc/asciidoc/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9e52f8578d891beaef25730a92a6e723596ddbd07bfe0d2a56486fcf63a0b983
TERMUX_PKG_DEPENDS="libxslt, python2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sed -i -e 's#python a2x.py#python2 a2x.py#' Makefile.in
	autoreconf -vfi
}

termux_step_post_make_install() {
	make docs
	install -Dm644 asciidocapi.py \
                $TERMUX_PREFIX/lib/python2.7/site-packages/asciidocapi.py

}
