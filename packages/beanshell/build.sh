TERMUX_PKG_HOMEPAGE=https://github.com/beanshell/beanshell
TERMUX_PKG_DESCRIPTION="Small, free, embeddable, source level Java interpreter with object based scripting language features written in Java"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.0b6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/beanshell/beanshell/releases/download/$TERMUX_PKG_VERSION/bsh-$TERMUX_PKG_VERSION.jar
TERMUX_PKG_SHA256=a17955976070c0573235ee662f2794a78082758b61accffce8d3f8aedcd91047
TERMUX_PKG_DEPENDS="dash, termux-tools"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_download \
		"$TERMUX_PKG_SRCURL" \
		"$TERMUX_PKG_CACHEDIR/bsh-$TERMUX_PKG_VERSION.jar" \
		"$TERMUX_PKG_SHA256"
}

termux_step_make() {
	"$TERMUX_D8" \
		--classpath "$ANDROID_HOME/platforms/android-$TERMUX_PKG_API_LEVEL/android.jar" \
		--release \
		--min-api "$TERMUX_PKG_API_LEVEL" \
		--output "$TERMUX_PKG_SRCDIR" \
		"$TERMUX_PKG_CACHEDIR/bsh-$TERMUX_PKG_VERSION.jar"

	jar cf beanshell.jar classes.dex
}

termux_step_make_install() {
	install -Dm600 beanshell.jar "$TERMUX_PREFIX/share/dex/beanshell.jar"

	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "dalvikvm -cp $TERMUX_PREFIX/share/dex/beanshell.jar bsh.Interpreter \"\$@\""
	} > "$TERMUX_PREFIX"/bin/beanshell

	chmod 700 "$TERMUX_PREFIX"/bin/beanshell
	ln -sfr "$TERMUX_PREFIX"/bin/beanshell "$TERMUX_PREFIX"/bin/bsh
}
