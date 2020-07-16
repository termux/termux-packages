TERMUX_PKG_HOMEPAGE=https://developer.android.com/studio/command-line/apksigner
TERMUX_PKG_DESCRIPTION="APK signing tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=${TERMUX_ANDROID_BUILD_TOOLS_VERSION}
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	# Requires Android SDK, not available on device
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_make() {
	mkdir -p $TERMUX_PREFIX/share/dex
	SOURCEFILE=$ANDROID_HOME/build-tools/${TERMUX_PKG_VERSION}/lib/apksigner.jar

	$TERMUX_D8 \
		--classpath $ANDROID_HOME/platforms/android-$TERMUX_PKG_API_LEVEL/android.jar \
		--release \
		--min-api $TERMUX_PKG_API_LEVEL \
		--output $TERMUX_PKG_TMPDIR \
		$SOURCEFILE

	cd $TERMUX_PKG_TMPDIR
	unzip $SOURCEFILE */*.txt
	jar cf apksigner.jar classes.dex com/
	mv apksigner.jar $TERMUX_PREFIX/share/dex/apksigner.jar

	echo '#!/bin/sh' > $TERMUX_PREFIX/bin/apksigner
	echo "dalvikvm -cp $TERMUX_PREFIX/share/dex/apksigner.jar com.android.apksigner.ApkSignerTool \$@" >> $TERMUX_PREFIX/bin/apksigner
	chmod +x $TERMUX_PREFIX/bin/apksigner
}
