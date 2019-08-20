TERMUX_PKG_HOMEPAGE=https://bellard.org/quickjs/
TERMUX_PKG_DESCRIPTION="QuickJS is a small and embeddable Javascript engine"
TERMUX_PKG_LICENSE="MIT"
_YEAR=2019
_MONTH=09
_DAY=18
TERMUX_PKG_VERSION=${_YEAR}${_MONTH}${_DAY}
TERMUX_PKG_SHA256=ae4395d3f45045f920069e6c203ddb3fc3e549ce8fa3c429e696880cff010575
TERMUX_PKG_SRCURL=https://bellard.org/quickjs/quickjs-${_YEAR}-${_MONTH}-${_DAY}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
    MAKE_FLAGS="-j ${TERMUX_MAKE_PROCESSES} CROSS_PREFIX="${HOST_PLAT}-" CONFIG_CLANG=y CONFIG_DEFAULT_AR=y -W run-test262 -W run-test262-bn"
}

termux_step_make() {
    CFLAGS="${CFLAGS}" make ${MAKE_FLAGS}
}

termux_step_make_install() {
    make ${MAKE_FLAGS} install prefix=${TERMUX_PREFIX}
}
