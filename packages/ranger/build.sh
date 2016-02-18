TERMUX_PKG_HOMEPAGE=http://ranger.nongnu.org/
TERMUX_PKG_DESCRIPTION="File manager with VI key bindings"
TERMUX_PKG_VERSION=1.7.2
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://ranger.nongnu.org/ranger-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python, file"
TERMUX_PKG_FOLDERNAME=ranger-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
        python3.4 setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage () {
	find . -path '*/__pycache__*' -delete

	# Work around python 3.5 not being available on ubuntu 15.04:
	perl -p -i -e 's|python3.4|python3.5|g' bin/*
	mv lib/python3.4 lib/python3.5
	mv lib/python3.5/site-packages/ranger-${TERMUX_PKG_VERSION}-py3.{4,5}.egg-info
}
