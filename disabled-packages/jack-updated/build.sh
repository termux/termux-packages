TERMUX_PKG_HOMEPAGE=https://source.android.com/source/jack.html
TERMUX_PKG_DESCRIPTION="Java Android Compiler Kit"
# Use the date of the below git commit as the version number:
TERMUX_PKG_VERSION=20170216
_COMMIT=3626c3909d03c304b595a86a8a7700ac83ec4e95
TERMUX_PKG_SRCURL=https://android.googlesource.com/toolchain/jack/+archive/${_COMMIT}.tar.gz
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_extract_package() {
	mkdir -p $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR

	filename=`basename $TERMUX_PKG_SRCURL`
	file=$TERMUX_PKG_CACHEDIR/$filename
	test ! -f $file && termux_download $TERMUX_PKG_SRCURL $file $TERMUX_PKG_SHA256
	tar xf $file

	rm sched/src/com/android/sched/util/log/tracer/probe/GcDurationProbe.java
}

termux_step_make () {
	cd $TERMUX_PKG_SRCDIR
	./gradlew assemble
	local JACK_JAR=$PWD/jack/gradle-build/libs/jack.jar
	local JILL_JAR=$PWD/jill/gradle-build/libs/jill.jar

	# Create $USR/share/dex for dex files, and $USR/share/jack for .jack library files produced by jill:
	mkdir -p $TERMUX_PREFIX/share/{dex,jack}
	local JACK_JACK=$TERMUX_PKG_TMPDIR/jack.jack
	java -jar $JACK_JAR --output-dex $TERMUX_PKG_TMPDIR --import $JACK_JAR

	cp ./jill/gradle-build/jill-version.properties $TERMUX_PKG_TMPDIR/
	cp ./jack/gradle-build/jack-version.properties $TERMUX_PKG_TMPDIR/
	cd $TERMUX_PKG_TMPDIR
	zip $TERMUX_PREFIX/share/dex/jack.jar \
		jill-version.properties \
		jack-version.properties \
		classes.dex

	cd $TERMUX_PKG_TMPDIR
	rm -rf android-jar
	mkdir android-jar
	cd android-jar

        # We need the android.jar clases in jill format (.jack extension) for jack to compile against.
	cp $ANDROID_HOME/platforms/android-24/android.jar .
	# Remove resources not needed for compilation to reduce size:
	unzip -q android.jar
	rm -Rf android.jar resources.arsc res assets
	zip -r -q android.jar .
	java -jar $JILL_JAR $TERMUX_PKG_TMPDIR/android-jar/android.jar --output $TERMUX_PREFIX/share/jack/android.jack

	# Add support annotations .jack file:
	local ANNOTATIONS_VERSION=24.2.0
	local ANNOTATIONS_JAR=$TERMUX_PKG_CACHEDIR/support-annotations-${ANNOTATIONS_VERSION}.jar
	if [ ! -f $ANNOTATIONS_JAR ]; then
		termux_download http://uiq3.sourceforge.net/Repository/com/android/support/support-annotations/${ANNOTATIONS_VERSION}/support-annotations-${ANNOTATIONS_VERSION}.jar \
		  $ANNOTATIONS_JAR \
		  af5868da6750bdf42aec5d85fa87ac30de2b72939ca80437a6247e5753a07cad
	fi
	java -jar $JILL_JAR $ANNOTATIONS_JAR --output $TERMUX_PREFIX/share/jack/support-annotations-${ANNOTATIONS_VERSION}.jack

	mkdir -p $TERMUX_PREFIX/bin
	install $TERMUX_PKG_BUILDER_DIR/jack.sh $TERMUX_PREFIX/bin/jack
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/jack
}
