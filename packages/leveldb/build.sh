TERMUX_PKG_HOMEPAGE=https://github.com/google/leveldb
TERMUX_PKG_DESCRIPTION="Fast key-value storage library"
TERMUX_PKG_VERSION=1.20
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=f5abe8b5b209c2f36560b75f32ce61412f39a2922f7045ae764a2c23335b6664
TERMUX_PKG_SRCURL=https://github.com/google/leveldb/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install() {
	rm -Rf $TERMUX_PREFIX/include/leveldb/
	cp -Rf include/leveldb/ $TERMUX_PREFIX/include/
	cp out-shared/libleveldb.so.$TERMUX_PKG_VERSION $TERMUX_PREFIX/lib/
	( cd $TERMUX_PREFIX/lib/ && \
	  ln -s -f libleveldb.so.$TERMUX_PKG_VERSION libleveldb.so && \
	  ln -s -f libleveldb.so.$TERMUX_PKG_VERSION libleveldb.so.1 )
}
