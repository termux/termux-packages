TERMUX_PKG_HOMEPAGE=https://github.com/lightningnetwork/lnd
TERMUX_PKG_DESCRIPTION="Lightning Network Daemon"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.7.1-beta
TERMUX_PKG_SRCURL=(https://github.com/lightningnetwork/lnd/archive/v${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/lightningnetwork/lnd/releases/download/v${TERMUX_PKG_VERSION}/vendor.tar.gz)
TERMUX_PKG_SHA256=(13e1ef723a1dc0fc5af9fe48ca5766417e3c7de48c87a082a8fe83a6b38bb6a4
                   3bbfa000e2b4c7702f92d24235b5a098f37fd7b5830ca42586678f03d7cf9da3)
TERMUX_PKG_DEPENDS="bitcoin,termux-services"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
    termux_setup_golang

    GO111MODULE=on go build -tags linux -v -mod=vendor -ldflags "-X github.com/lightningnetwork/lnd/build.Commit=v$TERMUX_PKG_VERSION" ./cmd/lnd
    GO111MODULE=on go build -tags linux -v -mod=vendor -ldflags "-X github.com/lightningnetwork/lnd/build.Commit=v$TERMUX_PKG_VERSION" ./cmd/lncli
}

termux_step_make_install() {
    install -Dm700 lnd lncli "$TERMUX_PREFIX"/bin/
}

termux_step_post_make_install() {
    mkdir -p $TERMUX_PREFIX/var/service
    cd $TERMUX_PREFIX/var/service
    mkdir -p lnd/log
    echo "#!$TERMUX_PREFIX/bin/sh" > lnd/run
    echo 'exec lnd 2>&1' >> lnd/run
    chmod +x lnd/run
    touch lnd/down

    ln -sf $TERMUX_PREFIX/share/termux-services/svlogger lnd/log/run
}
