TERMUX_PKG_HOMEPAGE=https://developer.android.com/studio/command-line/apksigner
TERMUX_PKG_DESCRIPTION="APK signing tool"
TERMUX_PKG_LICENSE="Apache-2.0, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=${TERMUX_ANDROID_BUILD_TOOLS_VERSION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_get_source() {
	termux_download \
		"https://android.googlesource.com/platform/tools/apksig/+/refs/tags/platform-tools-$TERMUX_PKG_VERSION/src/main/java/com/android/apksig/internal/asn1/Asn1BerParser.java?format=TEXT" \
		$TERMUX_PKG_CACHEDIR/Asn1BerParser_b64.java \
		f0506dedb7291dce1066b7aec3fc42c70b1862b39d9cdb176ba75d24b870765e
	mkdir -p "$TERMUX_PKG_SRCDIR"
}

termux_step_post_get_source() {
	cd "$TERMUX_PKG_SRCDIR"
	mkdir -p com/android/apksig/internal/asn1
	base64 -d $TERMUX_PKG_CACHEDIR/Asn1BerParser_b64.java > com/android/apksig/internal/asn1/Asn1BerParser.java
}

termux_step_pre_configure() {
	# Requires Android SDK, not available on device
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_make() {
	mkdir -p $TERMUX_PREFIX/share/dex
	cp $ANDROID_HOME/build-tools/${TERMUX_PKG_VERSION}/lib/apksigner.jar "$TERMUX_PKG_SRCDIR"
	SOURCEFILE="$TERMUX_PKG_SRCDIR/apksigner.jar"

	cd "$TERMUX_PKG_SRCDIR"

	# java.util.Base64 is available only on Android 8 and higher.
	# Provide a class copied from OpenJDK, so apksigner will work
	# on Android 7.
	mkdir -p java/util
	cp $TERMUX_PKG_BUILDER_DIR/Base64.java java/util/
	javac java/util/Base64.java
	javac -cp "$SOURCEFILE" com/android/apksig/internal/asn1/Asn1BerParser.java
	zip -u "$SOURCEFILE" 'java/util/Base64.class'
	zip -u "$SOURCEFILE" 'java/util/Base64$1.class'
	zip -u "$SOURCEFILE" 'java/util/Base64$DecInputStream.class'
	zip -u "$SOURCEFILE" 'java/util/Base64$Decoder.class'
	zip -u "$SOURCEFILE" 'java/util/Base64$Encoder.class'
	zip -u "$SOURCEFILE" 'java/util/Base64$EncOutputStream.class'
	zip -u "$SOURCEFILE" com/android/apksig/internal/asn1/Asn1BerParser.class

	$TERMUX_D8 \
		--classpath $ANDROID_HOME/platforms/android-$TERMUX_PKG_API_LEVEL/android.jar \
		--release \
		--min-api $TERMUX_PKG_API_LEVEL \
		--output $TERMUX_PKG_TMPDIR \
		$SOURCEFILE
}

termux_step_make_install() {
	cd $TERMUX_PKG_TMPDIR
	unzip $SOURCEFILE */*.txt
	jar cf apksigner.jar classes.dex com/
	mv apksigner.jar $TERMUX_PREFIX/share/dex/apksigner.jar

	echo '#!/bin/sh' > $TERMUX_PREFIX/bin/apksigner
	echo "dalvikvm -Xcompiler-option --compiler-filter=speed -cp $TERMUX_PREFIX/share/dex/apksigner.jar com.android.apksigner.ApkSignerTool \$@" >> $TERMUX_PREFIX/bin/apksigner
	chmod +x $TERMUX_PREFIX/bin/apksigner
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/bash
	rm -f $TERMUX_PREFIX/share/dex/oat/*/apksigner.{art,oat,odex,vdex} >/dev/null 2>&1
	exit 0
	EOF
}
