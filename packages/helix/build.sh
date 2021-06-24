# http(s) link to package home page.
TERMUX_PKG_HOMEPAGE="https://helix-editor.com/"

# One-line, short package description.
TERMUX_PKG_DESCRIPTION="A post-modern modal text editor written in rust"

# License.
TERMUX_PKG_LICENSE="MPL-2.0"

# Who cares about package.
# Specify yourself (Github nick, or name + email) if you wish to maintain the
# package, fix its bugs, etc. Otherwise specify "@termux".
# Please note that unofficial repositories are not allowed to reference @termux
# as their maintainer.
TERMUX_PKG_MAINTAINER="@termux"

# Version.
TERMUX_PKG_VERSION=0.2.1

# URL to archive with source code
#TERMUX_PKG_SRCURL=https://github.com/helix-editor/helix/archive/v${TERMUX_PKG_VERSION}.tar.gz

# SHA-256 checksum of the source code archive.
#TERMUX_PKG_SHA256=ba388eded1246f00b5287ad9cfdaeebf24eada42729bf61b936bb70488cfb4fd
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source(){
  mkdir -p "$TERMUX_PKG_SRCDIR" && cd "$TERMUX_PKG_SRCDIR"
  git clone --recurse-submodules --shallow-submodules -j8 https://github.com/helix-editor/helix --branch=v0.2.1 # this is tag, actually! 
}

termux_step_make_install(){
  cat > "hx" << EOF
  #!/data/data/com.termux/files/usr/bin/sh
  HELIX_RUNTIME=${TERMUX_PREFIX}/lib/helix/runtime exec ${TERMUX_PREFIX}/lib/helix/hx/hx "\$@"

EOF
  chmod +x hx
  mv hx ${TERMUX_PREFIX}/bin

  cd helix

  termux_setup_rust
  cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release

  mkdir -p ${TERMUX_PREFIX}/lib/helix
  cp -r runtime ${TERMUX_PREFIX}/lib/helix
  install -Dm755 -t $TERMUX_PREFIX/lib/helix/hx target/${CARGO_TARGET_NAME}/release/hx
}
