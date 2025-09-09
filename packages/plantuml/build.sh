TERMUX_PKG_HOMEPAGE=https://plantuml.com/
TERMUX_PKG_DESCRIPTION="Draws UML diagrams, using a simple and human readable text description"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2025.7"
TERMUX_PKG_SRCURL=https://github.com/plantuml/plantuml/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a28fb0ecdeb3f499eb4ef2881bc5ea51fd9388650df498071b95217cd04fe1df
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openjdk-21"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_make() {
	# increase gradle memory to avoid 'JVM garbage collector thrashing':
	# https://stackoverflow.com/a/74143183/11708026
	# https://github.com/termux/termux-packages/issues/24917
	$TERMUX_PKG_SRCDIR/gradlew --no-daemon --parallel --stacktrace assemble -Dorg.gradle.jvmargs=-Xmx4096M
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/java
	install -Dm600 build/libs/plantuml-${TERMUX_PKG_VERSION}.jar $TERMUX_PREFIX/share/java/plantuml.jar
	install -Dm700 plantuml $TERMUX_PREFIX/bin/
}
