TERMUX_PKG_HOMEPAGE=http://kcat.strangesoft.net/openal.html
TERMUX_PKG_DESCRIPTION="Software implementation of the OpenAL API"
TERMUX_PKG_VERSION=1.17.2
TERMUX_PKG_REVISION=1
_COMMIT=d9d2e732284eef9b386e312b131757370625c3d3
TERMUX_PKG_SRCURL=https://github.com/kcat/openal-soft/archive/$_COMMIT.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_USE_SYSTEM_LIBRARIES=True"
TERMUX_PKG_SHA256=c654334d48a1e2074c5466eb369fa1252f6933a1df990272b2f7ef4d5c6266bd
TERMUX_PKG_FOLDERNAME=openal-soft-$_COMMIT
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
