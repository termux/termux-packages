TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_VERSION=1.4.0
# ncurses-utils for tput which asciinema uses:
TERMUX_PKG_DEPENDS="python, ncurses-utils"
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=841a55b0f51988d5e155e99badbd6ce5cf3b43cca2ba15cd20c971a19719dc9a
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

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
