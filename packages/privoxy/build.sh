TERMUX_PKG_HOMEPAGE=https://www.privoxy.org
TERMUX_PKG_DESCRIPTION="Non-caching web proxy with advanced filtering capabilities"
# License: GPL-2.0-or-later
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.GPLv3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.34
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/ijbswa/Sources/$TERMUX_PKG_VERSION%20%28stable%29/privoxy-$TERMUX_PKG_VERSION-stable-src.tar.gz
TERMUX_PKG_SHA256=e6ccbca1656f4e616b4657f8514e33a70f6697e9d7294356577839322a3c5d2c
# Termux-services adds the run scripts to TERMUX_PKG_CONFFILES. Those ones can
# not be copied in termux_step_post_massage so setup special variable for that
DEFAULT_CONFFILES="\
etc/privoxy/config
etc/privoxy/match-all.action
etc/privoxy/trust
etc/privoxy/user.action
etc/privoxy/user.filter
etc/privoxy/default.action
etc/privoxy/default.filter"
TERMUX_PKG_CONFFILES=$DEFAULT_CONFFILES
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_pcreposix_regcomp=no
--sysconfdir=$TERMUX_PREFIX/etc/privoxy
"
TERMUX_PKG_DEPENDS="pcre, libpcreposix, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=("privoxy"
"if [ -f \"$TERMUX_ANDROID_HOME/.config/privoxy/config\" ]; then \
CONFIG=\"$TERMUX_ANDROID_HOME/.config/privoxy/config\"; else \
CONFIG=\"$TERMUX_PREFIX/etc/privoxy/config\"; fi\n\
exec privoxy --no-daemon \$CONFIG 2>&1")

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	autoheader
	autoconf
}

termux_step_post_massage() {
	# copy default config files
	for f in $DEFAULT_CONFFILES; do
		cp "$TERMUX_PKG_SRCDIR/$(basename $f)" \
			"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$f"
	done
}
