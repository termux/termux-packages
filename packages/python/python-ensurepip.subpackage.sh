TERMUX_SUBPKG_DESCRIPTION="Pre-core for Python 'ensurepip'."
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_DEPEND_ON_PARENT=true
TERMUX_SUBPKG_DEPENDS="python-ensurepip-binary, python-ensurepip-wheels"
TERMUX_SUBPKG_INCLUDE="
lib/python${_MAJOR_VERSION}/ensurepip/
"
