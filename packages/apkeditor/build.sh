TERMUX_PKG_HOMEPAGE=https://github.com/REAndroid/APKEditor
TERMUX_PKG_DESCRIPTION="Powerful Android APK editor - aapt/aapt2 independent."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@Veha0001"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SRCURL=https://github.com/REAndroid/APKEditor/releases/download/V${TERMUX_PKG_VERSION}/APKEditor-${TERMUX_PKG_VERSION}.jar
TERMUX_PKG_SHA256=758f2f9153fff96c20260b177f025a3ca3cecc9777abdd43139a17e225724612
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

RAW_JAR=$TERMUX_PKG_CACHEDIR/APKEditor-${TERMUX_PKG_VERSION}.jar

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_SRCDIR
	termux_download $TERMUX_PKG_SRCURL \
		$RAW_JAR \
		$TERMUX_PKG_SHA256
}

termux_step_make_install() {
	install -Dm600 $RAW_JAR \
		$TERMUX_PREFIX/share/java/apkeditor.jar
	cat <<- EOF > $TERMUX_PREFIX/bin/apkeditor
	#!${TERMUX_PREFIX}/bin/sh
	exec java -jar $TERMUX_PREFIX/share/java/apkeditor.jar "\$@"
	EOF
	chmod 700 $TERMUX_PREFIX/bin/apkeditor
}
