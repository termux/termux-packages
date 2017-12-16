TERMUX_PKG_HOMEPAGE=http://www.columbia.edu/kermit/gkermit.html
TERMUX_PKG_DESCRIPTION="Simple, Portable, Free File Transfer Software for UNIX"
TERMUX_PKG_VERSION=1.00
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=ftp://kermit.columbia.edu/kermit/archives/gku100.tar.gz
TERMUX_PKG_SHA256=3dbe63291277c4795255343b48b860777fb0a160163d7e1d30b1ee68585593eb
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_MAKE_PROCESSES=1

termux_step_post_extract_package() {
        filename=$(basename "$TERMUX_PKG_SRCURL")
        local file="$TERMUX_PKG_CACHEDIR/$filename"
        tar xf "$file" -C "$TERMUX_PKG_SRCDIR"
}
