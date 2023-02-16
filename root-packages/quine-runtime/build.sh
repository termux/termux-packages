TERMUX_PKG_HOMEPAGE=https://github.com/shaunmulligan/quine-runtime
TERMUX_PKG_DESCRIPTION="Runtime scripts and config for quineOS"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@shaunmulligan"
TERMUX_PKG_VERSION=0.0.1
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=git+https://github.com/shaunmulligan/quine-runtime.git
#TERMUX_PKG_SRCURL=git+file:///home/shaunmulligan/quine-runtime.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
    echo "installing scripts for quineOS to /opt"
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/docker.sh ${TERMUX_PREFIX}/opt/docker.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/network.sh ${TERMUX_PREFIX}/opt/network.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/canbus.sh ${TERMUX_PREFIX}/opt/canbus.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/build-tini.sh ${TERMUX_PREFIX}/opt/build-tini.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/find-serial.sh ${TERMUX_PREFIX}/opt/find-serial.sh
    install -Dm 777 ${TERMUX_PKG_SRCDIR}/scripts/first-run.sh ${TERMUX_PREFIX}/opt/first-run.sh

    install -Dm 777 ${TERMUX_PKG_SRCDIR}/bashrc ${TERMUX_PREFIX}/etc/bash.bashrc
}
