TERMUX_PKG_VERSION=1.48
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/espeak/espeak/espeak-${TERMUX_PKG_VERSION}/espeak-${TERMUX_PKG_VERSION}.02-source.zip
TERMUX_PKG_FOLDERNAME=espeak-${TERMUX_PKG_VERSION}.01-source
TERMUX_PKG_HOMEPAGE=http://espeak.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Compact open source software speech synthesizer"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
        export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_BUILDDIR/src
}
