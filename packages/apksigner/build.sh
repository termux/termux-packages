TERMUX_PKG_HOMEPAGE=https://developer.android.com/studio/command-line/apksigner
TERMUX_PKG_DESCRIPTION="APK signing tool from Android SDK"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Do not use the TERMUX_ANDROID_BUILD_TOOLS_VERSION variable when specifying:
TERMUX_PKG_VERSION=33.0.1
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_pre_configure() {
	# Requires Android SDK, not available on device
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not available for on-device builds."
	fi

	# Version guard
	if [ "${TERMUX_PKG_VERSION#*:}" != "${TERMUX_ANDROID_BUILD_TOOLS_VERSION}" ]; then
		termux_error_exit "Version mismatch between TERMUX_PKG_VERSION and TERMUX_ANDROID_BUILD_TOOLS_VERSION."
	fi
}

termux_step_make_install() {
	install -Dm600 $ANDROID_HOME/build-tools/${TERMUX_ANDROID_BUILD_TOOLS_VERSION}/lib/apksigner.jar \
		$TERMUX_PREFIX/share/java/apksigner.jar
	cat <<- EOF > $TERMUX_PREFIX/bin/apksigner
	#!${TERMUX_PREFIX}/bin/sh
	exec java -jar $TERMUX_PREFIX/share/java/apksigner.jar "\$@"
	EOF
	chmod 700 $TERMUX_PREFIX/bin/apksigner
}
