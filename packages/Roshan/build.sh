TERMUX_PKG_NAME="roshan"
TERMUX_PKG_VERSION="1.0"
TERMUX_PKG_DESCRIPTION="A tool to generate text banners"
TERMUX_PKG_HOMEPAGE="https://github.com/Roshan-Editor/Roshan-Editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Roshan-Editor"
TERMUX_PKG_SRCURL="https://github.com/Roshan-Editor/Roshan-Editor/archive/refs/heads/main.zip"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -Dm755 banner.sh $TERMUX_PKG_PREFIX/bin/roshan
}
