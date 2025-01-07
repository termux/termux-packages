TERMUX_PKG_HOMEPAGE=https://zeromq.org/
TERMUX_PKG_DESCRIPTION="Fast messaging system built on sockets. C and C++ bindings. aka 0MQ, ZMQ."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.5"
TERMUX_PKG_SRCURL=https://github.com/zeromq/libzmq/releases/download/v${TERMUX_PKG_VERSION}/zeromq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6653ef5910f17954861fe72332e68b03ca6e4d9c7160eb3a8de5a5a913bfab43
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libsodium"
TERMUX_PKG_BREAKS="libzmq-dev"
TERMUX_PKG_REPLACES="libzmq-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-libsodium --disable-libunwind --disable-Werror"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=5

	local e=$(sed -En 's/^LTVER="?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
				configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	./autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
