TERMUX_PKG_HOMEPAGE=http://luajit.org/
TERMUX_PKG_DESCRIPTION="Just-In-Time Compiler for Lua"
TERMUX_PKG_VERSION=2.0.4
TERMUX_PKG_SRCURL=http://luajit.org/download/LuaJIT-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_MAKE_ARGS="amalg PREFIX=$TERMUX_PREFIX"
TERMUX_PKG_BUILD_IN_SRC=yes

# luajit wants same pointer size for host and target build
export HOST_CC="gcc"
if [ `uname` = "Linux" ]; then
        # NOTE: "apt install libc6-dev-i386" for 32-bit headers
        export HOST_CFLAGS="-m32" # -arch i386"
        export HOST_LDFLAGS="-m32" # arch i386"
elif [ `uname` = "Darwin" ]; then
        export HOST_CFLAGS="-m32 -arch i386"
        export HOST_LDFLAGS="-arch i386"
fi
export CROSS=${TERMUX_HOST_PLATFORM}-
export TARGET_FLAGS="$CFLAGS $CPPFLAGS $LDFLAGS"
export TARGET_SYS=Linux

ORIG_STRIP=$STRIP
unset AR AS CC CXX CPP CPPFLAGS CFLAGS CXXFLAGS LDFLAGS RANLIB LD PKG_CONFIG STRIP

termux_step_make_install () {
        mkdir -p $TERMUX_PREFIX/include/luajit-2.0
        cp $TERMUX_PKG_SRCDIR/src/{lauxlib.h,lua.h,lua.hpp,luaconf.h,luajit.h,lualib.h} $TERMUX_PREFIX/include/luajit-2.0/
        cp $TERMUX_PKG_SRCDIR/src/libluajit.so $TERMUX_PREFIX/lib/libluajit-5.1.so.2
        (cd $TERMUX_PREFIX/lib; rm -f libluajit-5.1.so; ln -s libluajit-5.1.so.2 libluajit-5.1.so)

        mkdir -p $TERMUX_PREFIX/share/man/man1/
        cp $TERMUX_PKG_SRCDIR/etc/luajit.1 $TERMUX_PREFIX/share/man/man1/

        cp $TERMUX_PKG_SRCDIR/etc/luajit.pc $TERMUX_PREFIX/lib/pkgconfig/
        perl -p -i -e "s|^prefix=.*|prefix=${TERMUX_PREFIX}|" $TERMUX_PREFIX/lib/pkgconfig/luajit.pc

        rm -f $TERMUX_PREFIX/bin/luajit
        cp $TERMUX_PKG_SRCDIR/src/luajit $TERMUX_PREFIX/bin/

        STRIP=$ORIG_STRIP
}
