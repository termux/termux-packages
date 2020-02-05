TERMUX_PKG_HOMEPAGE=http://developer.android.com/tools/help/index.html
TERMUX_PKG_DESCRIPTION="Command which takes in Java class files and converts them to format executable by Dalvik VM"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1:1.16
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://dl.bintray.com/xeffyr/sources/dx/dx-android-${TERMUX_PKG_VERSION:2}.jar
TERMUX_PKG_SHA256=b9b7917267876b74c8ff6707e7a576c93b6dfe8cacc4f1cc791d606bcbbb7bd5
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	termux_download "$TERMUX_PKG_SRCURL" \
		"$TERMUX_PKG_CACHEDIR/dx-${TERMUX_PKG_VERSION:2}.jar" \
		"$TERMUX_PKG_SHA256"

	install -Dm600 "$TERMUX_PKG_CACHEDIR/dx-${TERMUX_PKG_VERSION:2}.jar" \
		"$TERMUX_PREFIX"/share/dex/dx.jar

	cat <<- EOF > "$TERMUX_PREFIX"/bin/dx
	#!${TERMUX_PREFIX}/bin/sh
	exec dalvikvm \
		-Xmx256m \
		-cp ${TERMUX_PREFIX}/share/dex/dx.jar \
		dx.dx.command.Main "\$@"
	EOF
	chmod 700 "$TERMUX_PREFIX"/bin/dx

	cat <<- EOF > "$TERMUX_PREFIX"/bin/dx-merge
	#!${TERMUX_PREFIX}/bin/sh
	exec dalvikvm \
		-Xmx256m \
		-cp ${TERMUX_PREFIX}/share/dex/dx.jar \
		dx.dx.merge.DexMerger "\$@"
	EOF
	chmod 700 "$TERMUX_PREFIX"/bin/dx-merge
}
