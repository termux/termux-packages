TERMUX_PKG_HOMEPAGE=https://openvpn.net/easyrsa.html
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_DEPENDS="openssl-tool"
TERMUX_PKG_SRCURL=https://github.com/OpenVPN/easy-rsa/releases/download/$TERMUX_PKG_VERSION/EasyRSA-$TERMUX_PKG_VERSION.tgz
TERMUX_PKG_SHA256=dbdaf5b9444b99e0c5221fd4bcf15384c62380c1b63cea23d42239414d7b2d4e
TERMUX_PKG_CONFFILES="etc/easy-rsa/openssl-1.0.cnf, etc/easy-rsa/vars"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    install -D -m0755 easyrsa "${TERMUX_PREFIX}"/bin/easyrsa

    install -D -m0644 openssl-1.0.cnf "${TERMUX_PREFIX}"/etc/easy-rsa/openssl-1.0.cnf
    install -D -m0644 vars.example "${TERMUX_PREFIX}"/etc/easy-rsa/vars
    install -d -m0755 "${TERMUX_PREFIX}"/etc/easy-rsa/x509-types/
    install -m0644 x509-types/* "${TERMUX_PREFIX}"/etc/easy-rsa/x509-types/
}
