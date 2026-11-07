TERMUX_SUBPKG_DESCRIPTION="Tkinter support for Python 3.15"
TERMUX_SUBPKG_DEPENDS="tcl, tk"
TERMUX_SUBPKG_INCLUDE="
bin/idle${_MAJOR_VERSION}
lib/python${_MAJOR_VERSION}/idlelib
lib/python${_MAJOR_VERSION}/tkinter
lib/python${_MAJOR_VERSION}/turtle.py
lib/python${_MAJOR_VERSION}/turtledemo
lib/python${_MAJOR_VERSION}/lib-dynload/_tkinter.*.so
"
