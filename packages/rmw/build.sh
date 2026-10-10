TERMUX_PKG_HOMEPAGE=https://theimpossibleastronaut.com/rmw-website/
TERMUX_PKG_DESCRIPTION="A command-line recycle bin utility (ReMove to Waste)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Jules Amonith <examosa@fastmail.com>"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_SRCURL="https://github.com/theimpossibleastronaut/rmw/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=dc3f49e26b2f6ff15ac56aebe068bbc158435102ffa8ff54841377dba7a963a5
TERMUX_PKG_DEPENDS="glib, ncurses"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dwith-reflink=false -Dnls=false"
