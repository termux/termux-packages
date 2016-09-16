TERMUX_PKG_HOMEPAGE=http://profanity.im
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=http://profanity.im/profanity-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses,glib,libstrophe,libcurl,readline,libuuid,libotr,gpgme,python-dev"
TERMUX_PKG_BUILD_IN_SRC=yes
#Enforce python-plugin-support. Building without it works
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --enable-python-plugins"

#What I tried so far:
#termux_step_pre_configure() {
	#export PYTHON_LDFLAGS+=" -L${PREFIX}/lib/python3.5"
	#export PYTHON_CPPFLAGS+=" -I${PREFIX}/include/python3.5m"
	#export PYTHON="$PREFIX/bin/python"
	#export PYTHON_VERSION=3.5
	#export PYTHON_NOVERSIONCHECK=yes
	#export PYTHON_CONFIG_EXISTS=yes
#}
