TERMUX_PKG_HOMEPAGE=https://bitcoincore.org/ 
TERMUX_PKG_DESCRIPTION="Bitcoin Core" 
TERMUX_PKG_LICENSE="MIT" 
TERMUX_PKG_VERSION=0.18.1 
TERMUX_PKG_SRCURL=https://github.com/bitcoin/bitcoin/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=db3c76ac913adfd67e3c7ff243b443c9706f81dd382d1212875fefc2de1ea5ff 
TERMUX_PKG_DEPENDS="libevent,libzmq,boost,termux-services"
TERMUX_PKG_BUILD_DEPENDS="pkg-config,util-linux"
TERMUX_PKG_BUILD_IN_SRC=1
TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR

termux_step_patch_package() {
    patch -p1 < $TERMUX_PKG_BUILDER_DIR/0001-android-patches.patch
    #beware, this patch contains a hard-coded path
}

termux_step_pre_configure() {
    (cd depends && make HOST=$TERMUX_HOST_PLATFORM NO_QT=1 -j $TERMUX_MAKE_PROCESSES)
    cd $TERMUX_PKG_SRCDIR
    ./autogen.sh
}

termux_step_configure() {
    ./configure PATH=$PATH:$TERMUX_PREFIX/bin --disable-dependency-tracking  --disable-rpath --disable-rpath-hack --host=$TERMUX_HOST_PLATFORM --prefix=/home/builder/.termux-build/bitcoin/src/depends/$TERMUX_HOST_PLATFORM  ac_cv_c_bigendian=no ac_cv_sys_file_offset_bits=$TERMUX_ARCH_BITS --disable-bench --enable-experimental-asm --disable-test --disable-man --without-libs --with-daemon --disable-maintainer-mode --disable-glibc-back-compat --disable-nls --enable-shared --enable-static --libexecdir=$TERMUX_PREFIX/libexec --bindir=$TERMUX_PREFIX/bin
  }

termux_step_post_make_install() {
    mkdir -p $TERMUX_PREFIX/var/service 
    cd $TERMUX_PREFIX/var/service             
    mkdir -p bitcoind/log                    
    echo "#!$TERMUX_PREFIX/bin/sh" > bitcoind/run         
    echo 'exec bitcoind 2>&1' >> bitcoind/run
    chmod +x bitcoind/run
    touch bitcoind/down
    
    ln -sf $TERMUX_PREFIX/share/termux-services/svlogger bitcoind/log/run          
}
