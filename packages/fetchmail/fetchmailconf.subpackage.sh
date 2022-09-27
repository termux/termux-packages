TERMUX_SUBPKG_INCLUDE="
bin/fetchmailconf
lib/python*
share/man/man1/fetchmailconf.1.gz
"
TERMUX_SUBPKG_DESCRIPTION="A GUI configurator for generating fetchmail configuration files"
TERMUX_SUBPKG_DEPENDS="python, python-tkinter"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_CONFLICTS="fetchmail (<< 6.4.33)"
TERMUX_SUBPKG_REPLACES="fetchmail (<< 6.4.33)"
