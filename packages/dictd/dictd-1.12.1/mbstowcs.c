/*
  partial mbstowcs implementation:
  - doesn't change *ps
  - ignores n
  - dest should always be NULL
  - src should NOT be NULL
*/

#include "dictP.h"

#if HAVE_WCHAR_H
#include <wchar.h>
#endif

#include <assert.h>

size_t mbstowcs__ (wchar_t *dest, const char *src, size_t n)
{
   int ret = 0;
   int len = 0;
   int c;

   assert (src);   /* not implemented */
   assert (!dest); /* not implemented */

   while (*src){
      c = *(const unsigned char *)src;

      if (c <= 0x7F)
	 len = 1;
      else if (MB_CUR_MAX__ == 1)
	 len = 1;
      else if (c <= 0xBF)
	 return (size_t) -1;
      else if (c <= 0xDF)
	 len = 2;
      else if (c <= 0xEF)
	 len = 3;
      else if (c <= 0xF7)
	 len = 4;
      else if (c <= 0xFB)
	 len = 5;
      else if (c <= 0xFD)
	 len = 6;
      else
	 return (size_t) -1;

      ret += 1;
      src += len;
   }

   return ret;
}
