#ifndef STDIO_EXT_H_INCLUDED
#define STDIO_EXT_H_INCLUDED

#include <stdio.h>

/* http://linux.die.net/man/3/__fsetlocking */
#define FSETLOCKING_INTERNAL 1
#define FSETLOCKING_BYCALLER 2
#define FSETLOCKING_QUERY 3
static inline int __fsetlocking(FILE *stream, int type)
{
        (void) stream;
        (void) type;
        return FSETLOCKING_INTERNAL;
}

static inline int feof_unlocked(FILE *stream)
{
        return feof(stream);
}

static inline int ferror_unlocked(FILE *stream)
{
        return ferror(stream);
}

static inline int fputs_unlocked(const char *s, FILE *stream)
{
        return fputs(s, stream);
}

static inline int fputc_unlocked(int c, FILE *stream)
{
        return fputc(c, stream);
}

static inline size_t fread_unlocked(void *data, size_t size, size_t count, FILE *stream)
{
        return fread(data, size, count, stream);
}

static inline size_t fwrite_unlocked(const void *data, size_t size, size_t count, FILE *stream)
{
        return fwrite(data, size, count, stream);
}

#endif
