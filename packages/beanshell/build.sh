TERMUX_PKG_HOMEPAGE=https://github.com/beanshell/beanshell
TERMUX_PKG_DESCRIPTION="Small, free, embeddable, source level Java interpreter with object based scripting language features written in Java"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.1"
TERMUX_PKG_SRCURL=https://github.com/beanshell/beanshell/releases/download/$TERMUX_PKG_VERSION/bsh-$TERMUX_PKG_VERSION.jar
TERMUX_PKG_SHA256=71192cbbe49e7a269cfcba05dc5cb959c33b9b26dafcd6266ca3288b461f86a3
TERMUX_PKG_AUTO_UPDATE=true
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
	$TERMUX_D8 --output beanshell.jar \
		"$TERMUX_PKG_CACHEDIR/bsh-$TERMUX_PKG_VERSION.jar"
}

termux_step_make_install() {
	install -Dm600 beanshell.jar "$TERMUX_PREFIX/share/dex/beanshell.jar"

	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "dalvikvm -Xcompiler-option --compiler-filter=speed -cp $TERMUX_PREFIX/share/dex/beanshell.jar bsh.Interpreter \"\$@\""
	} > "$TERMUX_PREFIX"/bin/beanshell

	chmod 700 "$TERMUX_PREFIX"/bin/beanshell
	ln -sfr "$TERMUX_PREFIX"/bin/beanshell "$TERMUX_PREFIX"/bin/bsh
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/bash
	rm -f $TERMUX_PREFIX/share/dex/oat/*/beanshell.{art,oat,odex,vdex} >/dev/null 2>&1
	exit 0
	EOF
}
