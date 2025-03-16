TERMUX_SUBPKG_DESCRIPTION="Python bindings and CLI tools for Frida"
TERMUX_SUBPKG_INCLUDE="
bin/frida
bin/frida-apk
bin/frida-create
bin/frida-discover
bin/frida-kill
bin/frida-ls-devices
bin/frida-ps
bin/frida-trace
bin/frida-itrace
bin/frida-join
bin/frida-ls
bin/frida-pm
bin/frida-pull
bin/frida-push
bin/frida-rm
lib/python*
share/gir-1.0
share/fish
"
TERMUX_SUBPKG_DEPENDS="libandroid-support, python, python-pip"
TERMUX_SUBPKG_CONFLICTS="frida-tools (<< 15.1.24)"
TERMUX_SUBPKG_REPLACES="frida-tools (<< 15.1.24)"
TERMUX_SUBPKG_PYTHON_RUNTIME_DEPS="'prompt-toolkit>=2.0.0,<4.0.0', 'colorama>=0.2.7,<1.0.0', 'pygments>=2.0.2,<3.0.0', 'websockets>=13.0.0,<14.0.0'"
