/* dictdplugin_dbi.h -- 
 * Created: Thu Mar  18 19:15:50 2004 by vle@gmx.net
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

extern const int *alloc_minus1_array (size_t count);
extern void free_minus1_array (int *p);

extern int process_lines (
   char *buf, int len,
   void *data,
   int (*process_name_value) (const char *opt, const char *val, void *data),
   void (*set_error_message) (const char *error_line, void *data));
