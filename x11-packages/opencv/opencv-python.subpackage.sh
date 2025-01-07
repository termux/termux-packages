TERMUX_SUBPKG_INCLUDE="lib/python*"
TERMUX_SUBPKG_DESCRIPTION="Python bindings for OpenCV"
TERMUX_SUBPKG_DEPENDS="python, python-numpy"

termux_step_create_subpkg_debscripts() {
	_NUMPY_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python-numpy/build.sh; echo $TERMUX_PKG_VERSION)

	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	INSTALLED_NUMPY_VERSION=\$(dpkg --list python-numpy | grep python-numpy | awk '{print \$3; exit;}')
	if [ "\${INSTALLED_NUMPY_VERSION%%-*}" != "$_NUMPY_VERSION" ]; then
		echo "WARNING: opencv-python is compiled with numpy $_NUMPY_VERSION, but numpy \${INSTALLED_NUMPY_VERSION%%-*} is installed. Please report it to https://github.com/termux/termux-packages if any bug happens."
	fi
	EOF
}
