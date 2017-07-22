TERMUX_PKG_HOMEPAGE=https://www.zsh.org
TERMUX_PKG_DESCRIPTION="Shell with lots of features"
_FOLDERVERSION=5.3
TERMUX_PKG_VERSION=${_FOLDERVERSION}.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/zsh/zsh/$_FOLDERVERSION/zsh-${_FOLDERVERSION}.tar.xz
TERMUX_PKG_SHA256=76f82cfd5ce373cf799a03b6f395283f128430db49202e3e3f512fb5a19d6f8a
TERMUX_PKG_RM_AFTER_INSTALL="bin/zsh-${_FOLDERVERSION}"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, termux-tools, command-not-found"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-etcdir=$TERMUX_PREFIX/etc --disable-gdbm --disable-pcre ac_cv_header_utmp_h=no"
TERMUX_PKG_CONFFILES="etc/zshrc"

# Below needed to force dynamically loaded binary modules, but does not currently work:
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" zsh_cv_shared_environ=yes"

termux_step_post_configure () {
	# INSTALL file: "For a non-dynamic zsh, the default is to compile the complete, compctl, zle,
	# computil, complist, sched, # parameter, zleparameter and rlimits modules into the shell,
	# and you will need to edit config.modules to make any other modules available."
	# Since we build zsh non-dynamically (since dynamic loading doesn't work on Android when enabled),
	# we need to explicitly enable the additional modules we want.
	# - The files module is needed by `compinstall` (https://github.com/termux/termux-packages/issues/61).
	# - The regex module seems to be used by several extensions.
	# - The curses, socket and zprof modules was desired by BrainDamage on IRC (#termux).
	# - The deltochar and mathfunc modules is used by grml-zshrc (https://github.com/termux/termux-packages/issues/494).
	# - The system module is needed by zplug (https://github.com/termux/termux-packages/issues/659).
	# - The zpty is needed by zsh-async (https://github.com/termux/termux-packages/issues/672).
	for module in files regex curses zprof socket system deltochar mathfunc zpty; do
		perl -p -i -e "s|${module}.mdd link=no|${module}.mdd link=static|" $TERMUX_PKG_BUILDDIR/config.modules
	done
}

termux_step_post_make_install () {
	# /etc/zshrc - Run for interactive shells (http://zsh.sourceforge.net/Guide/zshguide02.html):
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" $TERMUX_PKG_BUILDER_DIR/etc-zshrc > $TERMUX_PREFIX/etc/zshrc

	# Remove zsh.new/zsh.old/zsh-$version if any exists:
	rm -f $TERMUX_PREFIX/{zsh-*,zsh.*}

	# This should perhaps be done in a more general way? Doing it here
	# to silence "compaudit" warnings:
	chmod 700 $TERMUX_PREFIX/share/{zsh,zsh/$_FOLDERVERSION}
}

termux_step_create_debscripts () {
	# For already installed packages:
	echo "chmod 700 $TERMUX_PREFIX/share/zsh" > postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
