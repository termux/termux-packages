#include "dictP.h"

#define CODESET_C         "ANSI_X3.4-1968"
#define CODESET_UTF8      "UTF-8"
#define CODESET_ISO8859_1 "ISO-8859-1"

/*
  partial implementation of nl_langinfo(3):
  - only CODESET argument is allowed.
  - "ANSI_X3.4-1968" is returned for C locale, "UTF-8" for utf-8 one and
    "ISO-8859-1" - for any other locale,
*/

const char *nl_langinfo(int it)
{
   char *locale;

   assert (it == CODESET);

   locale = getenv("LC_ALL");
   if (!locale)
      locale = getenv("LC_CTYPE");
   if (!locale)
      locale = getenv("LANG");

   if (locale){
      if (!strcmp(locale, "C") || !strcmp(locale, "POSIX"))
	 return CODESET_C;

      if (
	 strstr(locale, "UTF-8") || strstr(locale, "utf-8") ||
	 strstr(locale, "UTF8")  || strstr(locale, "utf8"))
      {
	 return CODESET_UTF8;
      }

      return CODESET_ISO8859_1;
   }else{
      return CODESET_C;
   }
}
