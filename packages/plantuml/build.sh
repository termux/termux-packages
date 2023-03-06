TERMUX_PKG_HOMEPAGE=https://plantuml.com/
TERMUX_PKG_DESCRIPTION="Draws UML diagrams, using a simple and human readable text description"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2023.2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/plantuml/${TERMUX_PKG_VERSION}/plantuml-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2fc942cd9e7c35f212eb99320d0bac6df214d43c4e02b6feb14b5203b916d7f9
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_DEPENDS="ant"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	sh $TERMUX_PREFIX/bin/ant dist
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/java
	install -Dm600 plantuml.jar $TERMUX_PREFIX/share/java/
	install -Dm700 plantuml $TERMUX_PREFIX/bin/
}
