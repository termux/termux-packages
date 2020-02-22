# http(s) link to package home page.
TERMUX_PKG_HOMEPAGE="https://github.com/RfidResearchGroup/proxmark3"

# One-line, short package description.
TERMUX_PKG_DESCRIPTION="The Swiss Army Knife of RFID Research"

# License.
TERMUX_PKG_LICENSE="GPL-2.0"

# Version.
TERMUX_PKG_VERSION=master

TERMUX_PKG_BUILD_IN_SRC="true"

termux_step_extract_package() {                                    local CHECKED_OUT_FOLDER=$TERMUX_PKG_CACHEDIR/checkout-$TERMUX_PKG_VERSION
        if [ ! -d $CHECKED_OUT_FOLDER ]; then                              local TMP_CHECKOUT=$TERMUX_PKG_TMPDIR/tmp-checkout
                rm -Rf $TMP_CHECKOUT
                mkdir -p $TMP_CHECKOUT
                                                                           git clone https://github.com/RfidResearchGroup/proxmark3.git $TMP_CHECKOUT
                mv $TMP_CHECKOUT $CHECKED_OUT_FOLDER
        fi

        mkdir $TERMUX_PKG_SRCDIR
        cd $TERMUX_PKG_SRCDIR
        cp -Rf $CHECKED_OUT_FOLDER/* .
}

termux_step_make() {
        make client
}
