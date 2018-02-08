/*
  partial mbrtowc implementation:
  - doesn't change *ps
  - ignores n
  - s should NOT be NULL
  - pwc should NOT be NULL
*/

#include "dictP.h"

#if HAVE_WCHAR_H
#include <wchar.h>
#endif

#include <assert.h>

static const char * utf8_to_ucs4 (
   const char *ptr, wchar_t *result)
{
   wchar_t ret;
   int ch;
   int octet_count;
   int bits_count;
   int i;

   ret = 0;

   ch = (unsigned char) *ptr++;

   if ((ch & 0x80) == 0x00){
      if (result)
	 *result = ch;
   }else{
      if ((ch & 0xE0) == 0xC0){
	 octet_count = 2;
	 ch &= ~0xE0;
      }else if ((ch & 0xF0) == 0xE0){
	 octet_count = 3;
	 ch &= ~0xF0;
      }else if ((ch & 0xF8) == 0xF0){
	 octet_count = 4;
	 ch &= ~0xF8;
      }else if ((ch & 0xFC) == 0xF8){
	 octet_count = 5;
	 ch &= ~0xFC;
      }else if ((ch & 0xFE) == 0xFC){
	 octet_count = 6;
	 ch &= ~0xFE;
      }else{
	 return NULL;
      }

      bits_count = (octet_count-1) * 6;
      ret |= (ch << bits_count);
      for (i=1; i < octet_count; ++i){
	 bits_count -= 6;

	 ch = (unsigned char) *ptr++;
	 if ((ch & 0xC0) != 0x80){
	    return NULL;
	 }

	 ret |= ((ch & 0x3F) << bits_count);
      }

      if (result)
	 *result = ret;
   }

   return ptr;
}

size_t mbrtowc__ (wchar_t *pwc, const char *s, size_t n, mbstate_t *ps)
{
   const char *end;

   assert (s);
   assert (pwc);
   assert (MB_CUR_MAX__ > 1);

   end = utf8_to_ucs4 (s, pwc);
   if (end)
      return end - s;
   else
      return (size_t) -1;
}
