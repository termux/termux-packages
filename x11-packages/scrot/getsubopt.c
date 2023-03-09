/*
 * Android c-library does not have getsubopt,
 * so code lifted from uClibc
 * http://git.uclibc.org/uClibc/tree/libc/unistd/getsubopt.c
 */

/* Parse comma separate list into words.
   Copyright (C) 1996, 1997, 1999, 2004 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Ulrich Drepper <drepper@cygnus.com>, 1996.
   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */


#include <stdlib.h>
#include <string.h>

char *strchrnul(const char *s, int c)
{
    char *result;

    result = strchr( s, c );

    if( !result )
    {
        result = (char *)s + strlen( s );
    }

    return( result );
}

/* Parse comma separated suboption from *OPTIONP and match against
   strings in TOKENS.  If found return index and set *VALUEP to
   optional value introduced by an equal sign.  If the suboption is
   not part of TOKENS return in *VALUEP beginning of unknown
   suboption.  On exit *OPTIONP is set to the beginning of the next
   token or at the terminating NUL character.  */
int
getsubopt (char **optionp, char *const *tokens, char **valuep)
{
  char *endp, *vstart;
  int cnt;

  if (**optionp == '\0')
    return -1;

  /* Find end of next token.  */
  endp = strchrnul (*optionp, ',');

  /* Find start of value.  */
  vstart = memchr (*optionp, '=', endp - *optionp);
  if (vstart == NULL)
    vstart = endp;

  /* Try to match the characters between *OPTIONP and VSTART against
     one of the TOKENS.  */
  for (cnt = 0; tokens[cnt] != NULL; ++cnt)
    if (strncmp (*optionp, tokens[cnt], vstart - *optionp) == 0
    && tokens[cnt][vstart - *optionp] == '\0')
      {
    /* We found the current option in TOKENS.  */
    *valuep = vstart != endp ? vstart + 1 : NULL;

    if (*endp != '\0')
      *endp++ = '\0';
    *optionp = endp;

    return cnt;
      }

  /* The current suboption does not match any option.  */
  *valuep = *optionp;

  if (*endp != '\0')
    *endp++ = '\0';
  *optionp = endp;

  return -1;
}
