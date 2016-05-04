#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

/* program_invocation_short_name GNU extension - http://linux.die.net/man/3/program_invocation_short_name */
extern char* __progname;
#define program_invocation_short_name __progname

/* error(3) GNU extension - http://man7.org/linux/man-pages/man3/error.3.html */
unsigned int error_message_count;
static inline void error(int status, int errnum, const char* format, ...) {
        error_message_count++;
        va_list myargs;
        va_start(myargs, format);
        vfprintf(stderr, format, myargs);
        va_end(myargs);
        exit(status);
}

/* strchrnul(3) GNU extension - http://man7.org/linux/man-pages/man3/strchr.3.html */
static inline char* strchrnul(char const* s, int c)
{
        char* result = strchr(s, c);
        return (result == NULL) ? (char*)(s + strlen(s)) : result;
}
