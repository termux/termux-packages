# Contributor: @michalbednarski
TERMUX_PKG_HOMEPAGE=https://github.com/termux/TermuxAm
TERMUX_PKG_DESCRIPTION="Android Oreo-compatible am command reimplementation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Michal Bednarski @michalbednarski"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/termux/TermuxAm/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7d4cfa2bfff93d5fc89fc89e537d2c072e08918276b140b7ed48ea45ebfbe8f3
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="termux-tools (<< 0.51)"
_GRADLE_VERSION=8.10.2

termux_step_post_get_source() {
	sed -i'' -E -e "s|\@TERMUX_PREFIX\@|${TERMUX_PREFIX}|g" "$TERMUX_PKG_SRCDIR/am-libexec-packaged"
	sed -i'' -E -e "s|\@TERMUX_APP_PACKAGE\@|${TERMUX_APP_PACKAGE}|g" "$TERMUX_PKG_SRCDIR/app/src/main/java/com/termux/termuxam/FakeContext.java"
}

termux_step_make() {
	# Download and use a new enough gradle version to avoid the process hanging after running:
	termux_download \
		https://services.gradle.org/distributions/gradle-$_GRADLE_VERSION-bin.zip \
		$TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-bin.zip \
		31c55713e40233a8303827ceb42ca48a47267a0ad4bab9177123121e71524c26
	mkdir $TERMUX_PKG_TMPDIR/gradle
	unzip -q $TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-bin.zip -d $TERMUX_PKG_TMPDIR/gradle

	# Avoid spawning the gradle daemon due to org.gradle.jvmargs
	# being set (https://github.com/gradle/gradle/issues/1434):
	sed -i'' -E '/^org\.gradle\.jvmargs=.*/d' gradle.properties

	export ANDROID_HOME
	export GRADLE_OPTS="-Dorg.gradle.daemon=false -Xmx1536m -Dorg.gradle.java.home=/usr/lib/jvm/java-1.17.0-openjdk-amd64"

	$TERMUX_PKG_TMPDIR/gradle/gradle-$_GRADLE_VERSION/bin/gradle \
		:app:assembleRelease
}

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/am-libexec-packaged $TERMUX_PREFIX/bin/am
	mkdir -p $TERMUX_PREFIX/libexec/termux-am
	cp $TERMUX_PKG_SRCDIR/app/build/outputs/apk/release/app-release-unsigned.apk $TERMUX_PREFIX/libexec/termux-am/am.apk
}
