TERMUX_PKG_HOMEPAGE=https://www.pureftpd.org/project/pure-ftpd
TERMUX_PKG_DESCRIPTION="Pure-FTPd is a free (BSD), secure, production-quality and standard-conformant FTP server"
TERMUX_PKG_VERSION=1.0.46
TERMUX_PKG_SRCURL=https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0609807335aade4d7145abdbb5cb05c9856a3e626babe90658cb0df315cb0a5c
TERMUX_PKG_DEPENDS="libcrypt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-ftpwho
--with-minimal
--with-nonroot
--with-puredb
ac_cv_lib_elf_elf_begin=no
ac_cv_lib_sodium_crypto_pwhash_scryptsalsa208sha256_str=no
"
TERMUX_PKG_CONFFILES="etc/pure-ftpd.conf"
