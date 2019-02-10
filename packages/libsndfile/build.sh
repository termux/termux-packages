TERMUX_PKG_HOMEPAGE=http://www.mega-nerd.com/libsndfile
TERMUX_PKG_DESCRIPTION="Library for reading/writing audio files"
TERMUX_PKG_LICENSE="LGPL-2.0"
# Use a git master snapshot until 1.0.29 is released:
TERMUX_PKG_VERSION=1.0.29~pre1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/erikd/libsndfile/archive/826d5296da54c016e3cb0f7f00de3b9e295b9c4a.zip
TERMUX_PKG_SHA256=84651201a8468c448f1fd172a48ccf47f3761d23fd0f59bcaaf908050e9eeb7c
TERMUX_PKG_DEPENDS="libflac, libvorbis"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-sqlite --disable-alsa"
TERMUX_PKG_RM_AFTER_INSTALL="bin/ share/man/man1/"

termux_step_pre_configure() {
	sh autogen.sh
}
