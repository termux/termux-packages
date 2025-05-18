# Contributor: @Neo-Oli
TERMUX_PKG_HOMEPAGE=https://otr.cypherpunks.ca
TERMUX_PKG_DESCRIPTION="Off-the-Record (OTR) Messaging allows you to have private conversations over instant messaging by providing: Encryption, Authentication, Deniability, Perfect forward secrecy"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=4.1.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=https://otr.cypherpunks.ca/libotr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8b3b182424251067a952fb4e6c7b95a21e644fbb27fbd5f8af2b2ed87ca419f5
TERMUX_PKG_DEPENDS="libgcrypt"
TERMUX_PKG_BREAKS="libotr-dev"
TERMUX_PKG_REPLACES="libotr-dev"
TERMUX_PKG_BUILD_DEPENDS="libgpg-error"
TERMUX_PKG_BUILD_IN_SRC=true
