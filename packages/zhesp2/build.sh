TERMUX_PKG_HOMEPAGE="https://pypi.org/project/zhesp2/"
TERMUX_PKG_DESCRIPTION="ZHESP2 - Zero's Hash Encryption Secure Protocol, a modern encryption CLI"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Zero n8696414@gmail.com"
TERMUX_PKG_VERSION=2.4.5
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/z/zhesp2/zhesp2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256="f69cf205dc2470a950ecc6095a26087eb69d79da6530e2ca445d7f89427f4b15"
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    pip install . --prefix=$PREFIX
}
