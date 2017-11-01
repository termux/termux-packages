TERMUX_PKG_HOMEPAGE=https://www.zsh.org
TERMUX_PKG_DESCRIPTION="Shell with lots of features"
TERMUX_PKG_VERSION=5.4.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=62f5d034d5f4bbaa7a6b08f49aeb16a9c7dc327fd9b3d5a8017d08c66b1beb92
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/zsh-${TERMUX_PKG_VERSION}.tar.xz
# Remove hard link to bin/zsh as Android does not support hard links:
TERMUX_PKG_RM_AFTER_INSTALL="bin/zsh-${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, termux-tools, command-not-found"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_utmp_h=no
--disable-gdbm
--disable-pcre
--enable-etcdir=$TERMUX_PREFIX/etc
"
TERMUX_PKG_CONFFILES="etc/zshrc"

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
}
