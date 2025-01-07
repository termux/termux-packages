TERMUX_PKG_HOMEPAGE=https://www.eclipse.org/jdt/core/
TERMUX_PKG_DESCRIPTION="Eclipse Compiler for Java"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Version 4.12 is the last known to work on Android 7-8.
_VERSION=4.12
_DATE=201906051800
TERMUX_PKG_VERSION=1:${_VERSION}
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://archive.eclipse.org/eclipse/downloads/drops${_VERSION:0:1}/R-${_VERSION}-${_DATE}/ecj-${_VERSION}.jar
TERMUX_PKG_SHA256=69dad18a1fcacd342a7d44c5abf74f50e7529975553a24c64bce0b29b86af497
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFLICTS="ecj4.6"

RAW_JAR=$TERMUX_PKG_CACHEDIR/ecj-${_VERSION}.jar

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_SRCDIR
	termux_download $TERMUX_PKG_SRCURL \
		$RAW_JAR \
		$TERMUX_PKG_SHA256
}

termux_step_make() {
	mkdir -p $TERMUX_PREFIX/share/{dex,java}
	$TERMUX_D8 \
		--classpath $ANDROID_HOME/platforms/android-$TERMUX_PKG_API_LEVEL/android.jar \
		--release \
		--min-api $TERMUX_PKG_API_LEVEL \
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
	cp $ANDROID_HOME/platforms/android-$TERMUX_PKG_API_LEVEL/android.jar android.jar
	unzip -q android.jar
	rm -Rf android.jar resources.arsc res assets
	jar cfM android-$TERMUX_PKG_API_LEVEL.jar .
	cp $TERMUX_PKG_TMPDIR/android-jar/android-$TERMUX_PKG_API_LEVEL.jar $TERMUX_PREFIX/share/java/

	rm -Rf $TERMUX_PREFIX/bin/javac
	install $TERMUX_PKG_BUILDER_DIR/ecj $TERMUX_PREFIX/bin/ecj
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/ecj
	install $TERMUX_PKG_BUILDER_DIR/ecj-$TERMUX_PKG_API_LEVEL $TERMUX_PREFIX/bin/ecj-$TERMUX_PKG_API_LEVEL
	perl -p -i -e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" $TERMUX_PREFIX/bin/ecj-$TERMUX_PKG_API_LEVEL
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/bash
	chmod -w $TERMUX_PREFIX/share/dex/ecj.jar
	rm -f $TERMUX_PREFIX/share/dex/oat/*/ecj.{art,oat,odex,vdex} >/dev/null 2>&1
	exit 0
	EOF
}
