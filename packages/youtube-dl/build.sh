TERMUX_PKG_HOMEPAGE=https://rg3.github.io/youtube-dl/
TERMUX_PKG_DESCRIPTION="youtube-dl is a command-line program to download videos from YouTube.com and a few more sites."
TERMUX_PKG_VERSION=2016.12.22
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://yt-dl.org/downloads/${TERMUX_PKG_VERSION}/youtube-dl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_FOLDERNAME=youtube-dl
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
        python setup.py install --prefix=$TERMUX_PREFIX --force
}

termux_step_post_massage () {
        find . -path '*/__pycache__*' -delete
}
