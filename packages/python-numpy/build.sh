TERMUX_PKG_HOMEPAGE=https://numpy.org/
TERMUX_PKG_DESCRIPTION="The fundamental package for scientific computing with Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.23.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/numpy/numpy.git
TERMUX_PKG_DEPENDS="libc++, python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
"

termux_step_pre_configure() {
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not available for on-device builds."
	fi
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
}

termux_step_configure() {
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate

	LDFLAGS+=" -lpython${_PYTHON_VERSION}"
}

termux_step_make() {
	build-pip install pybind11 Cython pythran wheel
	DEVICE_STIE=$TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages
	MATHLIB="m" python setup.py install --force
}

termux_step_make_install() {
	export PYTHONPATH="$DEVICE_STIE"
	MATHLIB="m" python setup.py install --force --prefix $TERMUX_PREFIX

	pushd $DEVICE_STIE
	_NUMPY_EGGDIR=
	for f in numpy-${TERMUX_PKG_VERSION}-py${_PYTHON_VERSION}-linux-*.egg; do
		if [ -d "$f" ]; then
			_NUMPY_EGGDIR="$f"
			break
		fi
	done
	test -n "${_NUMPY_EGGDIR}"

	# XXX: Fix the EXT_SUFFIX. More investigation is needed to find the underlying cause.
	pushd "${_NUMPY_EGGDIR}"
	local old_suffix=".cpython-310-$TERMUX_HOST_PLATFORM.so"
	local new_suffix=".cpython-310.so"

	find . \
		-name '*'"$old_suffix" \
		-exec sh -c '_f="{}"; mv -- "$_f" "${_f%'"$old_suffix"'}'"$new_suffix"'"' \;
	popd

	popd
}

termux_step_post_make_install() {
	# Delete the easy-install related files, since we use postinst/prerm to handle it.
	pushd $TERMUX_PREFIX
	rm -rf lib/python${_PYTHON_VERSION}/site-packages/__pycache__
	rm -rf lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	rm -rf lib/python${_PYTHON_VERSION}/site-packages/site.py
	popd
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing numpy..."
	echo "./${_NUMPY_EGGDIR}" >> $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	sed -i "/\.\/${_NUMPY_EGGDIR//./\\.}/d" $TERMUX_PREFIX/lib/python${_PYTHON_VERSION}/site-packages/easy-install.pth
	EOF
}
