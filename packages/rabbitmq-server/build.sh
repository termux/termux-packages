TERMUX_PKG_HOMEPAGE=https://github.com/rabbitmq/rabbitmq-server
TERMUX_PKG_DESCRIPTION="Feature rich, multi-protocol messaging and streaming broker"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.4"
TERMUX_PKG_SRCURL=https://github.com/rabbitmq/rabbitmq-server/releases/download/v${TERMUX_PKG_VERSION}/rabbitmq-server-generic-unix-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7cc2ce2dea3c35fc1cf9ad48bca4a534e394af9e6c77c71d94eeb07775ec7832
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="erlang"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/rabbitmq-upgrade
bin/vmware-rabbitmq
lib/rabbitmq/lib/rabbitmq_server-${TERMUX_PKG_VERSION}/escript/rabbitmq-upgrade
lib/rabbitmq/lib/rabbitmq_server-${TERMUX_PKG_VERSION}/escript/vmware-rabbitmq
share/man/man8/rabbitmq-upgrade.8.gz
share/man/man8/rabbitmq-service.8.gz
share/man/man8/rabbitmq-echopid.8.gz
"
TERMUX_PKG_SERVICE_SCRIPT=("rabbitmq-server")
TERMUX_PKG_SERVICE_SCRIPT+=(
"if [ -f \"$TERMUX_ANDROID_HOME/.config/rabbitmq/rabbitmq.conf\" ]; then
	CONFIG=\"$TERMUX_ANDROID_HOME/.config/rabbitmq/rabbitmq.conf\"; else
	CONFIG=\"$TERMUX_PREFIX/etc/rabbitmq/rabbitmq.conf\"; fi\n\
	exec rabbitmq-server \$CONFIG 2>&1")

termux_step_make_install() {
	sed -i "s|RABBITMQ_HOME=.*|RABBITMQ_HOME=${TERMUX_PREFIX}/lib/rabbitmq/lib/rabbitmq_server-${TERMUX_PKG_VERSION}|g" sbin/rabbitmq-env
	sed -i "s|SYS_PREFIX=.*|SYS_PREFIX=${TERMUX_PREFIX}|g" sbin/rabbitmq-defaults

	mkdir -p "${TERMUX_PREFIX}"/lib/rabbitmq/lib/rabbitmq_server-"${TERMUX_PKG_VERSION}"
	mkdir -p "${TERMUX_PREFIX}"/etc/rabbitmq
	touch "${TERMUX_PREFIX}"/etc/rabbitmq/enabled_plugins

	cp -r plugins "${TERMUX_PREFIX}"/lib/rabbitmq/lib/rabbitmq_server-"${TERMUX_PKG_VERSION}"
	cp -r escript "${TERMUX_PREFIX}"/lib/rabbitmq/lib/rabbitmq_server-"${TERMUX_PKG_VERSION}"
	cp sbin/* "${TERMUX_PREFIX}"/bin
	cp -r share "${TERMUX_PREFIX}"
}
