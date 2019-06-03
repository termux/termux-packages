TERMUX_PKG_HOMEPAGE=http://pyropus.ca/software/getmail/
TERMUX_PKG_DESCRIPTION="fetchmail replacement relatively easy to configure"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=5.13
TERMUX_PKG_SHA256=04d52f6475f09e9f99b4e3d2f1d2eb967a68b67f09af2a6a5151857f060b0a9d
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
