TERMUX_PKG_HOMEPAGE=https://www.polyml.org/
TERMUX_PKG_DESCRIPTION="A Standard ML implementation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.9.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/polyml/polyml/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=52f56a57a4f308f79446d479e744312195b298aa65181893bce2dfc023a3663c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libc++, libffi, libgmp"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-pic
--disable-native-codegeneration
"

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD

	local TERMUX_ORIG_PATH="$PATH"
	mkdir -p native
	pushd native
	export PATH="$(pwd):$TERMUX_ORIG_PATH"
	$TERMUX_PKG_SRCDIR/configure \
		CC="gcc -m${TERMUX_ARCH_BITS}" CXX="g++ -m${TERMUX_ARCH_BITS}" \
		--prefix=$_PREFIX_FOR_BUILD \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	sed -i -e 's/^\(#define HOSTARCHITECTURE\)_X32 1/\1_X86 1/g' config.h
	make -j $TERMUX_PKG_MAKE_PROCESSES
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
	export PATH="$_PREFIX_FOR_BUILD/bin:$TERMUX_ORIG_PATH"
	$TERMUX_PKG_SRCDIR/configure \
		CC="gcc -m${TERMUX_ARCH_BITS}" CXX="g++ -m${TERMUX_ARCH_BITS}" \
		--prefix=$(pwd) \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	sed -i -e '/^#define HOSTARCHITECTURE_/d' config.h
	echo >> config.h
	echo "#define HOSTARCHITECTURE_${arch} 1" >> config.h
	make -j $TERMUX_PKG_MAKE_PROCESSES -C libpolyml libpolyml.la
	make -j $TERMUX_PKG_MAKE_PROCESSES polyimport
	make -j $TERMUX_PKG_MAKE_PROCESSES -C libpolymain libpolymain.la
	make -j $TERMUX_PKG_MAKE_PROCESSES poly
	popd
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/cross:$PATH"
	_NEED_DUMMY_LIBSTDCXX_SO=
	_LIBSTDCXX_SO=$TERMUX_PREFIX/lib/libstdc++.so
	if [ ! -e $_LIBSTDCXX_SO ]; then
		_NEED_DUMMY_LIBSTDCXX_SO=true
		echo 'INPUT(-lc++_shared)' > $_LIBSTDCXX_SO
	fi

	LDFLAGS+=" -landroid-posix-semaphore"
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBSTDCXX_SO ]; then
		rm -f $_LIBSTDCXX_SO
	fi
}
