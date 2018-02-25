TERMUX_PKG_HOMEPAGE=https://ranger.github.io/
TERMUX_PKG_DESCRIPTION="File manager with VI key bindings"
TERMUX_PKG_VERSION=1.9.1
TERMUX_PKG_SHA256=7c32f96080030866b7b95740c40b17a37d6ee86055e054e9e0759e79e2bf6b9a
TERMUX_PKG_SRCURL=https://github.com/ranger/ranger/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python, file"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make() {
	echo Skipping make step...
}

termux_step_make_install() {
        python3.6 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage() {
	find . -path '*/__pycache__*' -delete
}
