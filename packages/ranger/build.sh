TERMUX_PKG_HOMEPAGE=https://ranger.github.io/
TERMUX_PKG_DESCRIPTION="File manager with VI key bindings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.9.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=49a2d8dc5fa7b1c0cac0fa72d4ad704fc7107dee36cb9feb325a42754774d363
TERMUX_PKG_SRCURL=https://github.com/ranger/ranger/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python, file"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make() {
	echo Skipping make step...
}

termux_step_make_install() {
	python3.7 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage() {
	find . -path '*/__pycache__*' -delete
}
