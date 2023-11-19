TERMUX_PKG_HOMEPAGE=https://scipy.org/
TERMUX_PKG_DESCRIPTION="Fundamental algorithms for scientific computing in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.11.4"
TERMUX_PKG_SRCURL=git+https://github.com/scipy/scipy
TERMUX_PKG_DEPENDS="libc++, libopenblas, python, python-numpy"
TERMUX_PKG_BUILD_DEPENDS="python-numpy-static"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, 'Cython>=0.29.35,<3.0'"
_NUMPY_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python-numpy/build.sh; echo $TERMUX_PKG_VERSION)
TERMUX_PKG_PYTHON_BUILD_DEPS="'pybind11>=2.10.4,<2.11.1', 'numpy==$_NUMPY_VERSION', pythran"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
"

termux_step_post_get_source() {
	cp _setup.py setup.py
}

termux_step_configure() {
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not available for on-device builds."
	fi

	termux_setup_flang
}

termux_step_make() {
	# Needed to link against libopenblas
	cat <<- EOF > site.cfg
	[openblas]
	libraries = openblas
	library_dirs = $TERMUX_PREFIX/lib
	include_dirs = $TERMUX_PREFIX/include
	EOF

	# Find libnpymath.a and libnpyrandom.a for Android
	cp $PYTHONPATH/numpy/core/lib/libnpymath.a $TERMUX_PREFIX/lib
	cp $PYTHONPATH/numpy/random/lib/libnpyrandom.a $TERMUX_PREFIX/lib

	# Dummy libgfortran.a
	echo "!<arch>" > $TERMUX_PREFIX/lib/libgfortran.a

	F90=$FC F77=$FC python setup.py bdist_wheel -v || bash
}

termux_step_make_install() {
	F90=$FC F77=$FC pip install ./dist/*.whl --no-deps --prefix=$TERMUX_PREFIX
}

termux_step_post_make_install() {
	# Remove these dummy files.
	rm $TERMUX_PREFIX/lib/libgfortran.a
	rm $TERMUX_PREFIX/lib/libnpymath.a
	rm $TERMUX_PREFIX/lib/libnpyrandom.a
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	INSTALLED_NUMPY_VERSION=\$(dpkg --list python-numpy | grep python-numpy | awk '{print \$3; exit;}')
	if [ "\${INSTALLED_NUMPY_VERSION%%-*}" != "$_NUMPY_VERSION" ]; then
		echo "WARNING: python-scipy is compiled with numpy $_NUMPY_VERSION, but numpy \${INSTALLED_NUMPY_VERSION%%-*} is installed. It seems that python-numpy has been upgraded. Please report it to https://github.com/termux/termux-packages if any bug happens."
	fi
	EOF
}
