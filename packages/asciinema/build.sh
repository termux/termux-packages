TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_SHA256=7087b247dae36d04821197bc14ebd4248049592b299c9878d8953c025ac802e4
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_HAS_DEBUG=no
# ncurses-utils for tput which asciinema uses:
TERMUX_PKG_DEPENDS="python, ncurses-utils"

termux_step_make () {
	return
}

termux_step_make_install () {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python3.6/site-packages/
	python3.6 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage () {
	find . -path '*/__pycache__*' -delete
}
