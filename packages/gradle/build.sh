TERMUX_PKG_HOMEPAGE=https://gradle.org/
TERMUX_PKG_DESCRIPTION="Adaptable, fast automation for all"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.1.1
TERMUX_PKG_SRCURL=https://services.gradle.org/distributions/gradle-$TERMUX_PKG_VERSION-all.zip
TERMUX_PKG_SHA256=9bb8bc05f562f2d42bdf1ba8db62f6b6fa1c3bf6c392228802cc7cb0578fe7e0
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
