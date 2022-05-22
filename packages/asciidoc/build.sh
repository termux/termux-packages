TERMUX_PKG_HOMEPAGE=https://asciidoc.org
TERMUX_PKG_DESCRIPTION="Text document format for short documents, articles, books and UNIX man pages."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.2.0"
TERMUX_PKG_SRCURL=https://github.com/asciidoc/asciidoc-py3/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=684ea53c1f5b71d6d1ac6086bbc96906b1f709ecc7ab536615b0f0c9e1baa3cc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="docbook-xsl, libxml2-utils, python, xsltproc"
TERMUX_PKG_SUGGESTS="w3m"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

termux_step_pre_configure() {
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
}

termux_step_make() {
	python setup.py install --force
}

termux_step_make_install() {
	pushd ${_CROSSENV_PREFIX}/cross/lib/python${_PYTHON_VERSION}/site-packages
	_ASCIIDOC_EGGDIR=asciidoc-${TERMUX_PKG_VERSION}-py${_PYTHON_VERSION}.egg
	cp -rT "${_ASCIIDOC_EGGDIR}" $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/"${_ASCIIDOC_EGGDIR}"
	popd
	for f in asciidoc a2x; do
		cp -T ${_CROSSENV_PREFIX}/cross/bin/$f $TERMUX_PREFIX/bin/$f
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "./${_ASCIIDOC_EGGDIR}" >> $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	sed -i "/\.\/${_ASCIIDOC_EGGDIR//./\\.}/d" $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF
}
