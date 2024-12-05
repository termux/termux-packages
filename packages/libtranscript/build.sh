TERMUX_PKG_HOMEPAGE=https://os.ghalkes.nl/libtranscript.html
TERMUX_PKG_DESCRIPTION="A character-set conversion library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.4"
TERMUX_PKG_SRCURL=https://os.ghalkes.nl/dist/libtranscript-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=daaa09038f6f3b785b86d152014b3893910f9b9e4e430c015e41b05b34c37ea7
TERMUX_PKG_AUTO_UPDATE=true
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
