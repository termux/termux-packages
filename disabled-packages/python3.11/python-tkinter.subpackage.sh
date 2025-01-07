TERMUX_SUBPKG_DESCRIPTION="Tkinter support for Python 3"
TERMUX_SUBPKG_DEPENDS="tcl, tk"
TERMUX_SUBPKG_INCLUDE="
bin/idle*
lib/python${_MAJOR_VERSION}/idlelib
lib/python${_MAJOR_VERSION}/tkinter
lib/python${_MAJOR_VERSION}/turtle.py
lib/python${_MAJOR_VERSION}/turtledemo
lib/python${_MAJOR_VERSION}/lib-dynload/_tkinter.*.so
lib/python${_MAJOR_VERSION}/__pycache__/turtle.*.pyc
"
TERMUX_SUBPKG_BREAKS="python (<< 3.11.1-3)"
TERMUX_SUBPKG_REPLACES="python (<< 3.11.1-3)"
