TERMUX_PKG_HOMEPAGE=http://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html
TERMUX_PKG_DESCRIPTION="Java programming language compiler from (openjdk)"
TERMUX_PKG_VERSION=8u45
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_extract_package() {
	mkdir $TERMUX_PKG_SRCDIR
}

termux_step_make() {
	RAW_JAR=/usr/lib/jvm/java-7-openjdk-amd64/lib/tools.jar

	mkdir -p $TERMUX_PREFIX/share/dex
	$TERMUX_DX \
		--dex \
		--output=$TERMUX_PREFIX/share/dex/tools.jar \
		$RAW_JAR

	install $TERMUX_PKG_BUILDER_DIR/javac $TERMUX_PREFIX/bin/javac
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/javac
}
