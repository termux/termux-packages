#!/bin/bash
TERMUX_PKG_HOMEPAGE=https://github.com/Marcelinomodz/Nova
TERMUX_PKG_DESCRIPTION="Nova Language - A simple and modern programming language by MARCELINO MODZ"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="MARCELINO MODZ"
TERMUX_PKG_VERSION="0.2.0"
TERMUX_PKG_SRCURL=https://github.com/Marcelinomodz/Nova/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS=""

termux_step_make() {
    $CXX -std=c++11 -Wall -O2 -o nova src/cpp/nova.cpp
}

termux_step_make_install() {
    install -Dm700 nova $TERMUX_PREFIX/bin/nova
}
