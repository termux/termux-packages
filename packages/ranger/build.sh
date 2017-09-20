TERMUX_PKG_HOMEPAGE=http://ranger.nongnu.org/
TERMUX_PKG_DESCRIPTION="File manager with VI key bindings"
TERMUX_PKG_VERSION=1.8.1
TERMUX_PKG_SRCURL=http://ranger.nongnu.org/ranger-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1433f9f9958b104c97d4b23ab77a2ac37d3f98b826437b941052a55c01c721b4
TERMUX_PKG_DEPENDS="python, file"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
        python3.6 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage () {
	find . -path '*/__pycache__*' -delete
}
