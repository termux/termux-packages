TERMUX_PKG_HOMEPAGE=https://github.com/lightningnetwork/lnd
TERMUX_PKG_DESCRIPTION="Lightning Network Daemon"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.8.2-beta
TERMUX_PKG_SRCURL=(https://github.com/lightningnetwork/lnd/archive/v${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/lightningnetwork/lnd/releases/download/v${TERMUX_PKG_VERSION}/vendor.tar.gz)
TERMUX_PKG_SHA256=(78f957f88843a30d8c2170d5c9bb3b347e8cbaaadd4e5c1674bb032a5a4bbbe6
                   2de9384297598a6be74ba971c69607f221379203a64217b622ddb7fa2d346b56)
TERMUX_PKG_DEPENDS="bitcoin"
TERMUX_PKG_CONFFILES="var/service/lnd/run var/service/lnd/log/run"
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
