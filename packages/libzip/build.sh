TERMUX_PKG_HOMEPAGE=https://libzip.org/
TERMUX_PKG_DESCRIPTION="library for reading, creating, and modifying zip archives."
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=47eaa45faa448c72bd6906e5a096846c469a185f293cafd8456abb165841b3f2
TERMUX_PKG_SRCURL=https://libzip.org/download/libzip-${TERMUX_PKG_VERSION}.tar.gz

termux_step_post_extract_package() {
    termux_setup_cmake
}
