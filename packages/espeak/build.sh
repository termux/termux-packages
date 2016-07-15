_MAJOR_VERSION=1.48
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.04
TERMUX_PKG_SRCURL=http://heanet.dl.sourceforge.net/project/espeak/espeak/espeak-${_MAJOR_VERSION}/espeak-${TERMUX_PKG_VERSION}-source.zip
TERMUX_PKG_FOLDERNAME=espeak-${TERMUX_PKG_VERSION}-source
TERMUX_PKG_HOMEPAGE=http://espeak.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Compact software speech synthesizer"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
        export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/src
}
