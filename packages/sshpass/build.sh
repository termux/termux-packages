TERMUX_PKG_HOMEPAGE=http://sourceforge.net/projects/sshpass/
TERMUX_PKG_DESCRIPTION="Noninteractive ssh password provider"
TERMUX_PKG_VERSION=1.05
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/sshpass/sshpass/${TERMUX_PKG_VERSION}/sshpass-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes".
