TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://pypi.python.org/pypi/six/
TERMUX_PKG_DESCRIPTION="Python 2 and 3 compatibility utilities"
TERMUX_PKG_VERSION=1.11.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://pypi.io/packages/source/s/six/six-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make () {
    return
}

termux_step_make_install () {
    export PYTHONPATH=${TERMUX_PREFIX}/lib/python2.7/site-packages/
    python2.7 setup.py install --prefix="${TERMUX_PREFIX}" --force
}

#termux_step_post_massage () {
#    find . -path '*/__pycache__*' -delete
#    find . -path \*.pyc -delete
#    find . -path \*.pyo -delete
#}
