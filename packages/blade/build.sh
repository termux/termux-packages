TERMUX_PKG_HOMEPAGE=https://bladelang.com/
TERMUX_PKG_DESCRIPTION="A simple, fast, clean and dynamic language"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.87"
TERMUX_PKG_SRCURL=https://github.com/blade-lang/blade/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a438f126eed74077d6112b89c9d890a8cc0a3affbccde0b023ad43639fed4de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="libgd, libcurl, openssl"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	sed -i '/add_subdirectory(imagine)/d' $TERMUX_PKG_SRCDIR/packages/CMakeLists.txt
	termux_setup_cmake
	cmake $TERMUX_PKG_SRCDIR
	make -j $TERMUX_PKG_MAKE_PROCESSES
	echo "add_subdirectory(imagine)" >> $TERMUX_PKG_SRCDIR/packages/CMakeLists.txt
}

termux_step_pre_configure() {
	PATH=$TERMUX_PKG_HOSTBUILD_DIR/blade:$PATH
	export LD_LIBRARY_PATH=$TERMUX_PKG_HOSTBUILD_DIR/blade
}

termux_step_make_install() {
	pushd blade
	install -Dm700 -t $TERMUX_PREFIX/bin blade
	install -Dm600 -t $TERMUX_PREFIX/lib libblade.so
	local sharedir=$TERMUX_PREFIX/share/blade
	mkdir -p $sharedir
	cp -r $TERMUX_PKG_SRCDIR/benchmarks $TERMUX_PKG_BUILDDIR/blade/includes $TERMUX_PKG_SRCDIR/libs $TERMUX_PKG_SRCDIR/tests $sharedir/
	popd
}
