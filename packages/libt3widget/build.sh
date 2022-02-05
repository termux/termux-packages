TERMUX_PKG_HOMEPAGE=https://os.ghalkes.nl/t3/libt3widget.html
TERMUX_PKG_DESCRIPTION="A library of widgets and dialogs to facilitate construction of easy-to-use terminal-based programs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_SRCURL=https://os.ghalkes.nl/dist/libt3widget-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9eb7e1d0ccdfc917f18ba1785a2edb4faa6b0af8b460653d962abf91136ddf1c
TERMUX_PKG_DEPENDS="libc++, libt3key, libt3window, libtranscript, libunistring, pcre2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-gettext
--without-x11
--without-gpm
"

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
		AC_PROG_CXX
		AC_OUTPUT
	EOF
	touch install-sh
	cp "$TERMUX_SCRIPTDIR/scripts/config.sub" ./
	cp "$TERMUX_SCRIPTDIR/scripts/config.guess" ./
	autoreconf -fi
	./configure --host=$TERMUX_HOST_PLATFORM
	popd
	export LIBTOOL=$libtooldir/libtool

	CXXFLAGS+=" $CPPFLAGS"
}
