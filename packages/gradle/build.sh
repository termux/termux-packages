TERMUX_PKG_HOMEPAGE=https://gradle.org/
TERMUX_PKG_DESCRIPTION="Powerful build system for the JVM"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:9.8.0"
TERMUX_PKG_REVISION=1
# JNI libraries bundled with gradle, rebuilt for Android since the bundled ones need glibc
_NATIVE_PLATFORM_VERSION=0.22-milestone-29
_FILEEVENTS_VERSION=0.2.8
_JANSI_VERSION=2.4.2
TERMUX_PKG_SRCURL=(https://services.gradle.org/distributions/gradle-${TERMUX_PKG_VERSION:2}-bin.zip
                   https://github.com/gradle/native-platform/archive/refs/tags/${_NATIVE_PLATFORM_VERSION}.tar.gz
                   https://github.com/gradle/gradle-fileevents/archive/refs/tags/${_FILEEVENTS_VERSION}.tar.gz)
TERMUX_PKG_SHA256=(bafd5ce9cfaea0fbccfdc8439a1ac42fbd4cd9c89dc9a988228d8a2639a58e6c
                   5ba424fd825f834c9fb7ba53a6a459b17123b687cea284a3137f98cd2f0b13cc
                   f7872a43306c987778963ecc37b04262f384292a3abceea25cf6e03ba28da31a)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, ncurses, openjdk-21 | openjdk-25 | openjdk-17"
TERMUX_PKG_BUILD_DEPENDS="libjansi"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local jar
	for jar in native-platform-$_NATIVE_PLATFORM_VERSION gradle-fileevents-$_FILEEVENTS_VERSION jansi-$_JANSI_VERSION; do
		if [ ! -f lib/$jar.jar ]; then
			termux_error_exit "lib/$jar.jar not found, update the bundled library versions in build.sh"
		fi
	done
	mv native-platform-$_NATIVE_PLATFORM_VERSION gradle-fileevents-$_FILEEVENTS_VERSION $TERMUX_PKG_TMPDIR/
}

_gradle_add_to_jar() {
	local jar=$TERMUX_PKG_SRCDIR/$1 entry=$2 file=$3 stage=$TERMUX_PKG_TMPDIR/jar-stage
	rm -rf $stage
	install -Dm644 $file $stage/$entry
	(cd $stage && zip -q $jar $entry)
}

