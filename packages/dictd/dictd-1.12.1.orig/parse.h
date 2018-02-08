/* parse.h -- Header file for visible prs_XXX functions
 * Created: Sun Nov 19 13:21:21 1995 by faith@dict.org
 * Copyright 1994-1998, 2002 Rickard E. Faith (faith@dict.org)
 * Copyright 2002-2008 Aleksey Cheusov (vle@gmx.net)
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Library General Public License as published
 * by the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef _PARSE_H_
#define _PARSE_H_

#include <stdio.h>
#include <stdarg.h>

extern void   prs_set_debug( int debug_flag );
extern void   prs_set_cpp_options( const char *cpp_options );
extern void   prs_file_pp( const char *filename, const char *preprocessor );
extern void   prs_file( const char *filename );
extern void   prs_file_nocpp( const char *filename );
extern void   prs_stream( FILE *str, const char *name );
extern int    prs_make_integer( const char *string, int length );
extern double prs_make_double( const char *string, int length );

#endif
