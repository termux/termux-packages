TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bash/
TERMUX_PKG_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAIN_VERSION=5.1
_PATCH_VERSION=0
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_SHA256=cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, ncurses, readline (>= 8.0), termux-tools"
TERMUX_PKG_RECOMMENDS="command-not-found"
TERMUX_PKG_BREAKS="bash-dev"
TERMUX_PKG_REPLACES="bash-dev"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-multibyte --without-bash-malloc --with-installed-readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_job_control_missing=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_sys_siglist=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_func_sigsetjmp=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_unusable_rtsigs=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_mbsnrtowcs=no"
# Use bash_cv_dev_fd=whacky to use /proc/self/fd instead of /dev/fd.
# After making this change process substitution such as in 'cat <(ls)' works.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_dev_fd=whacky"
# Bash assumes that getcwd is broken and provides a wrapper which
# does not work when not all parent directories up to root are
# accessible, which they are not under Android (/data). See
# - http://permalink.gmane.org/gmane.linux.embedded.yocto.general/25204
# - https://github.com/termux/termux-app/issues/200
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_getcwd_malloc=yes"

TERMUX_PKG_CONFFILES="etc/bash.bashrc etc/profile"

TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/bashbug.1 bin/bashbug"

termux_step_pre_configure() {
	declare -A PATCH_CHECKSUMS

	#PATCH_CHECKSUMS[001]=

	for PATCH_NUM in $(seq -f '%03g' ${_PATCH_VERSION}); do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/bash_patch_${PATCH_NUM}.patch
		termux_download \
			"https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}-patches/bash${_MAIN_VERSION/./}-$PATCH_NUM" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[$PATCH_NUM]}
		patch -p0 -i $PATCHFILE
	done
	unset PATCH_CHECKSUMS PATCHFILE PATCH_NUM
}

termux_step_post_make_install() {
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|" \
		$TERMUX_PKG_BUILDER_DIR/etc-profile > $TERMUX_PREFIX/etc/profile

	# /etc/bash.bashrc - System-wide .bashrc file for interactive shells. (config-top.h in bash source, patched to enable):
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|" \
		$TERMUX_PKG_BUILDER_DIR/etc-bash.bashrc > $TERMUX_PREFIX/etc/bash.bashrc
}
