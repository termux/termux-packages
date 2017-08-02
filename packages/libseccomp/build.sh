TERMUX_PKG_HOMEPAGE=https://github.com/seccomp/libseccomp
TERMUX_PKG_DESCRIPTION="The libseccomp library provides an easy to use, platform independent, interface to the Linux Kernel's syscall filtering mechanism."
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SRCURL=https://github.com/seccomp/libseccomp/archive/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=56eff0990e4cfb7ce3c80440c1d8aa6e1423893d0d9af962b81217964dbb5d6e
TERMUX_PKG_FOLDERNAME=libseccomp-${TERMUX_PKG_VERSION}

termux_step_pre_configure () {
  ./autogen.sh
}

