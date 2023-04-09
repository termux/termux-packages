TERMUX_PKG_HOMEPAGE=https://os.ghalkes.nl/t3/libt3window.html
TERMUX_PKG_DESCRIPTION="A library providing a windowing abstraction on terminals"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.1
TERMUX_PKG_SRCURL=https://os.ghalkes.nl/dist/libt3window-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=4c14d3f4f946637fd6c3fa23ef7511fa505880946e151406d5e16f645d24e792
TERMUX_PKG_DEPENDS="libtranscript, libunistring, ncurses"
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

	CFLAGS+=" $CPPFLAGS"
}
