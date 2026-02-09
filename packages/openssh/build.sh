TERMUX_PKG_HOMEPAGE=https://www.openssh.com/
TERMUX_PKG_DESCRIPTION="Secure shell for logging into a remote machine"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="10.2p1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/openssh/openssh-portable/archive/refs/tags/V_$(sed 's/\./_/g; s/p/_P/g' <<< $TERMUX_PKG_VERSION).tar.gz
TERMUX_PKG_SHA256=8d3083bca4864cbc760bfcc3e67d86d401e27faa5eaafa1482c2316f5d5186b3
TERMUX_PKG_DEPENDS="krb5, ldns, libandroid-support, libedit, openssh-sftp-server, openssl, termux-auth, zlib"
TERMUX_PKG_SUGGESTS="termux-services"
TERMUX_PKG_CONFLICTS="dropbear"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/([0-9]+)_([0-9]+)_P([0-9]+)/\1.\2p\3/"
# Certain packages are not safe to build on device because their
# build.sh script deletes specific files in $TERMUX_PREFIX.
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
# --disable-strip to prevent host "install" command to use "-s", which won't work for target binaries:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-etc-default-login
--disable-lastlog
--disable-libutil
--disable-pututline
--disable-pututxline
--disable-strip
--disable-utmp
--disable-utmpx
--disable-wtmp
--disable-wtmpx
--sysconfdir=$TERMUX_PREFIX/etc/ssh
--with-cflags=-Dfd_mask=int
--with-ldns
--with-libedit
--with-mantype=man
--without-ssh1
--without-stackprotect
--with-pid-dir=$TERMUX_PREFIX/var/run
--with-privsep-path=$TERMUX_PREFIX/var/empty
--with-xauth=$TERMUX_PREFIX/bin/xauth
--with-kerberos5
--with-default-path=$TERMUX_PREFIX/bin
ac_cv_func_endgrent=yes
ac_cv_func_fmt_scaled=no
ac_cv_func_getlastlogxbyname=no
ac_cv_func_readpassphrase=no
ac_cv_func_strnvis=no
ac_cv_header_sys_un_h=yes
ac_cv_lib_crypt_crypt=no
ac_cv_search_getrrsetbyname=no
ac_cv_func_bzero=yes
ac_cv_member_struct_passwd_pw_gecos=no
"
# Configure script requires this variable to set prefixed path to program 'passwd'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="PATH_PASSWD_PROG=${TERMUX_PREFIX}/bin/passwd"

TERMUX_PKG_MAKE_INSTALL_TARGET="install-nokeys"
TERMUX_PKG_RM_AFTER_INSTALL="bin/slogin share/man/man1/slogin.1"
TERMUX_PKG_CONFFILES="etc/ssh/ssh_config etc/ssh/sshd_config"

termux_step_pre_configure() {
	autoreconf

	CPPFLAGS+=" -DHAVE_ATTRIBUTE__SENTINEL__=1 -DBROKEN_SETRESGID"
	LD=$CC # Needed to link the binaries
}

termux_step_post_configure() {
	# We need to remove this file before installing, since otherwise the
	# install leaves it alone which means no updated timestamps.
	rm -f "$TERMUX_PREFIX/etc/ssh/moduli"
	rm -f "$TERMUX_PREFIX/etc/ssh/ssh_config"
	rm -f "$TERMUX_PREFIX/etc/ssh/sshd_config"
}

