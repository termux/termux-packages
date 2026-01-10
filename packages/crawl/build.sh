TERMUX_PKG_HOMEPAGE=https://crawl.develz.org/
TERMUX_PKG_DESCRIPTION="Roguelike adventure through dungeons filled with dangerous monsters"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.33.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/crawl/crawl/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c9b998dc7d3247c3ac68be6ac81fa8c2e743a232a7bbd6b1aff3011478e7e3d9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, lua51, libsqlite, ncurses, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
FHS=yes
--debug
"

termux_step_post_get_source() {
	echo "Applying util-gen_ver.pl.diff"
	sed "s|@VERSION@|${TERMUX_PKG_VERSION#*:}|g" \
		$TERMUX_PKG_BUILDER_DIR/util-gen_ver.pl.diff \
		| patch --silent -p1
	pushd crawl-ref/source
	local f
	for f in initfile.cc main.cc startup.cc syscalls.cc; do
		sed -i 's|\(__ANDROID_\)_|\1_NO_TERMUX__|g' "${f}"
	done
	popd
}

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/crawl-ref/source"
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR

	export DEFINES_L="-DHAVE_STAT"
	export LIBS="-llog -Wl,--rpath=$TERMUX_PREFIX/lib"
}
