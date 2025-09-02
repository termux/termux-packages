TERMUX_PKG_HOMEPAGE=https://luajit.org/
TERMUX_PKG_DESCRIPTION="Just-In-Time Compiler for Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:2.1.1731601260"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/LuaJIT/LuaJIT.git
TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION:2:3}
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_BREAKS="libluajit-dev"
TERMUX_PKG_REPLACES="libluajit-dev"
TERMUX_PKG_EXTRA_MAKE_ARGS="amalg PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_LUAJIT_JIT_FOLDER_RELATIVE=share/luajit-${TERMUX_PKG_VERSION:2:3}/jit

termux_step_post_get_source() {
	# Do the same as e.g. arch linux is doing:
	# The patch version is the timestamp of the above git commit, obtain via `git show -s --format=%ct`
	local commit_ts=${TERMUX_PKG_VERSION:6}

	# Find the commit made at the exact timestamp specified in the version:
	local commit_hash=$(git log --date=unix --before=$commit_ts --after=$commit_ts --pretty=format:"%H")
	git checkout $commit_hash
}

termux_step_pre_configure() {
	# luajit wants same pointer size for host and target build
	export HOST_CC="gcc"
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		if [ $(uname) = "Linux" ]; then
			# NOTE: "apt install libc6-dev-i386" for 32-bit headers
			export HOST_CFLAGS="-m32"
			export HOST_LDFLAGS="-m32"
		elif [ $(uname) = "Darwin" ]; then
			export HOST_CFLAGS="-m32 -arch i386"
			export HOST_LDFLAGS="-arch i386"
		fi
	fi
	export TARGET_FLAGS="$CFLAGS $CPPFLAGS $LDFLAGS"
	export TARGET_SYS=Linux
	unset CFLAGS LDFLAGS
}

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/include/luajit-${TERMUX_PKG_VERSION:2:3}/
	cp -f $TERMUX_PKG_SRCDIR/src/{lauxlib.h,lua.h,lua.hpp,luaconf.h,luajit.h,lualib.h} $TERMUX_PREFIX/include/luajit-${TERMUX_PKG_VERSION:2:3}/
	rm -f $TERMUX_PREFIX/lib/libluajit*

	install -Dm600 $TERMUX_PKG_SRCDIR/src/libluajit.so $TERMUX_PREFIX/lib/libluajit-5.1.so.2.1.0
	install -Dm600 $TERMUX_PKG_SRCDIR/src/libluajit.a $TERMUX_PREFIX/lib/libluajit-5.1.a
	(cd $TERMUX_PREFIX/lib;
		ln -s -f libluajit-5.1.so.2.1.0 libluajit.so;
		ln -s -f libluajit-5.1.so.2.1.0 libluajit-5.1.so;
		ln -s -f libluajit-5.1.so.2.1.0 libluajit-5.1.so.2;
		ln -s -f libluajit-5.1.a libluajit.a;)

	install -Dm600 $TERMUX_PKG_SRCDIR/etc/luajit.1 $TERMUX_PREFIX/share/man/man1/luajit.1
	install -Dm600 $TERMUX_PKG_SRCDIR/etc/luajit.pc $TERMUX_PREFIX/lib/pkgconfig/luajit.pc
	install -Dm700 $TERMUX_PKG_SRCDIR/src/luajit $TERMUX_PREFIX/bin/luajit

	# Files needed for the -b option (http://luajit.org/running.html) to work.
	# Note that they end up in the 'luajit' subpackage, not the 'libluajit' one.
	local TERMUX_LUAJIT_JIT_FOLDER=$TERMUX_PREFIX/$TERMUX_LUAJIT_JIT_FOLDER_RELATIVE
	rm -Rf $TERMUX_LUAJIT_JIT_FOLDER
	mkdir -p $TERMUX_LUAJIT_JIT_FOLDER
	cp $TERMUX_PKG_SRCDIR/src/jit/*lua $TERMUX_LUAJIT_JIT_FOLDER
}
