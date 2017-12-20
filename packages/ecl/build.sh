TERMUX_PKG_HOMEPAGE=https://common-lisp.net/project/ecl
TERMUX_PKG_DESCRIPTION="Embeddable Common-Lisp"
TERMUX_PKG_VERSION=16.1.3
TERMUX_PKG_SRCURL=https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_SHA256=76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --enable-gengc=yes --enable-boehm=system  --enable-libatomic=system --enable-gmp=system  --with-libffi-prefix=$TERMUX_PREFIX --with-unicode=32"
TERMUX_PKG_DEPENDS="libffi-dev, libgc-dev, libgmp-dev, clang, libandroid-support"
TERMUX_PKG_NO_DEVELSPLIT="true"
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS=" --enable-boehm=system  --without-backtrace --enable-libatomic=system  --enable-gmp=system --with-unicode=32"
# for 32 bit archs
# sudo dpkg --add-architecture i386
# sudo apt update
# apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 libgmp-dev
#_libgcCOMMIT=ebc872b55629efb4be570aec8f89c323b567a2e9   
#libgc_PKG_SRCURL=https://github.com/ivmai/bdwgc/archive/${_libgcCOMMIT}.zip 
termux_step_handle_hostbuild () {
if [ "$TERMUX_ARCH_BITS" = "32" ]; then
  	termux_setup_libgc32bit
	rm $TERMUX_PKG_HOSTBUILD_DIR -rf
	TERMUX_32ECL_MARK=$TERMUX_COMMON_CACHEDIR32/ecl-$TERMUX_PKG_VERSION
	if [ ! -f $TERMUX_32ECL_MARK ]; then
		mkdir $TERMUX_PKG_HOSTBUILD_DIR
		cd $TERMUX_PKG_HOSTBUILD_DIR

		cp ../src/* -rf .
		patch -p1 < $TERMUX_PKG_BUILDER_DIR/src-configure.patch 
		CC=" gcc -m32 $LDFLAGS"  CFLAGS=" -m32" CXXFLAGS=" -m32"	./configure $TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS --prefix=$TERMUX_COMMON_CACHEDIR32
		make -j $TERMUX_MAKE_PROCESSES
		make install
		touch $TERMUX_COMMON_CACHEDIR32/ecl-$TERMUX_PKG_VERSION
	fi
else
	TERMUX_ECL_MARK=$TERMUX_COMMON_CACHEDIR/ecl-$TERMUX_PKG_VERSION/ECL_HOSTBUILD_$TERMUX_PKG_VERSION

	if [ ! -f $TERMUX_ECL_MARK ]; then 
		mkdir -p $TERMUX_PKG_HOSTBUILD_DIR
		cd $TERMUX_PKG_HOSTBUILD_DIR
		cp ../src/* -rf .
		./configure --prefix=$TERMUX_COMMON_CACHEDIR/ecl-$TERMUX_PKG_VERSION
		make -j $TERMUX_MAKE_PROCESSES
		make install 
		touch  $TERMUX_ECL_MARK
	fi
fi

}
termux_step_pre_configure() {
	rm $TERMUX_PREFIX/include/ecl -rf
	cd src
	cp $TERMUX_SCRIPTDIR/scripts/config.sub .
	cp $TERMUX_SCRIPTDIR/scripts/config.guess .
	cd ..

	if [ "$TERMUX_ARCH_BITS" = "32" ]; then
		ECL_TO_RUN=$TERMUX_COMMON_CACHEDIR32/bin/ecl
		sed "s%\@ECL_TO_RUN\@%${ECL_TO_RUN}%g" $TERMUX_PKG_BUILDER_DIR/cross_config32  > $TERMUX_PKG_TMPDIR/cross_config
		export PATH=$TERMUX_COMMON_CACHEDIR32/bin:$TERMUX_COMMON_CACHEDIR32/lib/ecl-$TERMUX_PKG_VERSION/lib:$PATH
		export LD_LIBRARY_PATH=$TERMUX_COMMON_CACHEDIR32/lib
	else
		ECL_TO_RUN=$TERMUX_COMMON_CACHEDIR/ecl-$TERMUX_PKG_VERSION/bin/ecl
		sed "s%\@ECL_TO_RUN\@%${ECL_TO_RUN}%g" $TERMUX_PKG_BUILDER_DIR/cross_config > $TERMUX_PKG_TMPDIR/cross_config
		export PATH=$TERMUX_COMMON_CACHEDIR/ecl-$TERMUX_PKG_VERSION/bin:$TERMUX_COMMON_CACHEDIR/ecl-$TERMUX_PKG_VERSION/lib/ecl-$TERMUX_PKG_VERSION:$PATH
		export LD_LIBRARY_PATH=$TERMUX_COMMON_CACHEDIR/ecl-$TERMUX_PKG_VERSION/lib
	fi
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-cross-config=$TERMUX_PKG_TMPDIR/cross_config"
}
termux_step_host_build () {
	cp ../src/* -rf ./
	./configure 
	        make -j $TERMUX_MAKE_PROCESSES
	}

