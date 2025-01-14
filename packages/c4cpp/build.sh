#!/bin/bash
 #  Maintainer: enpasant
 # Homepage: https://github.com/enpasant/c4cpp
 # License: MIT

 TERMUX_PKG_HOMEPAGE=https://github.com/enpasant/c4cpp
 TERMUX_PKG_DESCRIPTION="A fast, lightweight, and functional C++ calculator"
 TERMUX_PKG_LICENSE="MIT"
 TERMUX_PKG_MAINTAINER="enpasant"
 TERMUX_PKG_VERSION=1.0.6
 TERMUX_PKG_SRCURL=https://github.com/enpasant/c4cpp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
 TERMUX_PKG_SHA256=ef25a4852f3a71dcd045d1edc3dbe0b96a2400aa0db528f1d925282eae251863
 TERMUX_PKG_DEPENDS="clang"
 TERMUX_PKG_ARCH=aarch64

 # Pre-configuration steps (not needed in this case)
 termux_step_pre_configure() {
     return 0
     }

     # Compilation using g++
     termux_step_make() {
         # Compile the C++ code using g++
             g++ -o c4cpp *.cpp
                 return 0
                 }

                 # Install the compiled binary
                 termux_step_make_install() {
                     # Install the binary to the proper directory
                         install -Dm700 c4cpp $TERMUX_PREFIX/bin/c4cpp
                             return 0
                             }

