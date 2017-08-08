# status: Does not build
TERMUX_PKG_HOMEPAGE=https://nodejs.org/
TERMUX_PKG_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
TERMUX_PKG_VERSION=8.2.1
TERMUX_PKG_SRCURL=https://nodejs.org/dist/v${TERMUX_PKG_VERSION}/node-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=66fe1379bc7daf9a16c6b5c45ab695bf1cdcfae9738d2989e940104d6b31973f
# Note that we do not use a shared libuv to avoid an issue with the Android
# linker, which does not use symbols of linked shared libraries when resolving
# symbols on dlopen(). See https://github.com/termux/termux-packages/issues/462.
TERMUX_PKG_DEPENDS="openssl, c-ares"
TERMUX_PKG_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFLICTS="nodejs"

termux_step_configure () {
	# !!! install the termux module
	cp $TERMUX_PKG_BUILDER_DIR/termux.js ./lib/termux.js

	# See https://github.com/nodejs/build/issues/266 about enabling snapshots
	# when cross compiling. We use {CC,CXX}_host for compilation of code to
	# be run on the build maching (snapshots when cross compiling are
	# generated using a CPU emulator provided by v8) and {CC,CXX} for the
	# cross compile. We unset flags such as CFLAGS as they would affect
	# both the host and cross compiled build.
	# Remaining issue to be solved before enabling snapshots by removing
	# the --without-snapshot flag is that pkg-config picks up cross compilation
	# flags which breaks the host build.
	# to build this in docker requires installing libc-ares-dev and libssl-dev 
	# arm is a tad more complicated. 
	# arm needs i386 tool chain. so for docker image we need.
	# sudo dpkg --add-architecture i386
	# sudo apt update
	# sudo apt-get install libstdc++-6-dev:i386 zlib1g-dev:i386 libc-ares-dev:i386 libssl-dev:i386 libunwind-dev:i386	
	# it also tries to use same c++ library. so to get around that
	# sudo ln -s /usr/lib/i386-linux-gnu/libstdc++.so.6 /usr/lib/i386-linux-gnu/libc++_shared.so
	# to get i686 and x86_64 to work requires removing the flags that make android compiler link with local libs

	mkdir -p $TERMUX_PKG_TMPDIR/bin
	echo "#!/bin/bash" > $TERMUX_PKG_TMPDIR/bin/g++
	echo "echo \"\$@\" |  sed 's',\"-I/data/data/com.termux/files/usr/include\",\" \",'g' |  sed 's',\"-L/data/data/com.termux/files/usr/lib\",\" \",'g' |  xargs -L 1 /usr/bin/g++" >> $TERMUX_PKG_TMPDIR/bin/g++
	echo "#!/bin/bash" > $TERMUX_PKG_TMPDIR/bin/gcc
	echo "echo \"\$@\" |  sed 's',\"-I/data/data/com.termux/files/usr/include\",\" \",'g' |  sed 's',\"-L/data/data/com.termux/files/usr/lib\",\" \",'g' |  xargs -L 1 /usr/bin/gcc" >> $TERMUX_PKG_TMPDIR/bin/gcc
	PATH=$TERMUX_PKG_TMPDIR/bin:$PATH
	chmod +x $TERMUX_PKG_TMPDIR/bin/*

	export CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS"
        export CXX="$CXX $CXXFLAGS $CPPFLAGS $LDFLAGS"
	export CC_host="gcc -pthread -L/usr/lib/x86_64-linux-gnu"
	export CXX_host="g++ -pthread -L/usr/lib/x86_64-linux-gnu"
	if [ $TERMUX_ARCH = "arm" ] || [ $TERMUX_ARCH = "i686" ]; then
		export CC_host="gcc -pthread -L/usr/lib/i386-linux-gnu"
		export CXX_host="g++ -pthread -L/usr/lib/i386-linux-gnu"
	fi
	export CFLAGS="-Os"
        export CXXFLAGS="-Os"
	unset CPPFLAGS LDFLAGS


	if [ $TERMUX_ARCH = "arm" ]; then
		DEST_CPU="arm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		DEST_CPU="ia32"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		DEST_CPU="arm64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		DEST_CPU="x64"
	else
		termux_error_exit "Unsupported arch '$TERMUX_ARCH'"
	fi

	export GYP_DEFINES="host_os=linux"

	# See note above TERMUX_PKG_DEPENDS why we do not use a shared libuv.
	./configure \
		--prefix=$TERMUX_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-cares \
		--shared-openssl \
		--shared-zlib \
		--without-inspector \
		--without-intl \
		--cross-compiling
}
