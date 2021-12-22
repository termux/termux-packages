TERMUX_PKG_HOMEPAGE=http://www.sbcl.org/
TERMUX_PKG_DESCRIPTION="Steel Bank Common Lisp"
TERMUX_PKG_VERSION=1.3.9
TERMUX_PKG_SRCURL=http://prdownloads.sourceforge.net/sbcl/sbcl-${TERMUX_PKG_VERSION}-source.tar.bz2

termux_step_pre_configure() {
	local SBCL_HOST_TARFILE=$TERMUX_PKG_CACHEDIR/sbcl-host-${TERMUX_PKG_VERSION}.tar.bz2
	if [ ! -f $SBCL_HOST_TARFILE ]; then
		curl -o $SBCL_HOST_TARFILE -L http://downloads.sourceforge.net/project/sbcl/sbcl/${TERMUX_PKG_VERSION}/sbcl-${TERMUX_PKG_VERSION}-x86-64-linux-binary.tar.bz2
		cd $TERMUX_PKG_TMPDIR
		tar xf $SBCL_HOST_TARFILE
		cd sbcl-${TERMUX_PKG_VERSION}-x86-64-linux
		INSTALL_ROOT=$TERMUX_PKG_CACHEDIR/sbcl-host sh install.sh
	fi
	export PATH=$PATH:$TERMUX_PKG_CACHEDIR/sbcl-host/bin
	export SBCL_HOME=$TERMUX_PKG_CACHEDIR/sbcl-host/lib/sbcl
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR
	sh make.sh --prefix=$TERMUX_PREFIX
}
