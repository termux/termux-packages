TERMUX_PKG_HOMEPAGE=http://www.eclipse.org/jdt/core/
TERMUX_PKG_DESCRIPTION="Eclipse Compiler for Java"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_VERSION=4.7.2
local _date=201711300510
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=43c2f45d1fd9afb8b04e547a253041957f19b2f21d8780cdb3a8706ce9b9b9ee
TERMUX_PKG_SRCURL=http://archive.eclipse.org/eclipse/downloads/drops${TERMUX_PKG_VERSION:0:1}/R-$TERMUX_PKG_VERSION-$_date/ecj-$TERMUX_PKG_VERSION.jar
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFLICTS="ecj4.6"

termux_step_extract_package() {
	mkdir $TERMUX_PKG_SRCDIR
}

termux_step_make() {
	local RAW_JAR=$TERMUX_PKG_CACHEDIR/ecj-${TERMUX_PKG_VERSION}.jar
	termux_download $TERMUX_PKG_SRCURL \
		$RAW_JAR \
		$TERMUX_PKG_SHA256

	mkdir -p $TERMUX_PREFIX/share/{dex,java}
	$TERMUX_D8 \
		--classpath $ANDROID_HOME/platforms/android-$TERMUX_PKG_API_LEVEL/android.jar \
		--release \
		--min-api 21 \
		--output $TERMUX_PKG_TMPDIR \
		$RAW_JAR

	# Package classes.dex into jar:
	cd $TERMUX_PKG_TMPDIR
	jar cf ecj.jar classes.dex
	# Add needed properties file to jar file:
	jar xf $RAW_JAR org/eclipse/jdt/internal/compiler/batch/messages.properties
	jar uf ecj.jar	org/eclipse/jdt/internal/compiler/batch/messages.properties
	jar xf $RAW_JAR org/eclipse/jdt/internal/compiler/problem/messages.properties
	jar uf ecj.jar	org/eclipse/jdt/internal/compiler/problem/messages.properties
	jar xf $RAW_JAR org/eclipse/jdt/internal/compiler/messages.properties
	jar uf ecj.jar	org/eclipse/jdt/internal/compiler/messages.properties
	jar xf $RAW_JAR org/eclipse/jdt/internal/compiler/parser/readableNames.props
	jar uf ecj.jar	org/eclipse/jdt/internal/compiler/parser/readableNames.props
	for i in $(seq 1 24); do
		jar xf $RAW_JAR org/eclipse/jdt/internal/compiler/parser/parser$i.rsc
		jar uf ecj.jar	org/eclipse/jdt/internal/compiler/parser/parser$i.rsc
	done
	# Move into place:
	mv ecj.jar $TERMUX_PREFIX/share/dex/ecj.jar

	rm -rf android-jar
	mkdir android-jar
	cd android-jar

	# We need the android classes for JDT to compile against.
	cp $ANDROID_HOME/platforms/android-28/android.jar .
	unzip -q android.jar
	rm -Rf android.jar resources.arsc res assets
	jar cfM android.jar .

	cp $TERMUX_PKG_TMPDIR/android-jar/android.jar $TERMUX_PREFIX/share/java/android.jar

	# Bundle in an android.jar from an older API also, for those who want to
	# build apps that run on older Android versions.
	rm -Rf ./*
	cp $ANDROID_HOME/platforms/android-21/android.jar android.jar
	unzip -q android.jar
	rm -Rf android.jar resources.arsc res assets
	jar cfM android-21.jar .
	cp $TERMUX_PKG_TMPDIR/android-jar/android-21.jar $TERMUX_PREFIX/share/java/

	rm -Rf $TERMUX_PREFIX/bin/javac
	install $TERMUX_PKG_BUILDER_DIR/ecj $TERMUX_PREFIX/bin/ecj
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/ecj
	install $TERMUX_PKG_BUILDER_DIR/ecj-21 $TERMUX_PREFIX/bin/ecj-21
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/ecj-21
}
