TERMUX_PKG_HOMEPAGE=https://perf.wiki.kernel.org/index.php/Main_Page
TERMUX_PKG_DESCRIPTION="Performance analysis tools for Linux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@harieamjari"
# Android Linux kernel version `uname -r`
TERMUX_PKG_VERSION=4.4
#TERMUX_PKG_SRCURL=https://github.com/torvalds/linux/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://android.googlesource.com/kernel/common/+archive/android-trusty-${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SHA256=5b8fc6519a737a5c809171e08225f050bf794f1f369c4c387ed3c8a89b1e995b
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_DEPENDS="zlib, liblzma, libelf"
TERMUX_PKG_BUILD_DEPENDS="bison, flex"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
#TERMUX_PKG_HOSTBUILD=true

#termux_step_get_source() {
#	mkdir $TERMUX_PKG_SRCDIR
#	termux_download $TERMUX_PKG_SRCURL \
#		$TERMUX_PKG_CACHEDIR/kernel-${TERMUX_PKG_VERSION}.tar.gz \
#		$TERMUX_PKG_SHA256
#	tar --gzip -xf $TERMUX_PKG_CACHECDIR/kernel-${TERMUX_PKG_VERSION}.tar.gz \
#		-C $TERMUX_PKG_SRCDIR
#}

termux_step_post_get_source() {
	rm -rf $TERMUX_PKG_SRCDIR/*
	local file="$TERMUX_PKG_CACHEDIR/$(basename $TERMUX_PKG_SRCURL)"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR"
}

termux_step_make() {
	PERF_LDEMULATION=foo
	local _PERF_ARCH=
	if [ $TERMUX_ARCH = "arm" ]; then
		CC="$TERMUX_ARCH-linux-androideabi-clang"
		CXX="$TERMUX_ARCH-linux-androideabi-clang++"
		_PERF_ARCH=arm
		#FIXME set correct target emulation for arm
		PERF_LDEMULATION=armelf
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		CC="$TERMUX_ARCH-linux-android-clang"
		CXX="$TERMUX_ARCH-linux-android-clang++"
		_PERF_ARCH=arm64
		PERF_LDEMULATION=aarch64linux
	elif [ $TERMUX_ARCH = "i686" ]; then
		CC="$TERMUX_ARCH-linux-android-clang"
		CXX="$TERMUX_ARCH-linux-android-clang++"
		_PERF_ARCH=x86
		#FIXME set correct target emulation for i686
		PERF_LDEMULATION=elf_i386
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		CC="$TERMUX_ARCH-linux-android-clang"
		CXX="$TERMUX_ARCH-linux-android-clang++"
		_PERF_ARCH=x86
		#FIXME set correct target emulation for x86_64
		PERF_LDEMULATION=elf_x86_64
	else
		termux_error_exit "invalid architecture ${TERMUX_ARCH}"
	fi

	pushd $TERMUX_PKG_SRCDIR

#	CFLAGS=" -isysroot=${TERMUX_PREFIX}/../files"
	local _PERF_EXTRA_CFLAGS=" --verbose"
	_PERF_EXTRA_CFLAGS+=" -Wno-implicit-function-declaration"
	_PERF_EXTRA_CFLAGS+=" -Wno-int-conversion"
	_PERF_EXTRA_CFLAGS+=" -Wno-implicit-int"
	_PERF_EXTRA_CFLAGS+=" -Wno-format"
#	_PERF_EXTRA_CFLAGS+=" -I${TERMUX_PREFIX}/include"
	LDFLAGS+=" -L${TERMUX_PREFIX}/lib"

	sed -i -e 's/ -Wstrict-aliasing=[0-9]*//g' \
		$TERMUX_PKG_SRCDIR/tools/scripts/Makefile.include
	sed -i -e 's/ -Werror//g' \
		$TERMUX_PKG_SRCDIR/tools/{build/feature/Makefile,perf/{Makefile.perf,config/Makefile}}

#	make defconfig \
#		PREFIX=$TERMUX_PREFIX \
#		HOSTCC=/usr/bin/gcc \
#		HOSTCXX=/usr/bin/g++ \
#		ARCH=$_PERF_ARCH \
#		EXTRA_CFLAGS="$CFLAGS" \
#		BIONIC=1 \
#		LLVM=1
#
#	cat <<- EOL > feature_dump.txt
#	feature-backtrace=0
#	feature-dwarf=0
#	feature-dwarf_getlocations=0
#	feature-fortify-source=0
#	feature-sync-compare-and-swap=0
#	feature-glibc=0
#	feature-gtk2=0
#	feature-gtk2-infobar=0
#	feature-libaudit=0
#	feature-libbfd=0
#	feature-libelf=1
#	feature-libelf-getphdrnum=0
#	feature-libelf-gelf_getnote=0
#	feature-libelf-getshdrstrndx=0
#	feature-libelf-mmap=0
#	feature-libnuma=0
#	feature-numa_num_possible_cpus=0
#	feature-libperl=0
#	feature-libpython=0
#	feature-libpython-version=0
#	feature-libslang=0
#	feature-libcrypto=0
#	feature-libunwind=0
#	feature-libunwind-x86=0
#	feature-libunwind-x86_64=0
#	feature-libunwind-arm=0
#	feature-libunwind-aarch64=0
#	feature-pthread-attr-setaffinity-np=0
#	feature-stackprotector-all=0
#	feature-timerfd=0
#	feature-libdw-dwarf-unwind=0
#	feature-zlib=1
#	feature-lzma=1
#	feature-get_cpuid=0
#	feature-bpf=0
#	feature-sdt=0
#	EOL
#		FEATURE_DUMP="$TERMUX_PKG_SRCDIR/feature_dump.txt" \

	# Parallel build makes it harder to spot which command
	# produced which error so we're compiling with JOBS=1
	#
#	export CFLAGS
	export PERF_LDEMULATION
	export CC
	export CXX
	make -C ./tools/perf \
		prefix="$TERMUX_PREFIX" \
		CC="$CC" \
		CXX="$CXX" \
		HOSTCC="clang" \
		HOSTCXX="clang++" \
		HOSTLD=ld \
		CROSS_COMPILE=" " \
		ARCH=$_PERF_ARCH  \
		EXTRA_CFLAGS="$_PERF_EXTRA_CFLAGS" \
		LDFLAGS="$LDFLAGS" \
		JOBS=1 \
		WERROR=0 \
		BIONIC=1 \
		LLVM=1 \
		V=1 \
		VF=1

	popd
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/tools/perf/perf $TERMUX_PREFIX/bin/perf
}
