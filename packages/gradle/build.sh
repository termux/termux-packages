TERMUX_PKG_HOMEPAGE=https://gradle.org/
TERMUX_PKG_DESCRIPTION="Powerful build system for the JVM"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:9.6.0"
TERMUX_PKG_SRCURL=https://services.gradle.org/distributions/gradle-${TERMUX_PKG_VERSION:2}-bin.zip
TERMUX_PKG_SHA256=bbaeb2fef8710818cf0e261201dab964c572f92b942812df0c3620d62a529a01
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openjdk-21"
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
