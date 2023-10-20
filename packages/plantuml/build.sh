TERMUX_PKG_HOMEPAGE=https://plantuml.com/
TERMUX_PKG_DESCRIPTION="Draws UML diagrams, using a simple and human readable text description"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2023.12"
TERMUX_PKG_SRCURL=https://github.com/plantuml/plantuml/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=67880e74ff80dab6427ef5e4f3adec3ed87878411599cd96aff2884ae280bb97
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	$TERMUX_PKG_SRCDIR/gradlew --no-daemon --parallel --stacktrace assemble
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/java
	install -Dm600 build/libs/plantuml-${TERMUX_PKG_VERSION}.jar $TERMUX_PREFIX/share/java/plantuml.jar
	install -Dm700 plantuml $TERMUX_PREFIX/bin/
}
