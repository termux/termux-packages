# Issue:
# java.lang.NoClassDefFoundError: org.eclipse.jdt.internal.compiler.apt.dispatch.BatchProcessingEnvImpl
# perhaps because BatchProcessingEnvImpl uses javax.tools which does not exist on android?
TERMUX_PKG_HOMEPAGE=http://tools.android.com/tech-docs/jackandjill
TERMUX_PKG_DESCRIPTION="Java Android Compiler Kit"
TERMUX_PKG_VERSION=$TERMUX_ANDROID_BUILD_TOOLS_VERSION
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make () {
	# Create $USR/share/dex for dex files, and $USR/share/jack for .jack library files produced by jill:
        mkdir -p $TERMUX_PREFIX/share/{dex,jack}
	$TERMUX_DX \
		-JXmx4096M --num-threads=4 \
		--dex \
		--output=$TERMUX_PREFIX/share/dex/jack.jar \
		$TERMUX_JACK

	cd $TERMUX_PKG_TMPDIR
	rm -rf android-jar
	mkdir android-jar
	cd android-jar

        # We need the android.jar clases in jill format (.jack extension) for jack to compile against.
	cp $ANDROID_HOME/platforms/android-23/android.jar .
	# Remove resources not needed for compilation to reduce size:
	unzip -q android.jar
	rm -Rf android.jar resources.arsc res assets
	zip -r -q android.jar .

	java -jar $TERMUX_JILL $TERMUX_PKG_TMPDIR/android-jar/android.jar --output $TERMUX_PREFIX/share/jack/android.jack
	mkdir -p $TERMUX_PREFIX/bin
	install $TERMUX_PKG_BUILDER_DIR/jack.sh $TERMUX_PREFIX/bin/jack
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/jack
}
