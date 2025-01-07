TERMUX_PKG_HOMEPAGE=https://cfengine.com/
TERMUX_PKG_DESCRIPTION="CFEngine is a configuration management technology"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:3.24.0
TERMUX_PKG_SRCURL=git+https://github.com/cfengine/core
TERMUX_PKG_SHA256=f915364942bb19936e3f5c04ad1551ff44106717ebbd7e5f7b25eefc6f8efd2b
# "-build[n]" suffix in tag name is not a part of version string.
_CFENGINE_GIT_TAG_SUFFIX=
TERMUX_PKG_GIT_BRANCH=${TERMUX_PKG_VERSION#*:}${_CFENGINE_GIT_TAG_SUFFIX}
TERMUX_PKG_DEPENDS="libandroid-glob, liblmdb, libxml2, libyaml, openssl, pcre2"
# core doesn't work with out-of-tree builds
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-workdir=$TERMUX_PREFIX/var/lib/cfengine
--without-pam
--without-selinux-policy
--without-systemd-service
--with-lmdb=$TERMUX_PREFIX
--with-openssl=$TERMUX_PREFIX
--with-yaml=$TERMUX_PREFIX
--with-pcre2=$TERMUX_PREFIX
--with-prefix=$TERMUX_PREFIX
--with-libxml2=$TERMUX_PREFIX
"

termux_step_post_get_source() {
	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files. \nExpected ${TERMUX_PKG_SHA256}\nActual ${s% *}"
	fi

	: ${_CFENGINE_GIT_TAG_SUFFIX:=}
	local _MASTERFILES_VERSION=${TERMUX_PKG_VERSION#*:}${_CFENGINE_GIT_TAG_SUFFIX}
	local _MASTERFILES_SRCURL=https://github.com/cfengine/masterfiles/archive/${_MASTERFILES_VERSION}.zip
	local _MASTERFILES_SHA256=be580ae951857e3f79b0c3f7cb6ca66e866dd9fcb2fb21eaf9c3a6305f328007

	local _MASTERFILES_FILE=${TERMUX_PKG_CACHEDIR}/masterfiles-${_MASTERFILES_VERSION}.zip
	termux_download \
		${_MASTERFILES_SRCURL} \
		${_MASTERFILES_FILE} \
		${_MASTERFILES_SHA256}
	local d=$(unzip -qql ${_MASTERFILES_FILE} | \
			head -n1 | tr -s ' ' | cut -d' ' -f5-)
	unzip -q ${_MASTERFILES_FILE}
	mv ${d} masterfiles
}

termux_step_pre_configure() {
	export EXPLICIT_VERSION=${TERMUX_PKG_VERSION#*:}
	export LDFLAGS+=" -landroid-glob"
	NO_CONFIGURE=1 ./autogen.sh
}

termux_step_post_make_install() {
	cd masterfiles
	./autogen.sh \
		--prefix=$TERMUX_PREFIX/var/lib/cfengine \
		--bindir=$TERMUX_PREFIX/bin
	make install
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		# Generate a host key
		if [ ! -f $TERMUX_PREFIX/var/lib/cfengine/ppkeys/localhost.priv ]; then
			$TERMUX_PREFIX/bin/cf-key >/dev/null || :
		fi
	EOF
}
