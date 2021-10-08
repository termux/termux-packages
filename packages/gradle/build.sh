TERMUX_PKG_HOMEPAGE=https://gradle.org/
TERMUX_PKG_DESCRIPTION="Powerful build system for the JVM"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:7.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://services.gradle.org/distributions/gradle-${TERMUX_PKG_VERSION:2}-all.zip
TERMUX_PKG_SHA256=a8da5b02437a60819cad23e10fc7e9cf32bcb57029d9cb277e26eeff76ce014b
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	rm -f ./bin/*.bat
	rm -rf $TERMUX_PREFIX/opt/gradle
	mkdir -p $TERMUX_PREFIX/opt/gradle
	cp -r ./* $TERMUX_PREFIX/opt/gradle/
	for i in $TERMUX_PREFIX/opt/gradle/bin/*; do
		if [ ! -f "$i" ]; then
			continue
		fi
		ln -sfr $i $TERMUX_PREFIX/bin/$(basename $i)
	done
}

