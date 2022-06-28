TERMUX_PKG_HOMEPAGE=https://developer.android.com/studio/command-line/bundletool
TERMUX_PKG_DESCRIPTION="Bundletool is a command-line tool to manipulate Android App Bundles"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.0
TERMUX_PKG_SRCURL=https://github.com/google/bundletool/releases/download/${TERMUX_PKG_VERSION}/bundletool-all-${TERMUX_PKG_VERSION}.jar
TERMUX_PKG_SHA256=a5eee8fd22628c3f45662492498d3da38faf2bf2c64d425911492a5db6bc081c
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
RAW_JAR=$TERMUX_PKG_CACHEDIR/bundletool-all-${TERMUX_PKG_VERSION}.jar

termux_step_pre_configure() {
	# Requires Android SDK, not available on device
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not available for on-device builds."
	fi
}

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_SRCDIR
	termux_download $TERMUX_PKG_SRCURL \
		$RAW_JAR \
		$TERMUX_PKG_SHA256
}

termux_step_make_install() {
	install -Dm600 $RAW_JAR \
		$TERMUX_PREFIX/share/java/bundletool-all-${TERMUX_PKG_VERSION}.jar
	cat <<- EOF > $TERMUX_PREFIX/bin/bundletool
	#!${TERMUX_PREFIX}/bin/sh
	exec java -jar $TERMUX_PREFIX/share/java/bundletool-all-${TERMUX_PKG_VERSION}.jar "\$@"
	EOF
	chmod 700 $TERMUX_PREFIX/bin/bundletool
}
