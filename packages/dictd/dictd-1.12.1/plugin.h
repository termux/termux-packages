/* plugin.h -- 
 * Created: Sat Mar 15 17:04:44 2003 by Aleksey Cheusov <vle@gmx.net>
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

#ifndef _PLUGIN_H_
#define _PLUGIN_H_

#include "dictP.h"
#include "defs.h"

/* initialize the plugin associated with db*/
extern int dict_plugin_init (dictDatabase *db);
/* destroy the plugin associated with db*/
extern void dict_plugin_destroy (dictDatabase *db);

/* search */
extern int dict_search_plugin (
   lst_List l,
   const char *const word,
   const dictDatabase *database,
   int strategy, /* search strategy + search type */
   int *extra_result,
   const dictPluginData **extra_data,
   int *extra_data_size);

/* dictdb_free */
extern void call_dictdb_free (lst_List db_list);

#endif /* _PLUGIN_H_ */
