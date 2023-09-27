TERMUX_PKG_HOMEPAGE=https://homepages.laas.fr/mallet/soft/shell/eltclsh
TERMUX_PKG_DESCRIPTION="Interactive shell for TCL programming language"
## per https://directory.fsf.org/wiki/Eltclsh and their ports http://robotpkg.openrobots.org/robotpkg/shell/eltclsh/ and embedded license headers in init.tcl
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION=1.18
TERMUX_PKG_SRCURL=https://www.openrobots.org/distfiles/eltclsh/eltclsh-"$TERMUX_PKG_VERSION".tar.gz
TERMUX_PKG_SHA256=77c242ebf384c893916d96a7382882af586c0cbf901f7fde33edd496a03cd9c6
TERMUX_PKG_DEPENDS="tcl, libedit"
TERMUX_PKG_BUILD_DEPENDS="tk"
TERMUX_PKG_SUGGESTS="tk"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	sed -ne '/Copyright/,/ADVISED OF THE POSSIBILITY OF SUCH DAMAGE./s%^# %%p' $TERMUX_PKG_SRCDIR/tcl/init.tcl > $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE
}
