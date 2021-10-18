TERMUX_PKG_HOMEPAGE=https://maven.apache.org/
TERMUX_PKG_DESCRIPTION="Java software project management and comprehension tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@masterjavaofficial"
TERMUX_PKG_VERSION=3.8.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/masterjavaofficial/maven/releases/download/maven-${TERMUX_PKG_VERSION}/apache-maven-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73210072007f3bbc1ace154772c5e80cd646c12e970495c55053fef661c2f6f6
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_SUGGESTS="gradle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	rm -f ./bin/*.cmd ./bin/*.conf
	rm -rf $TERMUX_PREFIX/opt/maven
	mkdir -p $TERMUX_PREFIX/opt/maven
	cp -r ./* $TERMUX_PREFIX/opt/maven/
	for i in $TERMUX_PREFIX/opt/maven/bin/*; do
		ln -sfr $i $TERMUX_PREFIX/bin/$(basename $i)
	done
}
