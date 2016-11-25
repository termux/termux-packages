TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bash/
TERMUX_PKG_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
TERMUX_PKG_DEPENDS="ncurses, readline, libandroid-support, termux-tools, command-not-found"
_MAIN_VERSION=4.4
_PATCH_VERSION=5
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-multibyte --without-bash-malloc --with-installed-readline ac_cv_header_grp_h=no ac_cv_rl_version=7.0"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_job_control_missing=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_sys_siglist=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_func_sigsetjmp=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_unusable_rtsigs=no"
# Use bash_cv_dev_fd=whacky to use /proc/self/fd instead of /dev/fd.
# After making this change process substitution such as in 'cat <(ls)' works.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_dev_fd=whacky"
# Bash assumes that getcwd is broken and provides a wrapper which
# does not work when not all parent directories up to root are
# accessible, which they are no under Android (/data). See
# - http://permalink.gmane.org/gmane.linux.embedded.yocto.general/25204
# - https://github.com/termux/termux-app/issues/200
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_getcwd_malloc=yes"

TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/bashbug.1 bin/bashbug"

termux_step_pre_configure () {
        cd $TERMUX_PKG_SRCDIR
	for patch_number in `seq -f '%03g' ${_PATCH_VERSION}`; do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/bash_patch_${patch_number}.patch
		test ! -f $PATCHFILE && curl "https://mirrors.kernel.org/gnu/bash/bash-4.4-patches/bash44-$patch_number" > $PATCHFILE
		patch -p0 -i $PATCHFILE
	done
}

termux_step_post_make_install () {
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" $TERMUX_PKG_BUILDER_DIR/etc-profile > $TERMUX_PREFIX/etc/profile
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		$TERMUX_PKG_BUILDER_DIR/etc-profile | \
		sed "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|" > \
		$TERMUX_PREFIX/etc/profile
	# /etc/bash.bashrc - System-wide .bashrc file for interactive shells. (config-top.h in bash source, patched to enable):
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		$TERMUX_PKG_BUILDER_DIR/etc-bash.bashrc > \
		$TERMUX_PREFIX/etc/bash.bashrc
}
