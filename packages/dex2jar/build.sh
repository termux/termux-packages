TERMUX_PKG_HOMEPAGE=https://github.com/pxb1988/dex2jar
TERMUX_PKG_DESCRIPTION="Tools to work with android .dex and java .class files"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4"
TERMUX_PKG_SRCURL=https://github.com/pxb1988/dex2jar/releases/download/v${TERMUX_PKG_VERSION}/dex-tools-v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=ee7c45eb3c1d2474a6145d8d447e651a736a22d9664b6d3d3be5a5a817dda23a
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	rm -rf ./bin/*.bat
	rm -rf ./*.bat
	mkdir -p $TERMUX_PREFIX/opt/dex2jar
	cp -r ./* $TERMUX_PREFIX/opt/dex2jar
	ln -sfr $TERMUX_PREFIX/opt/dex2jar/bin/dex-tools $TERMUX_PREFIX/bin/d2j-run
	cd $TERMUX_PREFIX/opt/dex2jar/
	for i in *.sh; do
		ln -sfr $TERMUX_PREFIX/opt/dex2jar/$i $TERMUX_PREFIX/bin/${i%%.sh}
	done
}
