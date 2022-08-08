TERMUX_SUBPKG_DESCRIPTION="Utilities for handling universally unique identifiers"
TERMUX_SUBPKG_DEPENDS="libsmartcols, libuuid (>> 2.38.1)"
TERMUX_SUBPKG_DEPEND_ON_PARENT="no"
TERMUX_SUBPKG_INCLUDE="
share/man/man3/uuid_copy.3.gz
share/man/man3/uuid_generate.3.gz
share/man/man3/uuid.3.gz
share/man/man3/uuid_generate_time_safe.3.gz
share/man/man3/uuid_is_null.3.gz
share/man/man3/uuid_compare.3.gz
share/man/man3/uuid_parse.3.gz
share/man/man3/uuid_time.3.gz
share/man/man3/uuid_generate_time.3.gz
share/man/man3/uuid_generate_random.3.gz
share/man/man3/uuid_clear.3.gz
share/man/man3/uuid_unparse.3.gz
share/man/man1/uuidgen.1.gz
share/man/man1/uuidparse.1.gz
share/man/man8/uuidd.8.gz
share/bash-completion/completions/uuidd
share/bash-completion/completions/uuidgen
share/bash-completion/completions/uuidparse
bin/uuidd
bin/uuidgen
bin/uuidparse
"
