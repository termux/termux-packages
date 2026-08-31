TERMUX_SUBPKG_DESCRIPTION="PostgreSQL client library (libpq) without the server"
TERMUX_SUBPKG_INCLUDE="lib/libpq.so*"
# libpq is only linked against openssl (built --with-openssl); the other
# postgresql deps (libicu, libxml2, libuuid, readline, libandroid-shmem,
# libandroid-execinfo) are needed by the backend/contribs, not by the client
# library, so they must not leak into this lightweight subpackage.
TERMUX_SUBPKG_DEPENDS="openssl"
# Without this, the default behaviour would make libpq depend on the full
# postgresql package again -- defeating the whole point of the split.
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_BREAKS="postgresql (<< 18.2-1)"
TERMUX_SUBPKG_REPLACES="postgresql (<< 18.2-1)"
