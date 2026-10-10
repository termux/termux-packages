TERMUX_PKG_HOMEPAGE=https://plantuml.com/
TERMUX_PKG_DESCRIPTION="Draws UML diagrams, using a simple and human readable text description"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2026.8"
TERMUX_PKG_SRCURL="https://github.com/plantuml/plantuml/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=caa1dc0b2df3058c38b69de5878eb048a24a99346aeab663b7027e85cdc83467
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openjdk-21"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_make() {
	local _OLD_JAVA_HOME="$JAVA_HOME"
	export JAVA_HOME="${JAVA_HOME/java-17-openjdk/java-21-openjdk}"

	# increase gradle memory to avoid 'JVM garbage collector thrashing':
	# https://stackoverflow.com/a/74143183/11708026
	# https://github.com/termux/termux-packages/issues/24917
	$TERMUX_PKG_SRCDIR/gradlew --no-daemon --parallel --stacktrace assemble -Dorg.gradle.jvmargs=-Xmx4096M

	export JAVA_HOME="$_OLD_JAVA_HOME"
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/java
	install -Dm600 build/libs/plantuml-${TERMUX_PKG_VERSION}.jar $TERMUX_PREFIX/share/java/plantuml.jar
	install -Dm700 plantuml $TERMUX_PREFIX/bin/
}
