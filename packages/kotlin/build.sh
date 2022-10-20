TERMUX_PKG_HOMEPAGE=https://kotlinlang.org/
TERMUX_PKG_DESCRIPTION="The Kotlin Programming Language"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.20
TERMUX_PKG_SRCURL=https://github.com/JetBrains/kotlin/releases/download/v${TERMUX_PKG_VERSION}/kotlin-compiler-${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=5e3c8d0f965410ff12e90d6f8dc5df2fc09fd595a684d514616851ce7e94ae7d
TERMUX_PKG_DEPENDS="openjdk-17"
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
