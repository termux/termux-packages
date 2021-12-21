TERMUX_PKG_HOMEPAGE=https://github.com/tizonia/
TERMUX_PKG_DESCRIPTION="A command-line streaming music client/server for Linux"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.22.0
TERMUX_PKG_SRCURL=https://github.com/tizonia/tizonia-openmax-il/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0750cae23ed600fb4b4699a392f43a5e03dcd0870383d64da4b8c28ea94a82f8
TERMUX_PKG_DEPENDS="boost, dbus, libandroid-wordexp, libcurl, libflac, liblog4c, libmad, libmediainfo, libmp3lame, liboggz, libopus, libsndfile, libsqlite, libuuid, libvpx, mpg123, opusfile, pulseaudio, python, taglib"
TERMUX_PKG_BUILD_DEPENDS="libev"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	_PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD
	local srcdir="$TERMUX_PKG_SRCDIR"/3rdparty/dbus-cplusplus
	autoreconf -fi "$srcdir"
	"$srcdir"/configure --prefix=$_PREFIX_FOR_BUILD
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	install -Dm700 $TERMUX_PKG_BUILDER_DIR/exe_wrapper $_PREFIX_FOR_BUILD/bin/
	PATH=$_PREFIX_FOR_BUILD/bin:$PATH

	export BOOST_ROOT=$TERMUX_PREFIX
	LDFLAGS+=" -landroid-wordexp"

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
}

termux_step_configure_meson() {
	termux_setup_meson
	sed -i 's/^\(\[binaries\]\)$/\1\nexe_wrapper = '\'exe_wrapper\''/g' \
		$TERMUX_MESON_CROSSFILE
	CC=gcc CXX=g++ CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= $TERMUX_MESON \
		$TERMUX_PKG_SRCDIR \
		$TERMUX_PKG_BUILDDIR \
		--cross-file $TERMUX_MESON_CROSSFILE \
		--prefix $TERMUX_PREFIX \
		--libdir lib \
		--buildtype minsize \
		--strip \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
