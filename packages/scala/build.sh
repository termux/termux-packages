TERMUX_PKG_HOMEPAGE=https://www.scala-lang.org
TERMUX_PKG_DESCRIPTION="Scala 3 compiler and standard library."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.2"
TERMUX_PKG_SRCURL=https://github.com/lampepfl/dotty/releases/download/$TERMUX_PKG_VERSION/scala3-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2447f095126c6532a4d0300896c87e5350e8ce6e14417c1578b4a4348187304b
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	rm -f ./bin/*.bat
	rm -rf $TERMUX_PREFIX/opt/scala
	mkdir -p $TERMUX_PREFIX/opt/scala
	cp -r ./* $TERMUX_PREFIX/opt/scala/
	for i in $TERMUX_PREFIX/opt/scala/bin/*; do
		if [ ! -f "$i" ]; then
			continue
		fi
		ln -sfr $i $TERMUX_PREFIX/bin/$(basename $i)
	done
}
