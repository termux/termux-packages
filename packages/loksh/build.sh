TERMUX_PKG_HOMEPAGE=https://github.com/dimkr/loksh
TERMUX_PKG_DESCRIPTION="A Linux port of OpenBSD's ksh"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
# Versions >6.7 fail with lots errors in NDK headers.
#
#  Example error:
#
#  In file included from ../src/subprojects/lolibc/include/sys/types.h:5:
#  /home/builder/.termux-build/_cache/android-r20-api-24-v3/bin/../sysroot/usr/include/time.h:96:1: error: unknown type name 'clock_t'
#  clock_t clock(void);
#  ^
#  /home/builder/.termux-build/_cache/android-r20-api-24-v3/bin/../sysroot/usr/include/time.h:100:25: error: unknown type name 'pid_t'
#  int clock_getcpuclockid(pid_t __pid, clockid_t* __clock) __INTRODUCED_IN(23);
TERMUX_PKG_VERSION=6.6
TERMUX_PKG_SRCURL=https://github.com/dimkr/loksh/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=97a020df82ceebe216c5a306e87360c5e3398d7403347aaff50978446ccb764d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
