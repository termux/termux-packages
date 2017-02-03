TERMUX_PKG_HOMEPAGE=http://pyropus.ca/software/getmail/
TERMUX_PKG_DESCRIPTION="fetchmail replacement relatively easy to configure"
TERMUX_PKG_VERSION=4.53.0
TERMUX_PKG_SRCURL=http://pyropus.ca/software/getmail/old-versions/getmail-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=282596fe33b5a24b3aefe5b268f57efbcdd5b980478901418045b481636f92ab
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
        python2 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage () {
        find . -path '*.pyc' -delete
}
