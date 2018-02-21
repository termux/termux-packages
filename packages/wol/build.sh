TERMUX_PKG_HOMEPAGE=http://sourceforge.net/projects/wake-on-lan/
TERMUX_PKG_DESCRIPTION="Program implementing Wake On LAN functionality"
TERMUX_PKG_VERSION=0.7.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/wake-on-lan/wol/${TERMUX_PKG_VERSION}/wol-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e0086c9b9811df2bdf763ec9016dfb1bcb7dba9fa6d7858725b0929069a12622
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_RM_AFTER_INSTALL="info/"

termux_step_pre_configure() {
	export ac_cv_func_mmap_fixed_mapped=yes
	export jm_cv_func_working_malloc=yes
	export ac_cv_func_alloca_works=yes
}
