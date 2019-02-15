TERMUX_PKG_HOMEPAGE=http://pyropus.ca/software/getmail/
TERMUX_PKG_DESCRIPTION="fetchmail replacement relatively easy to configure"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=5.11
TERMUX_PKG_SHA256=086647c7ccde5b1346354d924ca3020660dc096a41b67207217d6b0a81b92ba2
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/getmail-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install() {
	python2 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage() {
	find . -path '*.pyc' -delete
}
