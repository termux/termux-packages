TERMUX_PKG_MAINTAINER="Muhammad Herdiansyah @konimex"
TERMUX_PKG_HOMEPAGE=https://github.com/dylanaraps/neofetch
TERMUX_PKG_DESCRIPTION="Simple system information script"
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_VERSION=1.9.0.1
# Use snapshot for now until 1.9.1 release, as 1.9 does not work on Termux:
TERMUX_PKG_SRCURL=https://github.com/dylanaraps/neofetch/archive/d2e82bc2458d20abd767dd067f37309276102511.zip
# TERMUX_PKG_SRCURL=https://github.com/dylanaraps/neofetch/archive/${TERMUX_PKG_VERSION}/neofetch-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4ddba4c3322ed5071ddb7205420db0bf9ad2e755f561202247b050e9b8846bff
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_FOLDERNAME=neofetch-d2e82bc2458d20abd767dd067f37309276102511
