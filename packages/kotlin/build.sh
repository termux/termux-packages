TERMUX_PKG_HOMEPAGE=https://kotlinlang.org/
TERMUX_PKG_DESCRIPTION="The Kotlin Programming Language"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.10"
TERMUX_PKG_SRCURL=https://github.com/JetBrains/kotlin/releases/download/v${TERMUX_PKG_VERSION}/kotlin-compiler-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=302d1d8e671e5c3207e6ed62ff11fb555462a628e22a1158254dcaaf7e7394bc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openjdk-21"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	rm -f ./bin/*.bat
	rm -rf $TERMUX_PREFIX/opt/kotlin
	mkdir -p $TERMUX_PREFIX/opt/kotlin
	cp -r ./* $TERMUX_PREFIX/opt/kotlin/
	for i in $TERMUX_PREFIX/opt/kotlin/bin/*; do
		if [ ! -f "$i" ]; then
			continue
		fi
		ln -sfr $i $TERMUX_PREFIX/bin/$(basename $i)
	done
}
