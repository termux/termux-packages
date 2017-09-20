TERMUX_PKG_HOMEPAGE=https://github.com/lipnitsk/libcue/
TERMUX_PKG_DESCRIPTION="CUE Sheet Parser Library"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SRCURL=https://github.com/lipnitsk/libcue/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=288ddd01e5f9e8f901d0c205d31507e4bdffd2540fa86073f2fe82de066d2abb
# To avoid picking up cross-compiled flex and bison:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBISON_EXECUTABLE=`which bison`
-DFLEX_EXECUTABLE=`which flex`
"
