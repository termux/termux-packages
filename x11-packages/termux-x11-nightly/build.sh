TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-x11
TERMUX_PKG_DESCRIPTION="Termux X11 add-on application. Still in early development."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Twaik Yont @twaik"
TERMUX_PKG_VERSION=1.02.07
TERMUX_PKG_SRCURL=https://github.com/termux/termux-x11/archive/62bf17ddf8a8cacd945f8ef3fa9e91cec42fa39c.tar.gz
TERMUX_PKG_SHA256=9d9fcc0312304b2dc335454224f4b26768f927dff289472ef0a489099c223126
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="xkeyboard-config"
_JDK_VERSION=11.0.19.7.1
_GRADLE_VERSION=7.5

termux_step_make() {
	# Download and use a new enough gradle version to avoid the process hanging after running:
	termux_download \
		https://corretto.aws/downloads/resources/$_JDK_VERSION/amazon-corretto-$_JDK_VERSION-linux-x64.tar.gz \
		$TERMUX_PKG_CACHEDIR/amazon-corretto-$_JDK_VERSION-linux-x64.tar.gz \
		d3b7de2a0916da0d3826d980e9718a64932a160c33e8dfa6dbff2a91fef56976
	termux_download \
		https://services.gradle.org/distributions/gradle-$_GRADLE_VERSION-all.zip \
		$TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-all.zip \
		97a52d145762adc241bad7fd18289bf7f6801e08ece6badf80402fe2b9f250b1
	mkdir $TERMUX_PKG_TMPDIR/gradle
	mkdir $TERMUX_PKG_TMPDIR/gradle-jdk
	
	tar --strip-components=1 -xf $TERMUX_PKG_CACHEDIR/amazon-corretto-$_JDK_VERSION-linux-x64.tar.gz -C $TERMUX_PKG_TMPDIR/gradle-jdk
	unzip -q $TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-all.zip -d $TERMUX_PKG_TMPDIR/gradle

	# Avoid spawning the gradle daemon due to org.gradle.jvmargs
	# being set (https://github.com/gradle/gradle/issues/1434):
	rm gradle.properties

	export JAVA_HOME="$TERMUX_PKG_TMPDIR/gradle-jdk"
	export ANDROID_HOME
	export GRADLE_OPTS="-Dorg.gradle.daemon=false -Xmx1536m"
	
	echo "org.gradle.jvmargs=-Xmx1536m" > $TERMUX_PKG_SRCDIR/gradle.properties
	echo "android.useAndroidX=true" >> $TERMUX_PKG_SRCDIR/gradle.properties
	echo "android.enableJetifier=true" >> $TERMUX_PKG_SRCDIR/gradle.properties

	cd $TERMUX_PKG_SRCDIR
	# Github action builds are signed with debug key, and loader checks self signature while loading main package.
	$TERMUX_PKG_TMPDIR/gradle/gradle-$_GRADLE_VERSION/bin/gradle :shell-loader:assembleDebug
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/bin
	mkdir -p $TERMUX_PREFIX/libexec/termux-x11
	cp $TERMUX_PKG_SRCDIR/termux-x11 $TERMUX_PREFIX/bin/termux-x11
	cp $TERMUX_PKG_SRCDIR/shell-loader/build/outputs/apk/debug/shell-loader-debug.apk \
		$TERMUX_PREFIX/libexec/termux-x11/loader.apk
}
