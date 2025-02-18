TERMUX_PKG_HOMEPAGE=https://www.openssh.com/
TERMUX_PKG_DESCRIPTION="Secure shell for logging into a remote machine"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="9.9p2"
TERMUX_PKG_SRCURL=https://github.com/openssh/openssh-portable/archive/refs/tags/V_$(sed 's/\./_/g; s/p/_P/g' <<< $TERMUX_PKG_VERSION).tar.gz
TERMUX_PKG_SHA256=082dffcf651b9db762ddbe56ca25cc75a0355a7bea41960b47f3c139974c5e3e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="krb5, ldns, libandroid-support, libedit, openssh-sftp-server, openssl, termux-auth, zlib"
TERMUX_PKG_CONFLICTS="dropbear"
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
"
# Configure script require this variable to set
# prefixed path to program 'passwd'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="PATH_PASSWD_PROG=${TERMUX_PREFIX}/bin/passwd"

TERMUX_PKG_MAKE_INSTALL_TARGET="install-nokeys"
TERMUX_PKG_RM_AFTER_INSTALL="bin/slogin share/man/man1/slogin.1"
TERMUX_PKG_CONFFILES="etc/ssh/ssh_config etc/ssh/sshd_config"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	autoreconf

	CPPFLAGS+=" -DHAVE_ATTRIBUTE__SENTINEL__=1 -DBROKEN_SETRESGID"
	LD=$CC # Needed to link the binaries
}

termux_step_post_configure() {
	# We need to remove this file before installing, since otherwise the
	# install leaves it alone which means no updated timestamps.
	rm -f $TERMUX_PREFIX/etc/ssh/moduli
	rm -f $TERMUX_PREFIX/etc/ssh/ssh_config
	rm -f $TERMUX_PREFIX/etc/ssh/sshd_config
}

termux_step_post_make_install() {
	install -Dm700 $TERMUX_PKG_BUILDER_DIR/source-ssh-agent.sh $TERMUX_PREFIX/bin/source-ssh-agent
	install -Dm700 $TERMUX_PKG_BUILDER_DIR/ssh-with-agent.sh $TERMUX_PREFIX/bin/ssha
	install -Dm700 $TERMUX_PKG_BUILDER_DIR/sftp-with-agent.sh $TERMUX_PREFIX/bin/sftpa
	install -Dm700 $TERMUX_PKG_BUILDER_DIR/scp-with-agent.sh $TERMUX_PREFIX/bin/scpa

	# Install ssh-copy-id:
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		$TERMUX_PKG_BUILDER_DIR/ssh-copy-id.sh \
		> $TERMUX_PREFIX/bin/ssh-copy-id
	chmod +x $TERMUX_PREFIX/bin/ssh-copy-id

	mkdir -p $TERMUX_PREFIX/var/run
	echo "OpenSSH needs this folder to put sshd.pid in" >> $TERMUX_PREFIX/var/run/README.openssh

	mkdir -p $TERMUX_PREFIX/etc/ssh/
	cp $TERMUX_PKG_SRCDIR/moduli $TERMUX_PREFIX/etc/ssh/moduli

	# Setup termux-services scripts
	mkdir -p $TERMUX_PREFIX/var/service/sshd/log
	ln -sf $TERMUX_PREFIX/share/termux-services/svlogger $TERMUX_PREFIX/var/service/sshd/log/run
	sed "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" $TERMUX_PKG_BUILDER_DIR/sv/sshd.run.in > $TERMUX_PREFIX/var/service/sshd/run
	chmod 700 $TERMUX_PREFIX/var/service/sshd/run
	touch $TERMUX_PREFIX/var/service/sshd/down

	mkdir -p $TERMUX_PREFIX/var/service/ssh-agent/log
	ln -sf $TERMUX_PREFIX/share/termux-services/svlogger $TERMUX_PREFIX/var/service/ssh-agent/log/run
	sed "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" $TERMUX_PKG_BUILDER_DIR/sv/ssh-agent.run.in > $TERMUX_PREFIX/var/service/ssh-agent/run
	chmod 700 $TERMUX_PREFIX/var/service/ssh-agent/run
	touch $TERMUX_PREFIX/var/service/ssh-agent/down
}

termux_step_post_massage() {
	# Directories referenced by Include in ssh_config and sshd_config.
	mkdir -p etc/ssh/ssh_config.d
	mkdir -p etc/ssh/sshd_config.d

	# Verify that we have man pages packaged (#1538).
	local manpage
	for manpage in ssh-keyscan.1 ssh-add.1 scp.1 ssh-agent.1 ssh.1; do
		if [ ! -f share/man/man1/$manpage.gz ]; then
			termux_error_exit "Missing man page $manpage"
		fi
	done
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p \$PREFIX/var/empty" >> postinst
	echo "mkdir -p \$HOME/.ssh" >> postinst
	echo "touch \$HOME/.ssh/authorized_keys" >> postinst
	echo "chmod 700 \$HOME/.ssh" >> postinst
	echo "chmod 600 \$HOME/.ssh/authorized_keys" >> postinst
	echo "" >> postinst
	echo "for a in rsa ecdsa ed25519; do" >> postinst
	echo "	  KEYFILE=$TERMUX_PREFIX/etc/ssh/ssh_host_\${a}_key" >> postinst
	echo "	  test ! -f \$KEYFILE && ssh-keygen -N '' -t \$a -f \$KEYFILE" >> postinst
	echo "done" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" newest-tag)"
	[[ -z "${latest_tag}" ]] && termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	local version="$(echo ${latest_tag} | sed -E 's/V_([0-9]+)_([0-9]+)_P([0-9]+)/\1.\2p\3/')"
	termux_pkg_upgrade_version $version
}
