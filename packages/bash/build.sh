TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bash/
TERMUX_PKG_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
TERMUX_PKG_DEPENDS="ncurses, readline, libandroid-support, termux-tools, command-not-found"
_MAIN_VERSION=4.4
_PATCH_VERSION=12
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_SHA256=d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb
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
	declare -A PATCH_CHECKSUMS
	PATCH_CHECKSUMS[001]=3e28d91531752df9a8cb167ad07cc542abaf944de9353fe8c6a535c9f1f17f0f
	PATCH_CHECKSUMS[002]=7020a0183e17a7233e665b979c78c184ea369cfaf3e8b4b11f5547ecb7c13c53
	PATCH_CHECKSUMS[003]=51df5a9192fdefe0ddca4bdf290932f74be03ffd0503a3d112e4199905e718b2
	PATCH_CHECKSUMS[004]=ad080a30a4ac6c1273373617f29628cc320a35c8cd06913894794293dc52c8b3
	PATCH_CHECKSUMS[005]=221e4b725b770ad0bb6924df3f8d04f89eeca4558f6e4c777dfa93e967090529
	PATCH_CHECKSUMS[006]=6a8e2e2a6180d0f1ce39dcd651622fb6d2fd05db7c459f64ae42d667f1e344b8
	PATCH_CHECKSUMS[007]=de1ccc07b7bfc9e25243ad854f3bbb5d3ebf9155b0477df16aaf00a7b0d5edaf
	PATCH_CHECKSUMS[008]=86144700465933636d7b945e89b77df95d3620034725be161ca0ca5a42e239ba
	PATCH_CHECKSUMS[009]=0b6bdd1a18a0d20e330cc3bc71e048864e4a13652e29dc0ebf3918bea729343c
	PATCH_CHECKSUMS[010]=8465c6f2c56afe559402265b39d9e94368954930f9aa7f3dfa6d36dd66868e06
	PATCH_CHECKSUMS[011]=dd56426ef7d7295e1107c0b3d06c192eb9298f4023c202ca2ba6266c613d170d
	PATCH_CHECKSUMS[012]=fac271d2bf6372c9903e3b353cb9eda044d7fe36b5aab52f21f3f21cd6a2063e

	for patch_number in `seq -f '%03g' ${_PATCH_VERSION}`; do
		PATCHFILE=$TERMUX_PKG_CACHEDIR/bash_patch_${patch_number}.patch
		termux_download \
			"https://mirrors.kernel.org/gnu/bash/bash-4.4-patches/bash44-$patch_number" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[$patch_number]}
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
