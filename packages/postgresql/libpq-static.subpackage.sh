TERMUX_SUBPKG_DESCRIPTION="Static library for libpq"
TERMUX_SUBPKG_INCLUDE="lib/libpq.a lib/libpq.la"
# Depend on libpq (the shared-lib package), not the full postgresql server
# stack, matching libpq.subpackage.sh.
TERMUX_SUBPKG_DEPENDS="libpq"
# Without this, the default behaviour would make this depend on the full
# postgresql package, same reasoning as in libpq.subpackage.sh.
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
# Previously libpq.a shipped inside postgresql-static (built by the
# automatic TERMUX_PKG_NO_STATICSPLIT=false split of the parent package).
# Since this subpackage.sh is processed before that virtual one, it moves
# lib/libpq.a out first, so postgresql-static no longer contains it -- old
# postgresql-static installs must be replaced to avoid a stale file clash.
TERMUX_SUBPKG_BREAKS="postgresql-static (<< 18.2-1)"
TERMUX_SUBPKG_REPLACES="postgresql-static (<< 18.2-1)"
