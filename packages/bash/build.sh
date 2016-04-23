TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/bash/
TERMUX_PKG_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
TERMUX_PKG_DEPENDS="ncurses, readline, libandroid-support, termux-tools, command-not-found"
_MAIN_VERSION=4.3
_PATCH_VERSION=42
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_BUILD_REVISION=8
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-multibyte --without-bash-malloc --with-installed-readline ac_cv_header_grp_h=no ac_cv_header_pwd_h=no ac_cv_rl_version=6.3"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_job_control_missing=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_sys_siglist=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_func_sigsetjmp=present"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_unusable_rtsigs=no"
# Use bash_cv_dev_fd=whacky to use /proc/self/fd instead of /dev/fd.
# After making this change process substitution such as in 'cat <(ls)' works.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" bash_cv_dev_fd=whacky"

TERMUX_PKG_RM_AFTER_INSTALL="share/man/man1/bashbug.1 bin/bashbug"

termux_step_pre_configure () {
        cd $TERMUX_PKG_SRCDIR
	for patch_number in `seq -f '%03g' ${_PATCH_VERSION}`; do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/bash_patch_${patch_number}.patch
		test ! -f $PATCHFILE && curl "http://ftp.gnu.org/gnu/bash/bash-4.3-patches/bash43-$patch_number" > $PATCHFILE
		patch -p0 -i $PATCHFILE
	done
}

termux_step_post_make_install () {
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" $TERMUX_PKG_BUILDER_DIR/etc-profile > $TERMUX_PREFIX/etc/profile
	# /etc/bash.bashrc - System-wide .bashrc file for interactive shells. (config-top.h in bash source, patched to enable):
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" $TERMUX_PKG_BUILDER_DIR/etc-bash.bashrc > $TERMUX_PREFIX/etc/bash.bashrc
}
