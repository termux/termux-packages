TERMUX_PKG_HOMEPAGE="https://github.com/termux/termux-packages"
TERMUX_PKG_DESCRIPTION="CM - CLI Linux Emulator (Alpine, Kali, Ubuntu, Debian, Arch, Fedora)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="tf2-engineer544 <idrisyigitdemirci9@gmail.com>"
TERMUX_PKG_VERSION="1.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="wget, tar, xz-utils"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
    mkdir -p $TERMUX_PREFIX/bin
    cp $TERMUX_PKG_BUILDER_DIR/cm $TERMUX_PREFIX/bin/
    chmod 755 $TERMUX_PREFIX/bin/cm
}

termux_step_post_make_install() {
    mkdir -p $TERMUX_PREFIX/share/doc/cm
    cat > $TERMUX_PREFIX/share/doc/cm/LICENSE << 'LICENSE_EOF'
MIT License

Copyright (c) 2026 tf2-engineer544

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICENSE_EOF
}
