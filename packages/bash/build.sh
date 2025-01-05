TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bash/
TERMUX_PKG_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAIN_VERSION=5.2
_PATCH_VERSION=26
TERMUX_PKG_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
TERMUX_PKG_SHA256=a139c166df7ff4471c5e0733051642ee5556c1cc8a4a78f145583c5c81ab32fb
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libandroid-support, libiconv, readline (>= 8.0), termux-tools"
TERMUX_PKG_RECOMMENDS="command-not-found, bash-completion"
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

	PATCH_CHECKSUMS[001]=f42f2fee923bc2209f406a1892772121c467f44533bedfe00a176139da5d310a
	PATCH_CHECKSUMS[002]=45cc5e1b876550eee96f95bffb36c41b6cb7c07d33f671db5634405cd00fd7b8
	PATCH_CHECKSUMS[003]=6a090cdbd334306fceacd0e4a1b9e0b0678efdbbdedbd1f5842035990c8abaff
	PATCH_CHECKSUMS[004]=38827724bba908cf5721bd8d4e595d80f02c05c35f3dd7dbc4cd3c5678a42512
	PATCH_CHECKSUMS[005]=ece0eb544368b3b4359fb8464caa9d89c7a6743c8ed070be1c7d599c3675d357
	PATCH_CHECKSUMS[006]=d1e0566a257d149a0d99d450ce2885123f9995e9c01d0a5ef6df7044a72a468c
	PATCH_CHECKSUMS[007]=2500a3fc21cb08133f06648a017cebfa27f30ea19c8cbe8dfefdf16227cfd490
	PATCH_CHECKSUMS[008]=6b4bd92fd0099d1bab436b941875e99e0cb3c320997587182d6267af1844b1e8
	PATCH_CHECKSUMS[009]=f95a817882eaeb0cb78bce82859a86bbb297a308ced730ebe449cd504211d3cd
	PATCH_CHECKSUMS[010]=c7705e029f752507310ecd7270aef437e8043a9959e4d0c6065a82517996c1cd
	PATCH_CHECKSUMS[011]=831b5f25bf3e88625f3ab315043be7498907c551f86041fa3b914123d79eb6f4
	PATCH_CHECKSUMS[012]=2fb107ce1fb8e93f36997c8b0b2743fc1ca98a454c7cc5a3fcabec533f67d42c
	PATCH_CHECKSUMS[013]=094b4fd81bc488a26febba5d799689b64d52a5505b63e8ee854f48d356bc7ce6
	PATCH_CHECKSUMS[014]=3ef9246f2906ef1e487a0a3f4c647ae1c289cbd8459caa7db5ce118ef136e624
	PATCH_CHECKSUMS[015]=ef73905169db67399a728e238a9413e0d689462cb9b72ab17a05dba51221358a
	PATCH_CHECKSUMS[016]=155853bc5bd10e40a9bea369fb6f50a203a7d0358e9e32321be0d9fa21585915
	PATCH_CHECKSUMS[017]=1c48cecbc9b7b4217990580203b7e1de19c4979d0bd2c0e310167df748df2c89
	PATCH_CHECKSUMS[018]=4641dd49dd923b454dd0a346277907090410f5d60a29a2de3b82c98e49aaaa80
	PATCH_CHECKSUMS[019]=325c26860ad4bba8558356c4ab914ac57e7b415dac6f5aae86b9b05ccb7ed282
	PATCH_CHECKSUMS[020]=b6fc252aeb95ce67c9b017d29d81e8a5e285db4bf20d4ec8cdca35892be5c01d
	PATCH_CHECKSUMS[021]=8334b88117ad047598f23581aeb0c66c0248cdd77abc3b4e259133aa307650cd
	PATCH_CHECKSUMS[022]=78b5230a49594ec30811e72dcd0f56d1089710ec7828621022d08507aa57e470
	PATCH_CHECKSUMS[023]=af905502e2106c8510ba2085aa2b56e64830fc0fdf6ee67ebb459ac11696dcd3
	PATCH_CHECKSUMS[024]=971534490117eb05d97d7fd81f5f9d8daf927b4d581231844ffae485651b02c3
	PATCH_CHECKSUMS[025]=5138f487e7cf71a6323dc81d22419906f1535b89835cc2ff68847e1a35613075
	PATCH_CHECKSUMS[026]=96ee1f549aa0b530521e36bdc0ba7661602cfaee409f7023cac744dd42852eac

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
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|g" \
		$TERMUX_PKG_BUILDER_DIR/etc-profile > $TERMUX_PREFIX/etc/profile

	# /etc/bash.bashrc - System-wide .bashrc file for interactive shells. (config-top.h in bash source, patched to enable):
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_HOME@|$TERMUX_ANDROID_HOME|g" \
		$TERMUX_PKG_BUILDER_DIR/etc-bash.bashrc > $TERMUX_PREFIX/etc/bash.bashrc
}
