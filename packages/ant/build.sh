TERMUX_PKG_HOMEPAGE=http://ant.apache.org/
TERMUX_PKG_DESCRIPTION="Java based build tool like make"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.10.11
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://apache.mirrors.spacedump.net//ant/binaries/apache-ant-${TERMUX_PKG_VERSION}-bin.tar.bz2
TERMUX_PKG_SHA256=ffc6c9eb2d153db76e18df70fa145744ddd0d754339df5a797a47603cfeaa8a6
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mv ./bin/ant .
	rm -f ./bin/*
	mv ./ant ./bin/
	rm -rf manual
	rm -rf $TERMUX_PREFIX/opt/ant
	mkdir -p $TERMUX_PREFIX/opt/ant
	cp -r ./* $TERMUX_PREFIX/opt/ant
	ln -sfr $TERMUX_PREFIX/opt/ant/bin/ant $TERMUX_PREFIX/bin/ant
}
