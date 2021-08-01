TERMUX_PKG_HOMEPAGE=https://www.scala-lang.org
TERMUX_PKG_DESCRIPTION="Scala 2 compiler and standard library."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.12.14
TERMUX_PKG_SRCURL=https://downloads.lightbend.com/scala/$TERMUX_PKG_VERSION/scala-$TERMUX_PKG_VERSION.tgz
TERMUX_PKG_SHA256=fd7e3e4032288013a29c0a1447c597faf7b0e499762c0d981db21099e9780426
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

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
