TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=18
_SQLITE_PATCH=0
TERMUX_PKG_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
TERMUX_PKG_SRCURL=https://www.sqlite.org/2017/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
TERMUX_PKG_SHA256=3757612463976e7d08c5e9f0af3021613fc24bbcfe1c51197d6776b9ece9ac5c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-readline"