termux_step_post_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR/source-ssh-agent.sh" "$TERMUX_PREFIX/libexec/source-ssh-agent.sh"
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR/wrap-ssh-agent.sh"   "$TERMUX_PREFIX/libexec/wrap-ssh-agent.sh"
	ln -s -f -T '../libexec/wrap-ssh-agent.sh'                   "$TERMUX_PREFIX/bin/ssha"
	ln -s -f -T '../libexec/wrap-ssh-agent.sh'                   "$TERMUX_PREFIX/bin/sftpa"
	ln -s -f -T '../libexec/wrap-ssh-agent.sh'                   "$TERMUX_PREFIX/bin/scpa"

	mkdir -p "$TERMUX_PREFIX/var/run"
	echo "OpenSSH needs this directory to put sshd.pid in" > "$TERMUX_PREFIX/var/run/README.openssh"
	# Install ssh-copy-id:
	echo "#!$TERMUX_PREFIX/bin/sh" > "$TERMUX_PREFIX/bin/ssh-copy-id"
	tail -n+2 "$TERMUX_PKG_SRCDIR/contrib/ssh-copy-id" >> "$TERMUX_PREFIX/bin/ssh-copy-id"
	sed -i -e "s|SANE_SH:-.*|SANE_SH:-$TERMUX_PREFIX/bin/bash}|g" "$TERMUX_PREFIX/bin/ssh-copy-id"
	chmod 0700 "$TERMUX_PREFIX/bin/ssh-copy-id"
	# Install ssh-copy-id's man page
	mkdir -p "$TERMUX_PREFIX/share/man/man1"
	cp "$TERMUX_PKG_SRCDIR/contrib/ssh-copy-id.1" "$TERMUX_PREFIX/share/man/man1"

	mkdir -p "$TERMUX_PREFIX/etc/ssh/"
	cp "$TERMUX_PKG_SRCDIR/moduli" "$TERMUX_PREFIX/etc/ssh/moduli"

	# Setup termux-services scripts
	mkdir -p "$TERMUX_PREFIX/var/service/sshd/log"
	ln -sf "$TERMUX_PREFIX/share/termux-services/svlogger" "$TERMUX_PREFIX/var/service/sshd/log/run"
	sed "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" "$TERMUX_PKG_BUILDER_DIR/sv/sshd.run.in" > "$TERMUX_PREFIX/var/service/sshd/run"
	chmod 700 "$TERMUX_PREFIX/var/service/sshd/run"
	touch "$TERMUX_PREFIX/var/service/sshd/down"

	mkdir -p "$TERMUX_PREFIX/var/service/ssh-agent/log"
	ln -sf "$TERMUX_PREFIX/share/termux-services/svlogger" "$TERMUX_PREFIX/var/service/ssh-agent/log/run"
	sed "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" "$TERMUX_PKG_BUILDER_DIR/sv/ssh-agent.run.in" > "$TERMUX_PREFIX/var/service/ssh-agent/run"
	chmod 700 "$TERMUX_PREFIX/var/service/ssh-agent/run"
	touch "$TERMUX_PREFIX/var/service/ssh-agent/down"
}

termux_step_post_massage() {
	# Directories referenced by Include in ssh_config and sshd_config.
	mkdir -p etc/ssh/ssh_config.d
	mkdir -p etc/ssh/sshd_config.d

	# Verify that we have man pages packaged.
	# https://github.com/termux/termux-packages/issues/1538
	local manpage
	local -a EXPECTED_MAN_PAGES=(
		'scp.1' 'ssh-add.1' 'ssh-agent.1' 'ssh-copy-id.1' 'ssh-keygen.1' 'ssh-keyscan.1' 'ssh.1'
		'moduli.5' 'ssh_config.5' 'sshd_config.5'
		'ssh-keysign.8' 'ssh-pkcs11-helper.8' 'ssh-sk-helper.8' 'sshd.8'
	)

	for manpage in "${EXPECTED_MAN_PAGES[@]}"; do
		[[ -f "share/man/man${manpage#*.}/$manpage.gz" ]] || termux_error_exit "Missing man page $manpage in openssh"
	done

	cd "$TERMUX_PKG_MASSAGEDIR/../subpackages/openssh-sftp-server/massage/$TERMUX_PREFIX" || termux_error_exit "Failed to check openssh-sftp-server man pages"
	for manpage in 'sftp.1' 'sftp-server.8'; do
		[[ -f "share/man/man${manpage#*.}/$manpage.gz" ]] || termux_error_exit "Missing man page $manpage in openssh"
	done
}

termux_step_create_debscripts() {
	{
	echo "#!$TERMUX_PREFIX/bin/sh"
	echo "mkdir -p \"$TERMUX_PREFIX/var/empty\""
	echo "mkdir -p \"\$HOME/.ssh\""
	echo "touch \"\$HOME/.ssh/authorized_keys\""
	echo "chmod 700 \"\$HOME/.ssh\""
	echo "chmod 600 \"\$HOME/.ssh/authorized_keys\""
	echo ""
	echo "for a in rsa ecdsa ed25519; do"
	echo "	KEYFILE=\"$TERMUX_PREFIX/etc/ssh/ssh_host_\${a}_key\""
	echo "	test ! -f \"\$KEYFILE\" && ssh-keygen -N '' -t \$a -f \"\$KEYFILE\""
	echo "done"
	echo ""
	echo "echo \"\""
	echo "echo \"If you plan to use the 'ssh-agent'\""
	echo "echo \"it is recommended to run it as a service.\""
	echo "echo \"Run 'pkg i termux-services'\""
	echo "echo \"to install the ('runit') service manager\""
	echo "echo \"\""
	echo "echo \"You can enable the ssh-agent service\""
	echo "echo \"using 'sv-enable ssh-agent'\""
	echo "echo \"You can also enable sshd to autostart\""
	echo "echo \"using 'sv-enable sshd'\""
	echo "exit 0"
	} > postinst
	chmod 0700 postinst
}
