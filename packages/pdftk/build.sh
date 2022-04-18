TERMUX_PKG_HOMEPAGE=https://gitlab.com/pdftk-java/pdftk
TERMUX_PKG_DESCRIPTION="A simple tool for doing everyday things with PDF documents"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.2
TERMUX_PKG_SRCURL=https://gitlab.com/pdftk-java/pdftk/-/archive/v${TERMUX_PKG_VERSION}/pdftk-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2389120140dc43cab4d3cdaf4f9b2f6b5e37b50afe60795e0f3726312c29fb18
TERMUX_PKG_DEPENDS="libbcprov-java, libcommons-lang3-java, openjdk-17"
TERMUX_PKG_BUILD_DEPENDS="ant"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	mkdir -p lib
	ln -sf $TERMUX_PREFIX/share/java/commons-lang3.jar lib/
	ln -sf $TERMUX_PREFIX/share/java/bcprov.jar lib/
}

termux_step_make() {
	sh $TERMUX_PREFIX/bin/ant jar
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/java
	install -Dm600 build/jar/pdftk.jar $TERMUX_PREFIX/share/java/
	install -Dm700 pdftk $TERMUX_PREFIX/bin/
}