termux_step_make() {
	local np_platform fe_platform jansi_arch
	case $TERMUX_ARCH in
		aarch64) np_platform=linux-aarch64 fe_platform=aarch64-linux-gnu jansi_arch=arm64 ;;
		x86_64) np_platform=linux-amd64 fe_platform=x86_64-linux-gnu jansi_arch=x86_64 ;;
		i686) np_platform=linux-i386 fe_platform=i386-linux-gnu jansi_arch=x86 ;;
		# native-platform has no platform for 32-bit ARM Linux
		*) return ;;
	esac

	local np_src=$TERMUX_PKG_TMPDIR/native-platform-$_NATIVE_PLATFORM_VERSION/native-platform/src
	local fe_src=$TERMUX_PKG_TMPDIR/gradle-fileevents-$_FILEEVENTS_VERSION/src/main
	local out=$TERMUX_PKG_TMPDIR/native
	local classpath=$(ls lib/*.jar | tr '\n' ':')
	# Differs from the upstream version so that libraries extracted to
	# ~/.gradle/native by earlier builds of this package are not reused
	local np_version=$_NATIVE_PLATFORM_VERSION-termux
	mkdir -p $out/{np-gen,np-classes,np-jni,np-include,fe-gen,fe-jni,fe-include}

	mkdir -p $out/np-gen/net/rubygrapefruit/platform/internal/jni
	printf 'package net.rubygrapefruit.platform.internal.jni;\npublic interface NativeVersion { String VERSION = "%s"; }\n' \
		$np_version > $out/np-gen/net/rubygrapefruit/platform/internal/jni/NativeVersion.java
	printf '#define NATIVE_VERSION "%s"\n' $np_version > $out/np-include/native_platform_version.h
	javac -nowarn -cp "$classpath" -d $out/np-jni -h $out/np-include \
		$np_src/main/java/net/rubygrapefruit/platform/internal/jni/*.java
	# Native and Platform inline NativeVersion.VERSION, so they are recompiled with it
	javac --release 8 -Xlint:-options -nowarn -cp "$classpath" -d $out/np-classes \
		$out/np-gen/net/rubygrapefruit/platform/internal/jni/NativeVersion.java \
		$np_src/main/java/net/rubygrapefruit/platform/Native.java \
		$np_src/main/java/net/rubygrapefruit/platform/internal/Platform.java
	(cd $out/np-classes && zip -q -r $TERMUX_PKG_SRCDIR/lib/native-platform-$_NATIVE_PLATFORM_VERSION.jar net)

	$CXX $CPPFLAGS $CXXFLAGS -fPIC -shared -D_FILE_OFFSET_BITS=64 \
		-I$out/np-include -I$np_src/shared/headers \
		$np_src/shared/cpp/*.cpp $np_src/main/cpp/*.cpp \
		$LDFLAGS -o $out/libnative-platform.so
	$CXX $CPPFLAGS $CXXFLAGS -fPIC -shared -D_FILE_OFFSET_BITS=64 \
		-I$out/np-include -I$np_src/shared/headers \
		$np_src/shared/cpp/*.cpp $np_src/curses/cpp/*.cpp \
		$LDFLAGS -lncursesw -o $out/libnative-platform-curses.so

	mkdir -p $out/fe-gen/org/gradle/fileevents/internal
	printf 'package org.gradle.fileevents.internal;\npublic interface FileEventsVersion { String VERSION = "%s"; }\n' \
		$_FILEEVENTS_VERSION > $out/fe-gen/org/gradle/fileevents/internal/FileEventsVersion.java
	printf '#define FILE_EVENTS_VERSION "%s"\n' $_FILEEVENTS_VERSION > $out/fe-include/fileevents_version.h
	javac -nowarn -cp "$classpath" -d $out/fe-jni -h $out/fe-include \
		$(find $fe_src/java $out/fe-gen -name '*.java')
	$CXX $CPPFLAGS $CXXFLAGS -fPIC -shared -std=c++17 \
		-I$out/fe-include -I$fe_src/headers \
		$fe_src/cpp/*.cpp \
		$LDFLAGS -o $out/libgradle-fileevents.so

	local np_jar=lib/native-platform-$np_platform-$_NATIVE_PLATFORM_VERSION.jar
	local curses_jar=lib/native-platform-$np_platform-ncurses6-$_NATIVE_PLATFORM_VERSION.jar
	local ncurses5_jar=lib/native-platform-$np_platform-ncurses5-$_NATIVE_PLATFORM_VERSION.jar
	if [ ! -f $np_jar ]; then
		np_jar=lib/native-platform-$_NATIVE_PLATFORM_VERSION.jar
		curses_jar=$np_jar
	fi
	_gradle_add_to_jar $np_jar net/rubygrapefruit/platform/$np_platform/libnative-platform.so \
		$out/libnative-platform.so
	_gradle_add_to_jar $curses_jar net/rubygrapefruit/platform/$np_platform-ncurses6/libnative-platform-curses.so \
		$out/libnative-platform-curses.so
	# The ncurses5 variant is tried before ncurses6 and needs glibc
	if [ -f $ncurses5_jar ]; then
		zip -q -d $ncurses5_jar net/rubygrapefruit/platform/$np_platform-ncurses5/libnative-platform-curses.so
	fi
	_gradle_add_to_jar lib/gradle-fileevents-$_FILEEVENTS_VERSION.jar \
		net/rubygrapefruit/platform/$fe_platform/libgradle-fileevents.so $out/libgradle-fileevents.so

	_gradle_add_to_jar lib/jansi-$_JANSI_VERSION.jar \
		org/fusesource/jansi/internal/native/Linux/$jansi_arch/libjansi.so $TERMUX_PREFIX/lib/jansi/libjansi.so
	# gradle extracts jansi to ~/.gradle/native/jansi/<Implementation-Version>
	unzip -p lib/jansi-$_JANSI_VERSION.jar META-INF/MANIFEST.MF |
		sed "s/^Implementation-Version: $_JANSI_VERSION/&-termux/" > $out/MANIFEST.MF
	_gradle_add_to_jar lib/jansi-$_JANSI_VERSION.jar META-INF/MANIFEST.MF $out/MANIFEST.MF
}

termux_step_make_install() {
	rm -f ./bin/*.bat
	rm -rf $TERMUX_PREFIX/opt/gradle
	mkdir -p $TERMUX_PREFIX/opt/gradle
	cp -r ./* $TERMUX_PREFIX/opt/gradle/
	for i in $TERMUX_PREFIX/opt/gradle/bin/*; do
		if [ ! -f "$i" ]; then
			continue
		fi
		ln -sfr $i $TERMUX_PREFIX/bin/$(basename $i)
	done
}
