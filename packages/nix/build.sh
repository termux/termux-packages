TERMUX_PKG_HOMEPAGE=https://nixos.org/nix/
TERMUX_PKG_DESCRIPTION="Powerful package manager that makes package management reliable and reproducible"
# local _COMMIT=915f62fa19790d8f826aeb4dd3d2bb5bde2f67e9
local _COMMIT=a2778988f2b70a5f000202afa7213b553350c72e
TERMUX_PKG_VERSION=1.12~a27789
TERMUX_PKG_SRCURL=https://github.com/NixOS/nix/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=c1f1622729ffdff6b733007cac3377cf5dfc6ae97e4e535ab2938b3ac471b4ff
TERMUX_PKG_FOLDERNAME=nix-${_COMMIT}
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="openssl, libbz2, libsqlite, libcurl, liblzma, libsodium, libseccomp"
# nixpkgs doesn't like the -android ABI
# Documentation building needs DocBook
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system=$TERMUX_ARCH-linux --disable-doc-gen"

_LD_HACK_DIR="libexec/nix/ld-hack"
_LD_HACK_BINARY="$_LD_HACK_DIR/do-ld-hack"

termux_step_post_extract_package () {
  ./bootstrap.sh
}

termux_step_pre_configure () {
    sed -i "s|@bash@|/usr/$_LD_HACK_DIR/bash|g" corepkgs/config.nix.in
    sed -i "s|@coreutils@|/usr/$_LD_HACK_DIR/applets|g" corepkgs/config.nix.in
    sed -i "s|@bzip2@|/usr/$_LD_HACK_DIR/applets/bzip2|g" corepkgs/config.nix.in
    sed -i "s|@gzip@|/usr/$_LD_HACK_DIR/applets/bzip2|g" corepkgs/config.nix.in
    sed -i "s|@xz@|/usr/$_LD_HACK_DIR/applets/xz|g" corepkgs/config.nix.in
    sed -i "s|@tar@|/usr/$_LD_HACK_DIR/applets/tar|g" corepkgs/config.nix.in
    sed -i "s|@tr@|/usr/$_LD_HACK_DIR/applets/tr|g" corepkgs/config.nix.in
}

termux_step_post_make_install () {
    mkdir -p "$PREFIX/$_LD_HACK_DIR/applets"
    "$CC" -o "$PREFIX/$_LD_HACK_BINARY" "$TERMUX_PKG_BUILDER_DIR/ld-library-path-hack.c"
    ln -fs "/usr/$_LD_HACK_BINARY" "$PREFIX/$_LD_HACK_DIR/bash"

    for i in $(cat "$TERMUX_PKG_BUILDER_DIR/applets.txt"); do
        ln -fs "/usr/$_LD_HACK_BINARY" "$PREFIX/$_LD_HACK_DIR/applets/$i"
    done
}
