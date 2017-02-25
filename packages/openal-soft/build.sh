TERMUX_PKG_HOMEPAGE=http://kcat.strangesoft.net/openal.html
TERMUX_PKG_DESCRIPTION="Software implementation of the OpenAL API"
TERMUX_PKG_VERSION=1.17.2
TERMUX_PKG_SRCURL=https://github.com/kcat/openal-soft/archive/08948079e93cbb7321be5715df36f54c5e6be3b7.zip
TERMUX_PKG_REVISION=1
#TERMUX_PKG_SRCURL=http://kcat.strangesoft.net/openal-releases/openal-soft-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=fe3183fd77662b92f7329434c0c9ad97500cb8125f64ee792fb706fe82734dc6
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_USE_SYSTEM_LIBRARIES=True"
#TERMUX_PKG_SHA256=a341f8542f1f0b8c65241a17da13d073f18ec06658e1a1606a8ecc8bbc2b3314
TERMUX_PKG_FOLDERNAME=openal-soft-08948079e93cbb7321be5715df36f54c5e6be3b7
termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/libexec	
	local SYSTEM_LIBFOLDER=lib64
        if [ $TERMUX_ARCH_BITS = 32 ]; then SYSTEM_LIBFOLDER=lib; fi

	mv $TERMUX_PREFIX/bin/openal-info $TERMUX_PREFIX/libexec/openal-info
	mv $TERMUX_PREFIX/bin/altonegen $TERMUX_PREFIX/libexec/altonegen
	echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIBFOLDER:$TERMUX_PREFIX/lib $TERMUX_PREFIX/libexec/openal-info \"\$@\"" >> $TERMUX_PREFIX/bin/openal-info
	echo "LD_LIBRARY_PATH=/system/$SYSTEM_LIBFOLDER:$TERMUX_PREFIX/lib $TERMUX_PREFIX/libexec/altonegen \"\$@\"" >> $TERMUX_PREFIX/bin/altonegen
	chmod +x $TERMUX_PREFIX/bin/openal-info
	chmod +x $TERMUX_PREFIX/bin/altonegen

}
