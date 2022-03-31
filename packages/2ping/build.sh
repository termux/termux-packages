TERMUX_PKG_HOMEPAGE=https://www.finnie.org/software/2ping/
TERMUX_PKG_DESCRIPTION="A bi-directional ping utility"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.5.1
TERMUX_PKG_SRCURL=https://github.com/rfinnie/2ping/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0f85dc21be1266daccfbba903819ca8935ebdbe002b1e0305bfda258af44fdcd
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

TERMUX_PKG_RM_AFTER_INSTALL="
lib/python${_PYTHON_VERSION}/site-packages/__pycache__
lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
lib/python${_PYTHON_VERSION}/site-packages/site.py
"

termux_step_pre_configure() {
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate

	export PYTHONPATH=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
}

termux_step_make() {
	:
}

termux_step_make_install() {
	python setup.py install --force --prefix $TERMUX_PREFIX

	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 doc/2ping.1
}

termux_step_create_debscripts() {
	local _2PING_EGG="2ping-${TERMUX_PKG_VERSION}-py${_PYTHON_VERSION}.egg"

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "./${_2PING_EGG}" >> $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	sed -i "/\.\/${_2PING_EGG//./\\.}/d" $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF
}
