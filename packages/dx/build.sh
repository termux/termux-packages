TERMUX_PKG_HOMEPAGE=http://developer.android.com/tools/help/index.html
TERMUX_PKG_DESCRIPTION="Command which takes in class files and reformulates them for usage on Android"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=$TERMUX_ANDROID_BUILD_TOOLS_VERSION
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	# Rewrite packages to avoid using com.android.* classes which may clash with
	# classes in the Android runtime on devices (see #1801):
	local JARJAR=$TERMUX_PKG_CACHEDIR/jarjar.jar
	local RULEFILE=$TERMUX_PKG_TMPDIR/jarjar-rule.txt
	local REWRITTEN_DX=$TERMUX_PKG_TMPDIR/dx-rewritten.jar
	termux_download \
		http://central.maven.org/maven2/com/googlecode/jarjar/jarjar/1.3/jarjar-1.3.jar \
		$JARJAR \
		4225c8ee1bf3079c4b07c76fe03c3e28809a22204db6249c9417efa4f804b3a7
	echo 'rule com.android.** dx.@1' > $RULEFILE
	java -jar $JARJAR process $RULEFILE \
		$ANDROID_HOME/build-tools/${TERMUX_PKG_VERSION}/lib/dx.jar \
		$REWRITTEN_DX

	# Dex the rewritten jar file:
	mkdir -p $TERMUX_PREFIX/share/dex
	$TERMUX_D8 \
		--release \
		--min-api 21 \
		--output $TERMUX_PKG_TMPDIR \
		$REWRITTEN_DX

	cd $TERMUX_PKG_TMPDIR
	jar cf dx.jar classes.dex
	mv dx.jar $TERMUX_PREFIX/share/dex/dx.jar

	install $TERMUX_PKG_BUILDER_DIR/dx $TERMUX_PREFIX/bin/dx
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/dx
}
