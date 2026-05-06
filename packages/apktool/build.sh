TERMUX_PKG_HOMEPAGE=https://apktool.org/
TERMUX_PKG_DESCRIPTION="A tool for reverse engineering Android apps (decoding, rebuilding, and smali debugging)."
TERMUX_PKG_MAINTAINER="xingguangcuican6666"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=https://github.com/iBotPeaches/Apktool/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5bdb4316f9d9aaf07874901860b1938bdd8f850a76d4e35777f4483beea8a63d
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	./gradlew build shadowJar proguard
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/java
	# Install the shadowJar with proguard - the executable JAR
	find ./brut.apktool/apktool-cli/build/libs/ -name "*dirty*.jar" | xargs -I {} install -Dm600 {} $TERMUX_PREFIX/share/java/apktool.jar
	install -Dm755 scripts/linux/apktool $TERMUX_PREFIX/bin/apktool
	sed -i "s|libdir=\"\$progdir\"|libdir=\"$TERMUX_PREFIX/share/java\"|g" \
		$TERMUX_PREFIX/bin/apktool
}
