#ifndef CRYPT_H_INCLUDED
#define CRYPT_H_INCLUDED

#include <sys/cdefs.h>

__BEGIN_DECLS

char* crypt(const char* key, const char* salt);

__END_DECLS

#endif
