TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-x11
TERMUX_PKG_DESCRIPTION="Termux X11 add-on application. Still in early development."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Twaik Yont @twaik"
TERMUX_PKG_VERSION=1.03.00
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/termux/termux-x11/archive/a50f18ef2d148a299387435edbde8fe690e9c504.tar.gz
TERMUX_PKG_SHA256=040ac1d57f610263d374b105ee7c5cd20099f98e3d8e43cb9bd203b803a93684
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="xkeyboard-config"
TERMUX_PKG_BREAKS="termux-x11"
TERMUX_PKG_REPLACES="termux-x11"
_JDK_VERSION=17.0.7.7.1
_GRADLE_VERSION=8.1.1

termux_step_make() {
	# Download and use a new enough gradle version to avoid the process hanging after running:
	termux_download \
		https://corretto.aws/downloads/resources/$_JDK_VERSION/amazon-corretto-$_JDK_VERSION-linux-x64.tar.gz \
		$TERMUX_PKG_CACHEDIR/amazon-corretto-$_JDK_VERSION-linux-x64.tar.gz \
		8d23e0f1249f2852caa76b7ae8770847e005e4310a70a46b7c1a816c34ff9195
	termux_download \
		https://services.gradle.org/distributions/gradle-$_GRADLE_VERSION-all.zip \
		$TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-all.zip \
		5625a0ae20fe000d9225d000b36909c7a0e0e8dda61c19b12da769add847c975
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

termux_step_create_debscripts() {
	cat <<- EOF > postinst
		#!${TERMUX_PREFIX}/bin/sh
		chmod -w $TERMUX_PREFIX/libexec/termux-x11/loader.apk
	EOF
}
