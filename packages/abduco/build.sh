TERMUX_PKG_HOMEPAGE=http://www.brain-dump.org/projects/abduco/
TERMUX_PKG_DESCRIPTION="Clean and simple terminal session manager"
TERMUX_PKG_VERSION=0.6
TERMUX_PKG_SRCURL=http://www.brain-dump.org/projects/abduco/abduco-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libutil,dvtm"

export PREFIX=$TERMUX_PREFIX
CFLAGS+=" $CPPFLAGS"
