#include "dictP.h"

#include <stdarg.h>
#include <stddef.h>
#include <maa.h>
#include <string.h>

/*
  partial vsnprintf implementation:
  - size PARAMETER IS COMPLETELY IGNORED
*/

int vsnprintf(char *str, size_t size, const char *format, va_list ap)
{
   vsprintf (str, format, ap);

   if (strlen (str) >= size)
      err_fatal( __func__, "Buffer too small\n" );
}
