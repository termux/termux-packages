TERMUX_SUBPKG_DESCRIPTION="LibreOffice vector graphics and diagrams (Draw)"
TERMUX_SUBPKG_BREAKS="libreoffice (<< 26.8.0.3-1)"
TERMUX_SUBPKG_REPLACES="libreoffice (<< 26.8.0.3-1)"

_list="$TERMUX_PKG_TMPDIR/file-lists/draw.include"
[[ -s "$_list" ]] || termux_error_exit "$_list is missing or empty"
TERMUX_SUBPKG_INCLUDE="$(< "$_list")"
