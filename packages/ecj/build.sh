TERMUX_PKG_HOMEPAGE=http://www.eclipse.org/jdt/core/
TERMUX_PKG_DESCRIPTION="Eclipse Compiler for Java"
TERMUX_PKG_VERSION=4.5.2
TERMUX_PKG_SRCURL=http://ftp.acc.umu.se/mirror/eclipse.org/eclipse/downloads/drops4/R-${TERMUX_PKG_VERSION}-201602121500/ecj-${TERMUX_PKG_VERSION}.jar
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_extract_package () {
	mkdir $TERMUX_PKG_SRCDIR
}

termux_step_make () {
	RAW_JAR=$TERMUX_PKG_CACHEDIR/ecj-${TERMUX_PKG_VERSION}.jar
	if [ ! -f $RAW_JAR ]; then
		curl -L $TERMUX_PKG_SRCURL > $RAW_JAR
	fi

        mkdir -p $TERMUX_PREFIX/share/{dex,java}
	$TERMUX_DX \
		--dex \
		--output=$TERMUX_PREFIX/share/dex/ecj.jar \
		$RAW_JAR

	cd $TERMUX_PKG_TMPDIR
	rm -rf android-jar
	mkdir android-jar
	cd android-jar

        # We need the android classes for JDT to compile against.
	cp $ANDROID_HOME/platforms/android-24/android.jar .
	unzip -q android.jar
	rm -Rf android.jar resources.arsc res assets
	zip -q -r android.jar .

	cp $TERMUX_PKG_TMPDIR/android-jar/android.jar $TERMUX_PREFIX/share/java/android.jar
	rm -Rf $TERMUX_PREFIX/bin/javac
	install $TERMUX_PKG_BUILDER_DIR/ecj $TERMUX_PREFIX/bin/ecj
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/ecj
}
