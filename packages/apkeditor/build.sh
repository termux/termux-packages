TERMUX_PKG_HOMEPAGE=https://github.com/REAndroid/APKEditor
TERMUX_PKG_DESCRIPTION="Android binary resource files editor"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@Veha0001"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SRCURL=https://github.com/REAndroid/APKEditor/releases/download/V${TERMUX_PKG_VERSION}/APKEditor-${TERMUX_PKG_VERSION}.jar
TERMUX_PKG_SHA256=758f2f9153fff96c20260b177f025a3ca3cecc9777abdd43139a17e225724612
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_make_install() {
	termux_download $TERMUX_PKG_SRCURL $TERMUX_PKG_CACHEDIR/APKEditor-${TERMUX_PKG_VERSION}.jar $TERMUX_PKG_SHA256
	install -Dm600 $TERMUX_PKG_CACHEDIR/APKEditor-${TERMUX_PKG_VERSION}.jar \
		$TERMUX_PREFIX/libexec/apkeditor/apkeditor.jar
	cat <<- EOF > $TERMUX_PREFIX/bin/apkeditor
	#!${TERMUX_PREFIX}/bin/sh
	exec java -jar $TERMUX_PREFIX/libexec/apkeditor/apkeditor.jar "\$@"
	EOF
	chmod 700 $TERMUX_PREFIX/bin/apkeditor
}
