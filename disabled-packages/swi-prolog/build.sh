TERMUX_PKG_HOMEPAGE=http://www.swi-prolog.org/
TERMUX_PKG_DESCRIPTION="Comprehensive free Prolog environment"
TERMUX_PKG_VERSION=7.3.6
TERMUX_PKG_SRCURL=http://www.swi-prolog.org/download/devel/src/swipl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="readline, libgmp"

termux_step_host_build() {
	cp -Rf $TERMUX_PKG_SRCDIR/* .

	# apt install libgmp-dev:i386 libncurses5-dev:i386
	./configure --host=i386-linux --disable-readline #--disable-gmp

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		# "Make sure that the native swipl has the same word-length (32/64 bits) 
		# and use the native swipl for creating the boot file"
		# https://groups.google.com/forum/#!topic/swi-prolog/8lBcjb9cxuk
		find . -name Makefile | xargs perl -p -i -e 's/CFLAGS=/CFLAGS=-m32 /'
		find . -name Makefile | xargs perl -p -i -e 's/LDFLAGS=/LDFLAGS=-m32 /'
	fi
	make 
}


termux_step_post_configure() {
	cp $TERMUX_PKG_HOSTBUILD_DIR/src/defatom src/
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/src/defatom
	#cp $TERMUX_PKG_HOSTBUILD_DIR/{defatom,swipl} $TERMUX_PKG_BUILDDIR/src/

	#bdir=/home/fornwall/termux/swi-prolog/src/src
	#PLARCH=arm-linux
	perl -p -i -e "s|bdir=|bdir=$TERMUX_PKG_HOSTBUILD_DIR/src/ # |" */swipl.sh
	perl -p -i -e "s|PLARCH=|PLARCH=i386-linux # |" */swipl.sh
	perl -p -i -e "s|${TERMUX_ARCH}-linux|i386-linux|" */swipl.sh
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/swipl-$TERMUX_PKG_VERSION/lib/${TERMUX_ARCH}-linux/libswipl.so* $TERMUX_PREFIX/lib/
}
