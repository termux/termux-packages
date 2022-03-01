TERMUX_PKG_HOMEPAGE=https://www.borgbackup.org/
TERMUX_PKG_DESCRIPTION="Deduplicating and compressing backup program"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.17
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://github.com/borgbackup/borg/releases/download/${TERMUX_PKG_VERSION}/borgbackup-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7ab924fc017b24929bedceba0dcce16d56f9868bf9b5050d2aae2eb080671674
# Cannot be updated to 1.2.0 (or newer) as it requires external python package
#TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libacl, liblz4, openssl, python, xxhash, zstd"
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

	export LDFLAGS+=" -lpython${_PYTHON_VERSION}"
	export LDSHARED="$CC -shared"
}

termux_step_make() {
	python setup.py install --force
}

termux_step_make_install() {
	pushd ${_CROSSENV_PREFIX}/cross/lib/python${_PYTHON_VERSION}/site-packages
	_BORGBACKUP_EGGDIR=
	for f in borgbackup-${TERMUX_PKG_VERSION}-py${_PYTHON_VERSION}-linux-*.egg; do
		if [ -d "$f" ]; then
			_BORGBACKUP_EGGDIR="$f"
			break
		fi
	done
	test -n "${_BORGBACKUP_EGGDIR}"
	cp -rT "${_BORGBACKUP_EGGDIR}" $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/"${_BORGBACKUP_EGGDIR}"
	popd
	for f in borg borgfs; do
		cp -T ${_CROSSENV_PREFIX}/cross/bin/$f $TERMUX_PREFIX/bin/$f
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "./${_BORGBACKUP_EGGDIR}" >> $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	sed -i "/\.\/${_BORGBACKUP_EGGDIR//./\\.}/d" $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF
}
