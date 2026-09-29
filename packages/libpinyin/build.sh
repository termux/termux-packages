TERMUX_PKG_HOMEPAGE=https://github.com/libpinyin/libpinyin
TERMUX_PKG_DESCRIPTION="Library to deal with pinyin."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.10.3
TERMUX_PKG_SRCURL=https://github.com/libpinyin/libpinyin/releases/download/$TERMUX_PKG_VERSION/libpinyin-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3fe786ff2c2059bdbdf9d8d752db691a516a941a977521955fe0af3f0b4db299
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="glib, libdb"
TERMUX_PKG_HOSTBUILD=true


_load_ubuntu_packages() {
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	termux_download_ubuntu_packages libdb-dev libdb5.3-dev

	_load_ubuntu_packages

	# relocation R_X86_64_PC32 against symbol `stderr@@GLIBC_2.2.5'
	# can not be used when making a shared object
	rm -f "${HOSTBUILD_ROOTFS}"/usr/lib/x86_64-linux-gnu/*.a

	find "${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu" -xtype l \
		-exec sh -c "ln -snvf /usr/lib/x86_64-linux-gnu/\$(readlink \$1) \$1" sh {} \;

	export CPPFLAGS="-I${HOSTBUILD_ROOTFS}/usr/include"
	export LDFLAGS="-L${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"

	"$TERMUX_PKG_SRCDIR/configure" --prefix="${HOSTBUILD_ROOTFS}/usr"
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
	make install
}

termux_step_pre_configure() {
	autoreconf -fi

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		_load_ubuntu_packages
		local patch="$TERMUX_PKG_BUILDER_DIR/use-hostbuilt-binaries.diff"
		echo "Applying patch: $patch"
		test -f "$patch" && sed \
			-e "s%\@HOSTBUILD_ROOTFS\@%${HOSTBUILD_ROOTFS}%g" \
			"$patch" | patch --silent -p1
	fi

	# fix arm build and potentially other archs hidden bugs
	# ld.lld: error: non-exported symbol '__aeabi_idiv'
	# in '/home/builder/.termux-build/_cache/android-r29-api-24-v3/lib/clang/21
	# /lib/linux/libclang_rt.builtins-arm-android.a(divsi3.S.o)'
	# is referenced by DSO '../src/.libs/libpinyin.so'
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
