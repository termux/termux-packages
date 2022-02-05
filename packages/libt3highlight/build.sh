TERMUX_PKG_HOMEPAGE=https://os.ghalkes.nl/t3/libt3highlight.html
TERMUX_PKG_DESCRIPTION="A library for syntax highlighting different types of text files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SRCURL=https://os.ghalkes.nl/dist/libt3highlight-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8216190785e52a116f9f78ec6513815745904c2aaf70d0a0a09438e08640dfbb
TERMUX_PKG_DEPENDS="libt3config, pcre2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gettext"

termux_step_post_get_source() {
	sed -i 's/ -s / /g' Makefile.in
}

termux_step_pre_configure() {
	local libtooldir=$TERMUX_PKG_TMPDIR/_libtool
	mkdir -p $libtooldir
	pushd $libtooldir
	cat > configure.ac <<-EOF
		AC_INIT
		LT_INIT
		AC_OUTPUT
	EOF
	touch install-sh
	cp "$TERMUX_SCRIPTDIR/scripts/config.sub" ./
	cp "$TERMUX_SCRIPTDIR/scripts/config.guess" ./
	autoreconf -fi
	./configure --host=$TERMUX_HOST_PLATFORM
	popd
	export LIBTOOL=$libtooldir/libtool
}
