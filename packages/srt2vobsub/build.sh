TERMUX_PKG_HOMEPAGE=https://srt2vobsub.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A command-line tool that generates a pair of .idx/.sub subtitle files from a textual subtitles file"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/srt2vobsub/srt2vobsub-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5f59319b300dc8629adf6debf94529f3f71ad8cc34bad5ead53a3cfc8d613c12
TERMUX_PKG_DEPENDS="bdsup2sub, ffmpeg, fontconfig-utils, imagemagick, mediainfo, python, python-pip"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_TARGET_DEPS="chardet, srt, wand"

termux_step_make_install() {
	install -Dm700 -T srt2vobsub.py $TERMUX_PREFIX/bin/srt2vobsub
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 srt2vobsub.1.gz
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		README defaults.conf langcodes.txt srt2vobsub.html
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
