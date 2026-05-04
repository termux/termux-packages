TERMUX_PKG_HOMEPAGE=https://fossil.instinctive.eu/libsoldout/index
TERMUX_PKG_DESCRIPTION="Flexible C library and tools for markdown"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="1.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://fossil.instinctive.eu/libsoldout-$TERMUX_PKG_VERSION.tar.bz2"
TERMUX_PKG_SHA256=92a8cf53f27a6eaa489473c37f6a3c32181ca5b75afea952fd15f4d168a4ffac
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-f GNUmakefile"

termux_step_make_install() {
	install -dm700 "$TERMUX_PREFIX"/{lib,bin,include/$TERMUX_PKG_NAME,share/{doc/$TERMUX_PKG_NAME,man/man{1,3}}}
	install -pm600 -t "$TERMUX_PREFIX"/share/doc/"$TERMUX_PKG_NAME" README CHANGES
	install -pm600 -t "$TERMUX_PREFIX/share/man/man3" *.3
	install -pm600 -t "$TERMUX_PREFIX/share/man/man1" $(ls *.1 | grep -v '\.so')
	install -pm600 -t "$TERMUX_PREFIX/include/$TERMUX_PKG_NAME" *.h
	install -pm700 -t "$TERMUX_PREFIX/lib" libsoldout.{a,so,so.*}
	install -pm700 -t "$TERMUX_PREFIX/bin" mkd2{html,latex,man}
}
