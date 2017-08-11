TERMUX_PKG_HOMEPAGE=http://developer.android.com/tools/help/index.html
TERMUX_PKG_DESCRIPTION="Command which takes in class files and reformulates them for usage on Android"
TERMUX_PKG_VERSION=$TERMUX_ANDROID_BUILD_TOOLS_VERSION
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/share/dex
	$TERMUX_DX --dex \
		--output $TERMUX_PREFIX/share/dex/dx.dex \
		$ANDROID_HOME/build-tools/${TERMUX_PKG_VERSION}/lib/dx.jar

	install $TERMUX_PKG_BUILDER_DIR/dx $TERMUX_PREFIX/bin/dx
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/dx
}
