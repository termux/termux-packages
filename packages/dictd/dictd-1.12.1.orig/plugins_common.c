/* dictdplugin_dbi.c -- 
 * Created: Thu Mar  18 18:43:50 2004 by vle@gmx.net
 * Copyright 2004 Aleksey Cheusov <vle@gmx.net>
 * This program comes with ABSOLUTELY NO WARRANTY.
 * 
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 1, or (at your option) any
 * later version.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/********************************************************************/

#include "dictP.h"
#include "plugins_common.h"

#include <maa.h>

static const int static_minus1_array [] = {
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
};

const int *alloc_minus1_array (size_t count)
{
   int *p;

   if (count <= sizeof (static_minus1_array) / sizeof (int)){
      return static_minus1_array;
   }else{
      p = (int *) xmalloc (count * sizeof (int));
      memset (p, -1, count * sizeof (int));
      return p;
   }
}

void free_minus1_array (int *p)
{
   if (p != static_minus1_array && p){
      xfree (p);
   }
}

/********************************************************************/

/* returns 0 if success */
static int process_line (
   char *s,
   void *data,
   int (*process_name_value) (const char *opt, const char *val, void *data),
   void (*set_error_message) (const char *bad_line, void *data))
{
   char * value  = NULL;
   size_t len    = 0;

   value = strchr (s, '=');
   if (!value){
//      snprintf (
//	 dict_data -> m_err_msg,
//	 BUFSIZE,
//	 "invalid configure line: '%s'",
//	 s);

      set_error_message (s, data);
      return 1;
   }

   *value++ = 0;

   len = strlen (value);

   if (len <= 0)
      return 0;

   if (value [0] == '"' && value [len - 1] == '"'){
      value [len - 1] = 0;
      ++value;
      len -= 2;
   }

   return process_name_value (s, value, data);
}

static void remove_spaces (char *s)
{
   char *p;
   int quote = 0;

   for (p = s; *s; ){
      if (*s == '"'){
	 *p++ = *s++;
	 quote = 1 - quote;
	 continue;
      }

      if (*s == '#'){
	 break;
      }

      if (*s != ' ' || quote)
	 *p++ = *s++;
      else
	 ++s;
   }

   *p = 0;
}

int process_lines (
   char *buf, int len,
   void *data,
   int (*process_name_value) (const char *opt, const char *val, void *data),
   void (*set_error_message) (const char *bad_line, void *data))
{
   char *p     = NULL;
   int comment = 0;
   int i       = 0;
   int ret     = 0;

//   int eq_sign = 0;

   for (i=0; i <= len; ++i){
      switch (buf [i]){
      case '\n':
      case '\0':
	 buf [i] = 0;

	 if (p){
	    remove_spaces (p);
	    if (*p){
	       ret = process_line (
		  p, data, process_name_value, set_error_message);

	       if (ret){
		  return ret;
	       }
	    }
	 }

	 comment = 0;
	 p = NULL;
	 break;

      case '#':
	 comment = 1;
	 break;
//      case '=':
//	 eq_sign = 1;
//	 break;

      default:
	 if (!p && !isspace (buf [i]))
	    p = buf + i;
      }

      if (comment){
	 buf [i] = 0;
      }
   }

   return 0;
}
