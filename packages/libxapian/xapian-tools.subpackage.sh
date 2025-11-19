TERMUX_SUBPKG_INCLUDE="
bin/copydatabase
bin/quest
bin/simpleexpand
bin/simpleindex
bin/simplesearch
bin/xapian-check
bin/xapian-compact
bin/xapian-delve
bin/xapian-metadata
bin/xapian-pos
bin/xapian-progsrv
bin/xapian-replicate
bin/xapian-replicate-server
bin/xapian-tcpsrv
share/man/man1/
share/xapian-core/
"
TERMUX_SUBPKG_DESCRIPTION="Basic tools for the Xapian search engine"
TERMUX_SUBPKG_BREAKS="libxapian (<< 1.4.21)"
TERMUX_SUBPKG_REPLACES="libxapian (<< 1.4.21)"
