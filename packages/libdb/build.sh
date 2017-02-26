TERMUX_PKG_HOMEPAGE=https://www.oracle.com/database/berkeley-db
TERMUX_PKG_DESCRIPTION="The Berkeley Database (Berkeley DB) is a programmatic toolkit that provides embedded database support"
TERMUX_PKG_VERSION=5.3.28
# Oracle needs an user account to download packages, so we use a mirror
TERMUX_PKG_SRCURL=https://download.freenas.org/distfiles/bdb/db-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR/build_unix
    TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/dist
}

termux_step_post_massage() {
    cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX
    rm -rf docs
}