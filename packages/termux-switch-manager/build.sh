TERMUX_PKG_HOMEPAGE=https://gist.github.com/DevMasterLinux/ba96cfb7ec6b7e0960f400a1b0d80a24
TERMUX_PKG_DESCRIPTION="A Tool to Switch the Package Manager fast and safe"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@DevMasterLinux"
TERMUX_PKG_VERSION="1.0"
TERMUX_PKG_SRCURL=https://gist.githubusercontent.com/DevMasterLinux/ba96cfb7ec6b7e0960f400a1b0d80a24/raw/0f646aff1e9ffed3bb742143ae8fdccfe34c0d7c/termux-bootstrap.sh
TERMUX_PKG_SHA256=9e74463bac19448e9bcadf623785baf61b7c3aaa220763541a166107c55eaf4a

termux_step_make_install() {
    # Download the script from the source URL
    curl -o termux-bootstrap.sh $TERMUX_PKG_SRCURL

    # Make the script executable
    chmod +x termux-bootstrap.sh

    # Rename the script to termux-switch-manager
    mv termux-bootstrap.sh termux-switch-manager
}

termux_step_create_debscripts() {
    # No need for pre/post installation scripts
    return 0
}

