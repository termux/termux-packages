TERMUX_PKG_HOMEPAGE=https://nim-lang.org/
TERMUX_PKG_DESCRIPTION="Nim programming language compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="copying.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SRCURL=https://nim-lang.org/download/nim-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=03a47583777dd81380a3407aa6a788c9aa8a67df4821025770c9ac4186291161
TERMUX_PKG_DEPENDS="clang, git, libandroid-glob"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_host_build() {
	cp -r ../src/* ./
	make -j $TERMUX_MAKE_PROCESSES CC=gcc LD=gcc
}

termux_step_make() {
	if [ $TERMUX_ARCH = "x86_64" ]; then
		export	NIM_ARCH=amd64
	elif [ $TERMUX_ARCH = "i686" ]; then
		export	NIM_ARCH=i386
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		export NIM_ARCH=arm64
	else
		export NIM_ARCH=arm
	fi
	LDFLAGS+=" -landroid-glob"
	sed -i "s%\@CC\@%${CC}%g"  config/nim.cfg
	sed -i "s%\@CFLAGS\@%${CFLAGS}%g" config/nim.cfg
	sed -i "s%\@LDFLAGS\@%${LDFLAGS}%g" config/nim.cfg
	sed -i "s%\@CPPFLAGS\@%${CPPFLAGS}%g" config/nim.cfg

	find -name "stdlib_osproc.nim.c" | xargs -n 1 sed -i 's',"/system/bin/sh\"\,\ 14","${TERMUX_PREFIX}/bin/sh\"\,\ 38",'g'
	PATH=$TERMUX_PKG_HOSTBUILD_DIR/bin:$PATH

	if [ $NIM_ARCH = "amd64" ]; then
		sed -i 's/arm64/amd64/g' makefile
	fi
	export CFLAGS=" $CPPFLAGS $CFLAGS  -w  -fno-strict-aliasing"
	make LD=$CC uos=linux mycpu=$NIM_ARCH myos=android  -j $TERMUX_MAKE_PROCESSES useShPath=$TERMUX_PREFIX/bin/sh
	cp config/nim.cfg ../host-build/config

	nim --cc:clang --clang.exe=$CC --clang.linkerexe=$CC --opt:size --define:termux -d:release --os:android --cpu:$NIM_ARCH  -t:"$CPPFLAGS $CFLAGS" -l:"$LDFLAGS -landroid-glob" c koch.nim
	cd dist/nimble/src
	nim --cc:clang --clang.exe=$CC --clang.linkerexe=$CC --define:termux -d:release --os:android --cpu:$NIM_ARCH  -t:"$CPPFLAGS $CFLAGS" -l:"$LDFLAGS -landroid-glob" c nimble.nim
}

termux_step_make_install() {
	./install.sh $TERMUX_PREFIX/lib
	cp koch $TERMUX_PREFIX/lib/nim/bin/
	cp dist/nimble/src/nimble $TERMUX_PREFIX/lib/nim/bin/
	ln -sfr $TERMUX_PREFIX/lib/nim/bin/nim $TERMUX_PREFIX/bin/
	ln -sfr $TERMUX_PREFIX/lib/nim/bin/koch $TERMUX_PREFIX/bin/
	ln -sfr $TERMUX_PREFIX/lib/nim/bin/nimble $TERMUX_PREFIX/bin/
}
