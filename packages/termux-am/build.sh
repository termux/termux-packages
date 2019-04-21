TERMUX_PKG_HOMEPAGE=https://github.com/michalbednarski/TermuxAm
TERMUX_PKG_DESCRIPTION="Android Oreo-compatible am command reimplementation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Michal Bednarski @michalbednarski"
TERMUX_PKG_VERSION=0.2
TERMUX_PKG_SHA256=bde5ca8a6778a8be99370b35453eca92c8283c2987016a3d8ea6eddbad0c3f0e
TERMUX_PKG_SRCURL=https://github.com/michalbednarski/TermuxAm/archive/v$TERMUX_PKG_VERSION.zip
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFLICTS="termux-tools (<< 0.51)"

termux_step_make() {
	# Download and use a new enough gradle version to avoid the process hanging after running:
	termux_download \
		https://services.gradle.org/distributions/gradle-5.4-bin.zip \
		$TERMUX_PKG_CACHEDIR/gradle-5.4-bin.zip \
		c8c17574245ecee9ed7fe4f6b593b696d1692d1adbfef425bef9b333e3a0e8de
	mkdir $TERMUX_PKG_TMPDIR/gradle
	unzip -q $TERMUX_PKG_CACHEDIR/gradle-5.4-bin.zip -d $TERMUX_PKG_TMPDIR/gradle

	export ANDROID_HOME
	GRADLE_OPTS=" -Dorg.gradle.daemon=false" \
		$TERMUX_PKG_TMPDIR/gradle/gradle-5.4/bin/gradle \
		:app:assembleRelease
}

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/am-libexec-packaged $TERMUX_PREFIX/bin/am
	mkdir -p $TERMUX_PREFIX/libexec/termux-am
	cp $TERMUX_PKG_SRCDIR/app/build/outputs/apk/release/app-release-unsigned.apk $TERMUX_PREFIX/libexec/termux-am/am.apk
}
