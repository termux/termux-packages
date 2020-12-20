TERMUX_PKG_HOMEPAGE=http://streamripper.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Records and splits streaming mp3 into tracks"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.64.6
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/streamripper/streamripper-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c1d75f2e9c7b38fd4695be66eff4533395248132f3cc61f375196403c4d8de42
TERMUX_PKG_DEPENDS="glib, libmad, libvorbis"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_pthread_pthread_create=yes"
