TERMUX_PKG_HOMEPAGE="https://github.com/httpspycharmhelpers/aFakeSU"
TERMUX_PKG_DESCRIPTION="A fake su implementation based on proot"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@httpspycharmhelpers"
TERMUX_PKG_VERSION="1.0.0"
# 使用你上传的 Release 附件 zip 的链接
TERMUX_PKG_SRCURL="https://github.com/httpspycharmhelpers/aFakeSU/releases/download/1.0.0/aFakeSU-src.zip"
# SHA256 先留空，第一次构建时会提示正确值
TERMUX_PKG_SHA256="a2f07f5cc752730a79c3ca174ff0f2bf48ffd6a6312e9227e87fc90a13a0edd3"
TERMUX_PKG_BUILD_DEPENDS="clang, make, binutils"
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_pre_configure() {
    ls -l "$TERMUX_PKG_SRCDIR"
    cd "$TERMUX_PKG_SRCDIR/src"
}

termux_step_make() {
    cd "$TERMUX_PKG_SRCDIR/src"
    bash build_su.sh
}

termux_step_make_install() {
    install -Dm700 "$TERMUX_PKG_SRCDIR/src/fakesu.elf" "$TERMUX_PREFIX/bin/fakesu"
}
