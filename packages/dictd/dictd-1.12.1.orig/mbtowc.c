/*
  partial mbrtowc implementation:
  - ignores n
  - s should NOT be NULL
  - pwc should NOT be NULL
*/

#include "dictP.h"

#if HAVE_WCHAR_H
#include <wchar.h>
#endif

#include <stdlib.h>

int mbtowc__ (wchar_t *pwc, const char *s, size_t n)
{
   return (int) mbrtowc__ (pwc, s, n, NULL);
}
