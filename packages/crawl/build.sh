TERMUX_PKG_HOMEPAGE=https://crawl.develz.org/
TERMUX_PKG_DESCRIPTION="Roguelike adventure through dungeons filled with dangerous monsters"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.34.0"
TERMUX_PKG_SRCURL="https://github.com/crawl/crawl/releases/download/$TERMUX_PKG_VERSION/stone_soup-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=b9bc4d2866534625146fa1887f2ac06547b62e4a71dc78ed8f3a7b5d7f011cd7
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
	pushd source
	local f
	for f in initfile.cc main.cc startup.cc syscalls.cc; do
		sed -i 's|\(__ANDROID_\)_|\1_NO_TERMUX__|g' "${f}"
	done
	popd
}

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/source"
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR

	export DEFINES_L="-DHAVE_STAT"
	export LIBS="-llog -Wl,--rpath=$TERMUX_PREFIX/lib"
}
