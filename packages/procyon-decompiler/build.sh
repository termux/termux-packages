TERMUX_PKG_HOMEPAGE=https://github.com/mstrobel/procyon
TERMUX_PKG_DESCRIPTION="A standalone front-end for the Java decompiler in Procyon Compiler Toolset"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_SRCURL=https://github.com/mstrobel/procyon/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=516f410868f7523d804362a9dff5fa8fcf9232e5ee36bb7f0a5c8f71d5de7fe4
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	./gradlew build -x test -x javadoc
}

termux_step_make_install() {
	install -Dm600 -T \
		./build/Procyon.Decompiler/libs/procyon-decompiler-${TERMUX_PKG_VERSION}.jar \
		$TERMUX_PREFIX/share/java/procyon-decompiler.jar
	install -Dm700 -t $TERMUX_PREFIX/bin procyon-decompiler
}
