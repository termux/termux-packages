/*
  partial mbrtowc implementation:
  - doesn't change *ps
  - s should NOT be NULL
*/

#include "dictP.h"

#if HAVE_WCHAR_H
#include <wchar.h>
#endif

#if HAVE_WCTYPE_H
#include <wctype.h>
#endif

#include <stdlib.h>

int wctomb__ (char *s, wchar_t wc)
{
   return (int) wcrtomb__ (s, wc, NULL);
}
