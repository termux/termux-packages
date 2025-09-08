TERMUX_PKG_HOMEPAGE="https://github.com/ros/console_bridge"
TERMUX_PKG_DESCRIPTION="A ROS-independent package for logging that seamlessly pipes into rosconsole/rosout for ROS-dependent packages"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Pooya Moradi <pvonmoradi@gmail.com>"
TERMUX_PKG_VERSION="1.0.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/ros/console_bridge/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=303a619c01a9e14a3c82eb9762b8a428ef5311a6d46353872ab9a904358be4a4
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"
