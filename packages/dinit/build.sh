TERMUX_PKG_HOMEPAGE=https://github.com/davmac314/dinit
TERMUX_PKG_DESCRIPTION='Service monitoring / "init" system'
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.19.4
TERMUX_PKG_SRCURL=git+https://github.com/davmac314/dinit.git
TERMUX_PKG_GIT_BRANCH="r$TERMUX_PKG_VERSION"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="make, clang, m4"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-strip --disable-shutdown"

termux_step_host_build() {
	cp -r "$TERMUX_PKG_SRCDIR"/* .
	./configure --prefix="$TERMUX_PREFIX" --sbindir="$TERMUX_PREFIX/bin" "$TERMUX_PKG_EXTRA_CONFIGURE_ARGS"
	make -j"$(nproc)"
	cp build/tools/mconfig-gen "$TERMUX_PKG_SRCDIR/build/tools"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/share/bash-completion/completions"
	install -Dm600 contrib/shell-completion/bash/dinitctl "$TERMUX_PREFIX/share/bash-completion/completions"
	mkdir -p "$TERMUX_PREFIX/share/zsh/site-functions"
	install -Dm600 contrib/shell-completion/zsh/_dinit "$TERMUX_PREFIX/share/zsh/site-functions"
	mkdir -p "$TERMUX_PREFIX/share/fish/vendor_completions.d"
	install -Dm600 contrib/shell-completion/fish/dinitctl.fish "$TERMUX_PREFIX/share/fish/vendor_completions.d"
	mkdir -p "$TERMUX_PREFIX/etc/profile.d"
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR/start-dinit.sh" "$TERMUX_PREFIX/etc/profile.d"
	mkdir -p "$TERMUX_PREFIX/etc/dinit.d"
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/boot" "$TERMUX_PREFIX/etc/dinit.d"
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/local.target" "$TERMUX_PREFIX/etc/dinit.d"
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/network.target" "$TERMUX_PREFIX/etc/dinit.d"
}

termux_step_create_debscripts() {
	printf '%s\n' \
		"#!$TERMUX_PREFIX/bin/sh" \
		"mkdir -p \"$TERMUX_PREFIX/etc/dinit.d/config\"" \
		"chmod 700 \"$TERMUX_PREFIX/etc/dinit.d/config\"" \
		"mkdir -p \"$TERMUX_PREFIX/etc/dinit.d/service.d\"" \
		"chmod 700 \"$TERMUX_PREFIX/etc/dinit.d/service.d\"" \
		"mkdir -p \"$TERMUX_PREFIX/lib/dinit\"" \
		"chmod 700 \"$TERMUX_PREFIX/lib/dinit\"" \
		"mkdir -p \"$TERMUX_PREFIX/lib/dinit/pre\"" \
		"chmod 700 \"$TERMUX_PREFIX/lib/dinit/pre\"" \
		"mkdir -p \"$TERMUX_PREFIX/lib/dinit/stop\"" \
		"chmod 700 \"$TERMUX_PREFIX/lib/dinit/stop\"" \
		"mkdir -p \"$TERMUX_PREFIX/var/log/dinit\"" \
		"chmod 700 \"$TERMUX_PREFIX/var/log/dinit\"" \
		"echo \"To ensure services shutdown correctly, \"" \
		"echo \"please add 'dinitctl shutdown' to a file like '~/.bash_logout'\"" \
		"echo \"that executes when your login shell exits.\"" \
		"exit 0" > postinst
	chmod 0700 postinst
}
