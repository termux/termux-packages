TERMUX_PKG_HOMEPAGE=https://luajit.org/
TERMUX_PKG_DESCRIPTION="Just-In-Time Compiler for Lua"
TERMUX_PKG_VERSION=2.1.0~beta2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://luajit.org/download/LuaJIT-2.1.0-beta2.tar.gz
TERMUX_PKG_EXTRA_MAKE_ARGS="amalg PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFLICTS="lua,lua-dev"
TERMUX_PKG_REPLACES="lua,lua-dev"

termux_step_pre_configure() {
	# luajit wants same pointer size for host and target build
	export HOST_CC="gcc"
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		if [ `uname` = "Linux" ]; then
			# NOTE: "apt install libc6-dev-i386" for 32-bit headers
			export HOST_CFLAGS="-m32" # -arch i386"
			export HOST_LDFLAGS="-m32" # arch i386"
		elif [ `uname` = "Darwin" ]; then
			export HOST_CFLAGS="-m32 -arch i386"
			export HOST_LDFLAGS="-arch i386"
		fi
	fi
	export CROSS=${TERMUX_HOST_PLATFORM}-
	export TARGET_FLAGS="$CFLAGS $CPPFLAGS $LDFLAGS"
	export TARGET_SYS=Linux

	ORIG_STRIP=$STRIP
	unset AR AS CC CXX CPP CPPFLAGS CFLAGS CXXFLAGS LDFLAGS RANLIB LD PKG_CONFIG STRIP
}

termux_step_make_install () {
	cp $TERMUX_PKG_SRCDIR/src/{lauxlib.h,lua.h,lua.hpp,luaconf.h,luajit.h,lualib.h} $TERMUX_PREFIX/include/
	rm -f $TERMUX_PREFIX/lib/libluajit*
	cp $TERMUX_PKG_SRCDIR/src/libluajit.so $TERMUX_PREFIX/lib/libluajit-5.1.so
	(cd $TERMUX_PREFIX/include; ln -s -f libluajit-5.1.so libluajit.so; ln -s -f libluajit-5.1.so liblua.so)

	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/etc/luajit.1 $TERMUX_PREFIX/share/man/man1/
	(cd $TERMUX_PREFIX/share/man/man1/; ln -s -f luajit.1 lua.1)

	cp $TERMUX_PKG_SRCDIR/etc/luajit.pc $TERMUX_PREFIX/lib/pkgconfig/
	(cd $TERMUX_PREFIX/lib/pkgconfig; ln -s -f luajit.pc lua.pc)

	rm -f $TERMUX_PREFIX/bin/luajit
	cp $TERMUX_PKG_SRCDIR/src/luajit $TERMUX_PREFIX/bin/luajit
	(cd $TERMUX_PREFIX/bin; ln -s -f luajit lua)

	# Files needed for the -b option (http://luajit.org/running.html) to work.
	# Note that they end up in the 'luajit' subpackage, not the 'libluajit' one.
	TERMUX_LUAJIT_JIT_FOLDER_RELATIVE=share/luajit-$TERMUX_PKG_VERSION/jit
	local TERMUX_LUAJIT_JIT_FOLDER=$TERMUX_PREFIX/$TERMUX_LUAJIT_JIT_FOLDER_RELATIVE
	rm -Rf $TERMUX_LUAJIT_JIT_FOLDER
	mkdir -p $TERMUX_LUAJIT_JIT_FOLDER
	cp $TERMUX_PKG_SRCDIR/src/jit/*lua $TERMUX_LUAJIT_JIT_FOLDER

	STRIP=$ORIG_STRIP
}
