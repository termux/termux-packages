TERMUX_PKG_HOMEPAGE=https://ranger.github.io/
TERMUX_PKG_DESCRIPTION="File manager with VI key bindings"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_SHA256=fe1e11a24cb14148b26977a38160bb5f9fe255c5a0f211d1b0359103cea7c617
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
