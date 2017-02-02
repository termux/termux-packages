TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=16
_SQLITE_PATCH=2
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_SRCURL=https://www.sqlite.org/2017/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
TERMUX_PKG_CHECKTYPE=SHA256
TERMUX_PKG_CHECKSUM=65cc0c3e9366f50c0679c5ccd31432cea894bc4a3e8947dabab88c8693263615
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-readline"
