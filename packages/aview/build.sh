TERMUX_PKG_HOMEPAGE=https://aa-project.sourceforge.net/aview/
TERMUX_PKG_DESCRIPTION="High quality ascii-art image browser and animation player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.0rc1
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/aa-project/aview/aview-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=42d61c4194e8b9b69a881fdde698c83cb27d7eda59e08b300e73aaa34474ec99
TERMUX_PKG_DEPENDS="aalib (>> 1.4rc5-8)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
"
