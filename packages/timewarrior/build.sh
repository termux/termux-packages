# Problem: In src/libshared/src/FS.cpp the <glob.h> file is included
#          which is not provided by the Android platform. In Termux
#          we have it in $TERMUX_PREFIX/include, which sould be found
#          by DCMAKE_FIND_ROOT_PATH=$TERMUX_PREFIX? Works in
#          taskwarrior for the src/FS.cpp file there.
TERMUX_PKG_HOMEPAGE=https://tasktools.org/projects/timewarrior.html
TERMUX_PKG_DESCRIPTION="Command-line time tracker"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=http://taskwarrior.org/download/timew-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

