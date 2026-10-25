#include <netdb.h>
#include <stddef.h>
#include <stdint.h>

void endnetent(void) {}
void endprotoent(void) {}
struct netent *getnetbyaddr(uint32_t net, int type) { return NULL; }
struct netent *getnetbyname(const char *name) { return NULL; }
struct netent *getnetent(void) { return NULL; }
struct protoent *getprotobyname(const char *name) { return NULL; }
struct protoent *getprotobynumber(int proto) { return NULL; }
struct protoent *getprotoent(void) { return NULL; }
void setnetent(int stayopen) {}
void setprotoent(int stayopen) {}
