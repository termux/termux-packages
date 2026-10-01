#include <stddef.h>

void setpwent(void) {}
void endpwent(void) {}
void *getpwent(void) {
	return NULL;
}

void setgrent(void) {}
void endgrent(void) {}
void *getgrent(void) {
	return NULL;
}
