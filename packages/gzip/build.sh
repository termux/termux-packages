TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gzip/
TERMUX_PKG_DESCRIPTION="Standard GNU file compression utilities"
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=ff1767ec444f71e5daf8972f6f8bf68cfcca1d2f76c248eb18e8741fc91dbbd3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gzip/gzip-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_GREP=grep
"
