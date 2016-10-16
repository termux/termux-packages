TERMUX_PKG_HOMEPAGE=http://www.sqlite.org/
TERMUX_PKG_DESCRIPTION="Software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=15
_SQLITE_PATCH=0
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_SRCURL=https://www.sqlite.org/2016/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-readline"
