TERMUX_SUBPKG_INCLUDE="
lib/postgresql/hstore.so
lib/postgresql/pgcrypto.so
lib/postgresql/pg_stat_statements.so
share/postgresql/extension/hstore*
share/postgresql/extension/pgcrypto*
share/postgresql/extension/pg_stat_statements*
"
TERMUX_SUBPKG_DESCRIPTION="Additional facilities for PostgreSQL"
TERMUX_SUBPKG_DEPENDS="postgresql"
