TERMUX_PKG_HOMEPAGE=https://www.borgbackup.org/
TERMUX_PKG_DESCRIPTION="Deduplicating and compressing backup program"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.17
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/borgbackup/borg/releases/download/${TERMUX_PKG_VERSION}/borgbackup-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7ab924fc017b24929bedceba0dcce16d56f9868bf9b5050d2aae2eb080671674
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libacl, liblz4, openssl, python, zstd"
TERMUX_PKG_BUILD_IN_SRC=true

_PYTHON_VERSION=3.9

TERMUX_PKG_RM_AFTER_INSTALL="
lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
lib/python${_PYTHON_VERSION}/site-packages/site.py
lib/python${_PYTHON_VERSION}/site-packages/__pycache__
"

termux_step_make_install() {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	export CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}"
	export LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	export LDSHARED="$CC -shared"
	export BORG_OPENSSL_PREFIX=$TERMUX_PREFIX
	export BORG_LIBLZ4_PREFIX=$TERMUX_PREFIX
	export BORG_LIBZSTD_PREFIX=$TERMUX_PREFIX
	python${_PYTHON_VERSION} setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "./borgbackup-${TERMUX_PKG_VERSION}-py${_PYTHON_VERSION}-linux-x86_64.egg" >> $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	sed -i "/\.\/borgbackup-${TERMUX_PKG_VERSION}-py${_PYTHON_VERSION}-linux-x86_64\.egg/d" $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF
}
