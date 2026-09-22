# Contributor: @michalbednarski
TERMUX_PKG_HOMEPAGE=https://github.com/termux/TermuxAm
TERMUX_PKG_DESCRIPTION="Android Oreo-compatible am command reimplementation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Michal Bednarski @michalbednarski"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/termux/TermuxAm/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7d4cfa2bfff93d5fc89fc89e537d2c072e08918276b140b7ed48ea45ebfbe8f3
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFLICTS="termux-tools (<< 0.51)"
_GRADLE_VERSION=8.10.2

termux_step_post_get_source() {
	sed -i'' -E -e "s|\@TERMUX_PREFIX\@|${TERMUX_PREFIX}|g" "$TERMUX_PKG_SRCDIR/am-libexec-packaged"
	sed -i'' -E -e "s|\@TERMUX_APP_PACKAGE\@|${TERMUX_APP_PACKAGE}|g" "$TERMUX_PKG_SRCDIR/app/src/main/java/com/termux/termuxam/FakeContext.java"
}

# Make sure $ANDROID_HOME points at a writable SDK with a usable sdkmanager.
# The package-builder image ships an SDK owned by root, which makes both
# sdkmanager and Gradle fail with
# "Failed to read or create install properties file".
# When the shipped SDK isn't usable, we build a fresh user-owned one at
# $HOME/android-sdk and install the components Gradle needs.
termux_am_prepare_sdk() {
	if [ -n "${ANDROID_HOME:-}" ] && [ -w "$ANDROID_HOME" ] && \
		[ -x "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
		export ANDROID_HOME
		return 0
	fi

	export ANDROID_HOME="$HOME/android-sdk"
	if [ ! -x "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
		rm -rf "$ANDROID_HOME"
		mkdir -p "$ANDROID_HOME"
		curl -fsSL -o "$TERMUX_PKG_TMPDIR/cmdline-tools.zip" \
			"https://dl.google.com/android/repository/commandlinetools-linux-${TERMUX_SDK_REVISION}_latest.zip"
		unzip -q "$TERMUX_PKG_TMPDIR/cmdline-tools.zip" -d "$ANDROID_HOME"
		mv "$ANDROID_HOME/cmdline-tools" "$ANDROID_HOME/cmdline-tools.tmp"
		mkdir -p "$ANDROID_HOME/cmdline-tools/latest" "$ANDROID_HOME/licenses"
		mv "$ANDROID_HOME/cmdline-tools.tmp"/* "$ANDROID_HOME/cmdline-tools/latest/"
		rmdir "$ANDROID_HOME/cmdline-tools.tmp"
	fi

	local sm="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
	# `(yes || true)` stops `yes`'s SIGPIPE (exit 141) from failing the
	# pipeline under `set -o pipefail`.
	(yes || true) | "$sm" --sdk_root="$ANDROID_HOME" --licenses
	(yes || true) | "$sm" --sdk_root="$ANDROID_HOME" \
		"platform-tools" "build-tools;30.0.3" "platforms;android-33"
}

termux_step_make() {
	termux_am_prepare_sdk

	# Download and use a new enough gradle version to avoid the process hanging after running:
	termux_download \
		https://services.gradle.org/distributions/gradle-$_GRADLE_VERSION-bin.zip \
		$TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-bin.zip \
		31c55713e40233a8303827ceb42ca48a47267a0ad4bab9177123121e71524c26
	mkdir $TERMUX_PKG_TMPDIR/gradle
	unzip -q $TERMUX_PKG_CACHEDIR/gradle-$_GRADLE_VERSION-bin.zip -d $TERMUX_PKG_TMPDIR/gradle

	# Stop Gradle from trying to auto-install SDK components (which would
	# write into a possibly-unwritable SDK dir and fail).
	if ! grep -q '^android\.builder\.sdkDownload=' gradle.properties 2>/dev/null; then
		echo 'android.builder.sdkDownload=false' >> gradle.properties
	fi

	# Avoid spawning the gradle daemon due to org.gradle.jvmargs
	# being set (https://github.com/gradle/gradle/issues/1434):
	sed -i'' -E '/^org\.gradle\.jvmargs=.*/d' gradle.properties

	export GRADLE_OPTS="-Dorg.gradle.daemon=false -Xmx1536m -Dorg.gradle.java.home=/usr/lib/jvm/java-1.17.0-openjdk-amd64"

	$TERMUX_PKG_TMPDIR/gradle/gradle-$_GRADLE_VERSION/bin/gradle \
		:app:assembleRelease
}

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/am-libexec-packaged $TERMUX_PREFIX/bin/am
	mkdir -p $TERMUX_PREFIX/libexec/termux-am
	cp $TERMUX_PKG_SRCDIR/app/build/outputs/apk/release/app-release-unsigned.apk $TERMUX_PREFIX/libexec/termux-am/am.apk
}
