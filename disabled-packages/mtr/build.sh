# Status: Needs hcreate()/hsearch()/hdestroy() in search.h,
#         which is not included in the NDK.

TERMUX_PKG_HOMEPAGE=https://github.com/traviscross/mtr
TERMUX_PKG_DESCRIPTION="Network diagnostic tool"
_DATE=20160609
# Note that the newdns branch is used.
_COMMIT=66de3ecbab28b054b868a73fbb57f30549d770ac
TERMUX_PKG_VERSION=0.86.${_DATE}
TERMUX_PKG_SRCURL=https://github.com/traviscross/mtr/archive/${_COMMIT}.zip
TERMUX_PKG_FOLDERNAME=mtr-$_COMMIT
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-gtk"

termux_step_pre_configure() {
	cd $TERMUX_PKG_SRCDIR
	./bootstrap.sh
}
