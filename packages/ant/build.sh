TERMUX_PKG_HOMEPAGE=https://ant.apache.org/
TERMUX_PKG_DESCRIPTION="Java based build tool like make"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.15"
TERMUX_PKG_SRCURL=https://dlcdn.apache.org//ant/binaries/apache-ant-${TERMUX_PKG_VERSION}-bin.tar.bz2
TERMUX_PKG_SHA256=87f48d18ba11c115688c37ef97583ec6ff89ea6033f89d818a67248da4710c4b
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_AUTO_UPDATE=true
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
