TERMUX_PKG_HOMEPAGE=https://github.com/paramiko/paramiko
TERMUX_PKG_DESCRIPTION="Native Python 2 SSHv2 protocol library"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_SRCURL=https://github.com/paramiko/paramiko/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=paramiko-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="python2"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	export PYTHONUSERBASE=$TERMUX_PREFIX
#python setup.py install --force --prefix=$TERMUX_PREFIX
	python setup.py install --force --user
}

termux_step_post_massage () {
	find . -path '*.pyc' -delete
}
