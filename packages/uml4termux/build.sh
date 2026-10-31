# packaging/termux/build.sh
# termux-packages build script for uml4termux (scripts/UX layer).
# This is a script-only package (no compilation). It installs the same file set
# as scripts/install.sh into $TERMUX_PREFIX.
#
# Kernel + passt packaging already exists upstream in termux-packages PR #32700
# (packages/linux-kernel-um + packages/passt). This package is the CLI/UX layer
# that will later depend on them:
#   TERMUX_PKG_DEPENDS="linux-kernel-um, passt"
# Once linux-kernel-um and passt are merged and published, uncomment the above.

TERMUX_PKG_HOMEPAGE=https://github.com/michaelamoetoevsky/uml4termux
TERMUX_PKG_DESCRIPTION="Run UML (User-Mode Linux) arm64 + rootless Docker on Termux/Android"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="uml4termux maintainers <michaelamoetoevsky@users.noreply.github.com>"
TERMUX_PKG_VERSION="0.5.0"
# TERMUX_PKG_VERSION is normally a literal for the package index.
# The source of truth is the VERSION file in the repo root.
# When submitting to termux-packages, update this to match the release tag.
# The SRCURL uses this version for the GitHub release tarball.

# GitHub release tarball (update owner/repo if the canonical location changes)
TERMUX_PKG_SRCURL=https://github.com/michaelamoetoevsky/uml4termux/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
# SHA256 of the v0.5.0 release tarball (from the release's digest field;
# make-dist is byte-reproducible across toolchains).
TERMUX_PKG_SHA256=c8e7820b7630e40ef2278cfee5c4d1dd959f8c772a0611c88447833ed5d12ee2

# Architecture: aarch64 only (UML arm64 + bionic stub requires arm64 host)
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

# No build dependencies (script-only package)
TERMUX_PKG_BUILD_DEPENDS=""
# Runtime dependencies, honestly listed: the CLI is bash and the library uses coreutils;
# fetch verifies digests with sha256sum and downloads with curl; the initramfs builder and
# the read-only status panel are python. linux-kernel-um and passt will be added once
# termux-packages PR #32700 lands -- this package does not need them at install time
# because the runtime assets are fetched, with pinned digests, on first use.
TERMUX_PKG_DEPENDS="bash, coreutils, curl, python"

# Build in source dir (the tarball extracts to uml4termux-<version>)
TERMUX_PKG_BUILD_IN_SRC=true

# Skip the default configure/make steps — we only install
termux_step_configure() {
  return 0
}

termux_step_make() {
  return 0
}

termux_step_make_install() {
  # Delegate to the installer instead of keeping a second list of files here. The
  # hand-written list this replaces had already drifted from the installer's, and
  # every future file would have had to be added in two places -- or, as happened,
  # in one place and wrongly.
  bash "${TERMUX_PKG_SRCDIR}/scripts/install.sh" \
    --prefix "${TERMUX_PREFIX}" --no-symlink
}

termux_step_post_make_install() {
  # Print the next step for the user after `pkg install uml4termux`
  cat <<'EOF'

======================================================================
uml4termux installed successfully.

Next step: fetch the runtime assets (kernel, disk image, initramfs, gvproxy)

  uml4termux fetch

This downloads ~1.5 GB of verified binaries into ~/.local/share/uml4termux/
(or $UML4TERMUX_HOME). Then run the full Docker test:

  uml4termux docker

See 'uml4termux help' for all commands.
======================================================================
EOF
}

# No license file to install (GPL-2.0-only is in the source repo; termux-packages
# will handle SPDX). If a LICENSE file is added, uncomment:
# termux_step_install_license() {
#   install -Dm644 "${TERMUX_PKG_SRCDIR}/LICENSE" \
#     "${TERMUX_PREFIX}/share/doc/uml4termux/LICENSE"
# }