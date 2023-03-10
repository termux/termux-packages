TERMUX_PKG_HOMEPAGE=https://plantuml.com/
TERMUX_PKG_DESCRIPTION="Draws UML diagrams, using a simple and human readable text description"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2023.4
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/plantuml/${TERMUX_PKG_VERSION}/plantuml-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4a090124ddffa1fc9687507640eb8285376bb3f974df3badd73757d6ac5422b9
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
