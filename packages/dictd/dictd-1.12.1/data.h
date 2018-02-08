/* data.h -- 
 * Created: Sat Mar 15 18:04:25 2003 by Aleksey Cheusov <vle@gmx.net>
 * Copyright 1994-2003 Rickard E. Faith (faith@dict.org)
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

#ifndef _DATA_H_
#define _DATA_H_

#include "dictP.h"
#include "defs.h"

/* initialize .data file */
extern dictData *dict_data_open (
   const char *filename, int computeCRC);
/* */
extern void dict_data_close (
   dictData *data);

extern void     dict_data_print_header( FILE *str, dictData *data );
extern int      dict_data_zip(
   const char *inFilename, const char *outFilename,
   const char *preFilter, const char *postFilter );

extern char *dict_data_obtain (
   const dictDatabase *db,
   const dictWord *dw);

extern char *dict_data_read_ (
   dictData *data,
   unsigned long start, unsigned long end,
   const char *preFilter,
   const char *postFilter );

extern int   dict_data_filter(
   char *buffer, int *len, int maxLength,
   const char *filter );

extern int        mmap_mode;

#endif /* _DATA_H_ */
