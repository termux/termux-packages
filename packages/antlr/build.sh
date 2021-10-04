TERMUX_PKG_HOMEPAGE=https://antlr.org
TERMUX_PKG_DESCRIPTION="ANTLR Parser Generator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_VERSION=4.9.2
TERMUX_PKG_SRCURL=https://www.antlr.org/download/antlr-4.9.2-complete.jar
TERMUX_PKG_SHA256SUM=bb117b1476691dc2915a318efd36f8957c0ad93447fb1dac01107eb15fe137cd
TERMUX_PKG_PLATFORM_INDEPENDENT=true


RAW_JAR=$TERMUX_PKG_CACHEDIR/antlr-${TERMUX_PKG_VERSION}-complete.jar

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_SRCDIR
	termux_download $TERMUX_PKG_SRCURL \
		$RAW_JAR \
		$TERMUX_PKG_SHA256
}

termux_step_make() {
	mkdir -p $TERMUX_PREFIX/share/antlr
	mv RAW_JAR $TERMUX_PREFIX/share/antlr/antlr.jar
	install $TERMUX_PKG_BUILDER_DIR/antlr $TERMUX_PREFIX/bin/antlr
}
