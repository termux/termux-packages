TERMUX_PKG_HOMEPAGE=https://gh05t-hunter5.github.io/Tony-Linux/color 
TERMUX_PKG_DESCRIPTION="Terminal Text Styling Utility for changing text and background colors"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Tony-Linux/color

termux_step_make_install() {
    mkdir -p $TERMUX_PREFIX/bin
    cp color $TERMUX_PREFIX/bin/color
    chmod +x $TERMUX_PREFIX/bin/color
}

termux_step_create_debscripts() {
    cat <<- EOF > ./postinst
    #!$TERMUX_PREFIX/bin/sh
    if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
        if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
            update-alternatives --install \
                $TERMUX_PREFIX/bin/color color $TERMUX_PREFIX/bin/color 25
        fi
    fi
    EOF

    cat <<- EOF > ./prerm
    #!$TERMUX_PREFIX/bin/sh
    if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
        if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
            update-alternatives --remove color $TERMUX_PREFIX/bin/color
        fi
    fi
    EOF
}
