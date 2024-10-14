TERMUX_PKG_HOMEPAGE=https://homepages.laas.fr/mallet/soft/shell/eltclsh
TERMUX_PKG_DESCRIPTION="Interactive shell for TCL programming language"
## per https://directory.fsf.org/wiki/Eltclsh and their ports http://robotpkg.openrobots.org/robotpkg/shell/eltclsh/ and embedded license headers in init.tcl
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="1.19"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.openrobots.org/distfiles/eltclsh/eltclsh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d4e4f7b79d89a5ed37dc7535d00ac3894fcf3ba33245e672d7a0753ede39d351
TERMUX_PKG_DEPENDS="libandroid-support, libedit, tcl"
TERMUX_PKG_BUILD_DEPENDS="tk"
TERMUX_PKG_SUGGESTS="tk"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_post_get_source() {
	sed -ne '/Copyright/,/ADVISED OF THE POSSIBILITY OF SUCH DAMAGE./s%^# %%p' "$TERMUX_PKG_SRCDIR/tcl/init.tcl" > "$TERMUX_PKG_SRCDIR/copyright"
}

termux_step_pre_configure() {
	CFLAGS+=" -DVOID=void"
}
