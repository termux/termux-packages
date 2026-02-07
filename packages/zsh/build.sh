TERMUX_PKG_HOMEPAGE=https://www.zsh.org
TERMUX_PKG_DESCRIPTION="Shell with lots of features"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENCE"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION=5.9
TERMUX_PKG_REVISION=9
TERMUX_PKG_SRCURL=https://www.zsh.org/pub/zsh-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9b8d1ecedd5b5e81fbf1918e876752a7dd948e05c1a0dba10ab863842d45acd5
TERMUX_PKG_BUILD_DEPENDS="pcre2"
TERMUX_PKG_DEPENDS="libandroid-support, libcap, ncurses, termux-tools, pcre2"
TERMUX_PKG_RECOMMENDS="command-not-found, zsh-completions"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gdbm
--enable-pcre
--enable-cap
--enable-etcdir=$TERMUX_PREFIX/etc
zsh_cv_path_wtmp=no
ac_cv_header_utmp_h=no
ac_cv_func_getpwuid=yes
ac_cv_func_setresgid=no
ac_cv_func_setresuid=no
"
TERMUX_PKG_CONFFILES="etc/zshrc"
TERMUX_PKG_BUILD_IN_SRC=true

# Remove hard link to bin/zsh as Android does not support hard links.
# We replace this with a symlink to offer the same functionality:
TERMUX_PKG_RM_AFTER_INSTALL="bin/zsh-${TERMUX_PKG_VERSION}"
# Remove compdef for Solaris `pkg` command:
TERMUX_PKG_RM_AFTER_INSTALL+="share/zsh/${TERMUX_PKG_VERSION}/functions/_pkg5"

termux_step_post_get_source() {
	# Fetch the Arch Linux cherry-picks for updating the zsh/pcre module to PCRE2.
	termux_download \
		'https://gitlab.archlinux.org/archlinux/packaging/packages/zsh/-/raw/main/0004-pcre2.patch' \
		"${TERMUX_SCRIPTDIR}/packages/zsh/pcre2.patch" \
		'ea68214d5be0514aa1b19e93fc9f44de878b9428e920227230a8fa3a75b0bd18'
}

termux_step_pre_configure() {

	autoreconf -fi
	## fix "largefile" for arithmetic larger than sint32
	## as zsh force disable the detection of these flags in its ./configure when running in a cross-build environment
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	zsh_cv_printf_has_lld=yes
	zsh_cv_rlim_t_is_longer=no
	zsh_cv_type_rlim_t_is_unsigned=yes
	"
	if [[ "$TERMUX_ARCH" = arm || "$TERMUX_ARCH" = i686 ]] ; then
		## this essentially attempts to add zsh_cv_64_bit_type="long long" in EXTRA_CONFIGURE_ARGS.
		## the space in argument to this flag make build script of termux
		## wrongly splitted the flag as separated flags
		## the reason is termux build script does not use ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS[@]}
		## (which is required to keep space in each flags by using an array) during shell expansion
		perl -0pe 's#zsh_cv_64_bit_type=no#zsh_cv_64_bit_type="long long"#ms' < configure > configure.newf
		cat configure.newf > configure
		rm configure.newf

		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		zsh_cv_off_t_is_64_bit=yes
		"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		zsh_cv_64_bit_type=long
		"
	fi

}

termux_step_post_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# INSTALL file: "For a non-dynamic zsh, the default is to compile the complete, compctl, zle,
	# computil, complist, sched, parameter, zleparameter and rlimits modules into the shell,
	# and you will need to edit config.modules to make any other modules available."
	# Since we build zsh non-dynamically (since dynamic loading doesn't work on Android when enabled),
	# we need to explicitly enable the additional modules we want.
	local modules=(
	'cap'           # - The cap module was requested in https://github.com/termux/termux-packages/issues/3102.
	'curses'        # - The curses module was requested by BrainDamage on IRC (#termux).
	'deltochar'     # - The deltochar module is used by grml-zshrc https://github.com/termux/termux-packages/issues/494.
	'files'         # - The files module is needed by `compinstall` https://github.com/termux/termux-packages/issues/61.
	'mapfile'       # - The mapfile module was requested in https://github.com/termux/termux-packages/issues/3116.
	'mathfunc'      # - The mathfunc module is used by grml-zshrc https://github.com/termux/termux-packages/issues/494.
	'newuser'       # - The newuser module was requested in https://github.com/termux/termux-packages/discussions/20603.
	'param_private' # - The param_private module was requested in https://github.com/termux/termux-packages/issues/7391.
	'pcre'          # - The pcre module expands on the regex modules capabilities and is used by several extensions.
	'regex'         # - The regex module seems to be used by several extensions.
	'socket'        # - The socket module was requested by BrainDamage on IRC (#termux).
	'stat'          # - The stat module is needed by zui https://github.com/termux/termux-packages/issues/2829.
	'system'        # - The system module is needed by zplug https://github.com/termux/termux-packages/issues/659.
	'zprof'         # - The zprof module was requested by BrainDamage on IRC (#termux).
	'zpty'          # - The zpty module is needed by zsh-async https://github.com/termux/termux-packages/issues/672.
	'zselect'       # - The zselect module is used by multiple plugins https://github.com/termux/termux-packages/issues/4939
	)
	for module in "${modules[@]}"; do
		perl -p -i -e "s|${module}.mdd link=no|${module}.mdd link=static|" "$TERMUX_PKG_BUILDDIR/config.modules"
	done
}

termux_step_post_make_install() {
	# /etc/zshrc - Run for interactive shells (http://zsh.sourceforge.net/Guide/zshguide02.html):
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" "$TERMUX_PKG_BUILDER_DIR/etc-zshrc" > "$TERMUX_PREFIX/etc/zshrc"

	# Remove upstream PCRE2 patch
	rm -f "${TERMUX_SCRIPTDIR}/packages/zsh/pcre2.patch"

	# Remove zsh.new/zsh.old/zsh-$version if any exists:
	rm -f "$TERMUX_PREFIX"/{zsh-*,zsh.*}

	# Create a symlink for zsh-$version instead of the hardlink:
	ln -sf "$TERMUX_PREFIX/bin/zsh" "$TERMUX_PREFIX/bin/zsh-$TERMUX_PKG_VERSION"
}
