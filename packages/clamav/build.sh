TERMUX_PKG_HOMEPAGE=https://www.clamav.net/
TERMUX_PKG_DESCRIPTION="Anti-virus toolkit for Unix"
TERMUX_PKG_VERSION=0.100.2
TERMUX_PKG_SRCURL=https://www.clamav.net/downloads/production/clamav-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4a2e4f0cd41e62adb5a713b4a1857c49145cd09a69957e6d946ecad575206dd6
TERMUX_PKG_DEPENDS="json-c, libbz2, libcurl, libltdl, libxml2, pcre2"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=${TERMUX_PREFIX}/etc/clamav
--with-libcurl=${TERMUX_PREFIX}
--with-pcre=${TERMUX_PREFIX}
--with-libjson=${TERMUX_PREFIX}
--with-openssl=${TERMUX_PREFIX}
--with-xml=${TERMUX_PREFIX}
--with-zlib=${TERMUX_PREFIX}
--disable-llvm
--disable-dns
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man5/clamav-milter.conf.5
share/man/man8/clamav-milter.8
"

termux_step_pre_configure() {
    export LIBS="-llog"
}

termux_step_post_make_install() {
    install -Dm600 "${TERMUX_PKG_BUILDER_DIR}/freshclam.conf" \
        "${TERMUX_PREFIX}/etc/clamav/freshclam.conf"
}

termux_step_post_massage() {
    mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/lib/clamav"
    mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/var/log/clamav"
}
