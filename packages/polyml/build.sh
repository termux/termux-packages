TERMUX_PKG_HOMEPAGE=https://www.polyml.org/
TERMUX_PKG_DESCRIPTION="A Standard ML implementation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.9
TERMUX_PKG_SRCURL=https://github.com/polyml/polyml/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5aa452a49f2ac0278668772af4ea0b9bf30c93457e60ff7f264c5aec2023c83e
TERMUX_PKG_DEPENDS="libc++, libffi, libgmp"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-pic
--disable-native-codegeneration
"

termux_step_host_build() {
	_PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD

	TERMUX_ORIG_PATH=$PATH
	mkdir -p native
	pushd native
	export PATH=$(pwd):$TERMUX_ORIG_PATH
	$TERMUX_PKG_SRCDIR/configure \
		CC="gcc -m${TERMUX_ARCH_BITS}" CXX="g++ -m${TERMUX_ARCH_BITS}" \
		--prefix=$_PREFIX_FOR_BUILD \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	sed -i -e 's/^\(#define HOSTARCHITECTURE\)_X32 1/\1_X86 1/g' config.h
	make -j $TERMUX_MAKE_PROCESSES
	make install
	popd

	local arch
	case "$TERMUX_ARCH" in
		aarch64 )
			arch=AARCH64 ;;
		arm )
			arch=ARM ;;
		x86_64 )
			arch=X86_64 ;;
		i686 )
			arch=X86 ;;
		* )
			echo "ERROR: Unknown architecture: $TERMUX_ARCH"
			return 1 ;;
	esac

	mkdir -p cross
	pushd cross
	export PATH=$_PREFIX_FOR_BUILD/bin:$TERMUX_ORIG_PATH
	$TERMUX_PKG_SRCDIR/configure \
		CC="gcc -m${TERMUX_ARCH_BITS}" CXX="g++ -m${TERMUX_ARCH_BITS}" \
		--prefix=$(pwd) \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	sed -i -e '/^#define HOSTARCHITECTURE_/d' config.h
	echo >> config.h
	echo "#define HOSTARCHITECTURE_${arch} 1" >> config.h
	make -j $TERMUX_MAKE_PROCESSES -C libpolyml libpolyml.la
	make -j $TERMUX_MAKE_PROCESSES polyimport
	make -j $TERMUX_MAKE_PROCESSES -C libpolymain libpolymain.la
	make -j $TERMUX_MAKE_PROCESSES poly
	export PATH=$(pwd):$TERMUX_ORIG_PATH
	popd
}

termux_step_pre_configure() {
	_NEED_DUMMY_LIBSTDCXX_SO=
	_LIBSTDCXX_SO=$TERMUX_PREFIX/lib/libstdc++.so
	if [ ! -e $_LIBSTDCXX_SO ]; then
		_NEED_DUMMY_LIBSTDCXX_SO=true
		echo 'INPUT(-lc++_shared)' > $_LIBSTDCXX_SO
	fi
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBSTDCXX_SO ]; then
		rm -f $_LIBSTDCXX_SO
	fi
}
