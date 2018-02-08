/* str.h -- 
 * Created: Fri Aug  8 15:48:16 2003 by vle@gmx.net
 * Copyright 2003 Aleksey Cheusov <vle@gmx.net>
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

/* returns 0 if success */
extern int tolower_alnumspace (
   const char *src, char *dest,
   int mode_allchars,
   int mode_cs,
   int mode_utf8);

extern char *strlwr_8bit (char *str);

#if HAVE_UTF8
extern char *copy_utf8_string (
   const char *MB_CUR_MAX_plus_1__bytes__blocks,
   char *dest,
   size_t len);
#endif
