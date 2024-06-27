TERMUX_PKG_HOMEPAGE=https://pagure.io/xmlto/
TERMUX_PKG_DESCRIPTION="Convert xml to many other formats"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.29"
TERMUX_PKG_SRCURL=https://www.pagure.io/xmlto/archive/${TERMUX_PKG_VERSION}/xmlto-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=40504db68718385a4eaa9154a28f59e51e59d006d1aa14f5bc9d6fded1d6017a
TERMUX_PKG_DEPENDS="xsltproc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology

termux_step_pre_configure() {
	autoreconf -fi
}
