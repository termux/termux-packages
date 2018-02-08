/* index.c -- 
 * Created: Sat Mar 15 16:47:42 2003 by Aleksey Cheusov <vle@gmx.net>
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

#include "dictP.h"

#include "dictd.h"
#include "plugin.h"
#include "strategy.h"
#include "data.h"
#include "index.h"

#ifndef HAVE_DLFCN_H
#include <ltdl.h>
#else
#include <dlfcn.h>
#endif

#include <maa.h>
#include <stdlib.h>
#include <ctype.h>

int dict_search_plugin (
   lst_List l,
   const char *const word,
   const dictDatabase *database,
   int strategy,
   int *extra_result,
   const dictPluginData **extra_data,
   int *extra_data_size)
{
   int ret;
   int                  failed = 0;
   const char * const * defs;
   const int          * defs_sizes;
   int                  defs_count;
   const char         * err_msg;
   int                  i;
   dictWord           * def;
   int                  len;

   int match         = strategy & DICT_MATCH_MASK;
   int strategy_real = strategy & ~DICT_MATCH_MASK;

   assert (database);
   assert (database -> plugin);

   if (strategy_real == DICT_STRAT_DOT){
      strategy = (match | database -> default_strategy);
      PRINTF (DBG_SEARCH, (":S:     def strategy for database '%s': %d\n",
			   database -> databaseName, strategy));
   }

   PRINTF (DBG_SEARCH, (":S:     searching for '%s' in '%s' using strat '%d'\n",
			word, database -> databaseName, strategy));

   failed = database -> plugin -> dictdb_search (
      database -> plugin -> data,
      word, -1,
      strategy,
      &ret,
      extra_data, extra_data_size,
      &defs, &defs_sizes, &defs_count);

   database -> plugin -> dictdb_free_called = 1;

   if (extra_result)
      *extra_result = ret;

   if (failed){
      err_msg = database -> plugin -> dictdb_error (
	 database -> plugin -> data);

      fprintf (stderr, ":E: Plugin failed: %s\n", (err_msg ? err_msg : ""));
      PRINTF (DBG_SEARCH, (":E: Plugin failed: %s\n", err_msg ? err_msg : ""));
   }else{
      switch (ret){
      case DICT_PLUGIN_RESULT_FOUND:
	 PRINTF (DBG_SEARCH, (":S:     found %i definitions\n", defs_count));
	 break;
      case DICT_PLUGIN_RESULT_NOTFOUND:
	 PRINTF (DBG_SEARCH, (":S:     not found\n"));
	 return 0;
      case DICT_PLUGIN_RESULT_EXIT:
	 PRINTF (DBG_SEARCH, (":S:     exiting\n"));
	 return 0;
      case DICT_PLUGIN_RESULT_PREPROCESS:
	 PRINTF (DBG_SEARCH, (":S:     preprocessing\n"));
	 break;
      default:
	 err_fatal (__func__, "invalid pligin's exit status\n");
      }

      for (i = 0; i < defs_count; ++i){
	 def = xmalloc (sizeof (dictWord));
	 memset (def, 0, sizeof (*def));

	 def -> database = database;
	 def -> start    = def -> end = 0;

	 len = defs_sizes [i];
	 if (-1 == len)
	    len = strlen (defs [i]);

	 if (
	    strategy & DICT_MATCH_MASK &&
	    ret != DICT_PLUGIN_RESULT_PREPROCESS)
	 {
	    def -> word     = xstrdup (defs [i]);
	    def -> def      = def -> word;
	    def -> def_size = -1;
	 }else{
	    def -> word     = xstrdup (word);
	    def -> def      = defs [i];
	    def -> def_size = len;
	 }

	 if (ret == DICT_PLUGIN_RESULT_PREPROCESS){
	    lst_push (l, def);
	 }else{
	    lst_append (l, def);
	 }
      }

      return defs_count;
   }

   return 0;
}

/* reads data without headword 00-... */
static char *dict_plugin_data (const dictDatabase *db, const dictWord *dw)
{
   char *buf = dict_data_obtain (db, dw);
   char *p = buf;
   int len;

   assert (db);
   assert (db -> index);

   if (!strncmp (p, DICT_ENTRY_PLUGIN_DATA, strlen (DICT_ENTRY_PLUGIN_DATA))){
      while (*p != '\n')
	 ++p;
   }

   while (*p == '\n')
      ++p;

   len = strlen (p);

   while (len > 0 && p [len - 1] == '\n')
      --len;

   p [len] = 0;

   p = xstrdup (p);
   xfree (buf);

   return p;
}

/* set data fields from 00-database-plugin-data entry */
/* return a number of inserted items */
static int plugin_initdata_set_data_file (
   dictPluginData *data, int data_size,
   const dictDatabase *db)
{
   char *plugin_data;
   int ret = 0;
   lst_List list;
   dictWord *dw;

   if (data_size <= 0)
      err_fatal (__func__, "invalid initial array size");

   list = lst_create ();

   ret = dict_search_database_ (
      list, DICT_ENTRY_PLUGIN_DATA, db, DICT_STRAT_EXACT);

   if (0 == ret){
      dict_destroy_list (list);
      return 0;
   }

   dw = (dictWord *) lst_pop (list);
   plugin_data = dict_plugin_data (db, dw);

   dict_destroy_datum (dw);

   data -> id   = DICT_PLUGIN_INITDATA_DICT;
   data -> data = plugin_data;
   data -> size = -1;

   dict_destroy_list (list);

   return 1;
}

/* set data fields from db -> plugin_data */
/* return a number of inserted items */
static int plugin_initdata_set_data_array (
   dictPluginData *data, int data_size,
   const dictDatabase *db)
{
   if (data_size <= 0)
      err_fatal (__func__, "invalid initial array size");

   if (db -> plugin_data){
      data [0].id   = DICT_PLUGIN_INITDATA_DICT;
      data [0].data = xstrdup (db -> plugin_data);
      data [0].size = -1;

      return 1;
   }else{
      return 0;
   }
}

/* return a number of inserted items */
static int plugin_initdata_set_data (
   dictPluginData *data, int data_size,
   const dictDatabase *db)
{
   if (db -> plugin_data)
      return plugin_initdata_set_data_array (data, data_size, db);
   else if (db -> index)
      return plugin_initdata_set_data_file (data, data_size, db);
   else
      return 0;
}

static int plugin_initdata_set_dbnames (dictPluginData *data, int data_size)
{
   const dictDatabase *db;
   int count;
   int i;

   if (data_size <= 0)
      err_fatal (__func__, "too small initial array");

   count = lst_length (DictConfig -> dbl);
   if (count == 0)
      return 0;

   if (count > data_size)
      err_fatal (__func__, "too small initial array");

   for (i = 1; i <= count; ++i){
      db = (const dictDatabase *)(lst_nth_get (DictConfig -> dbl, i));

      data -> id   = DICT_PLUGIN_INITDATA_DBNAME;
      if (db -> databaseName){
	 data -> size = strlen (db -> databaseName);
	 data -> data = xstrdup (db -> databaseName);
      }else{
	 data -> size = 0;
	 data -> data = NULL;
      }

      ++data;
   }

   return count;
}

static int plugin_initdata_set_stratnames (
   dictPluginData *data,
   int data_size,
   const dictDatabase *db)
{
   dictStrategy const * const *strats;
   int count;
   int ret = 0;
   int i;
   dictPluginData_strategy datum;

   if (data_size <= 0)
      err_fatal (__func__, "too small initial array");

   count = get_strategy_count ();
   assert (count > 0);

   strats = get_strategies ();

   for (i = 0; i < count; ++i){
      if (
	 !db -> strategy_disabled ||
	 !db -> strategy_disabled [strats [i] -> number])
      {
	 data -> id   = DICT_PLUGIN_INITDATA_STRATEGY;

	 if (
	    strlen (strats [i] -> name) + 1 >
	    sizeof (datum.name))
	 {
	    err_fatal (__func__, "too small initial array");
	 }

	 datum.number = strats [i] -> number;
	 strcpy (datum.name, strats [i] -> name);

	 data -> size = sizeof (datum);
	 data -> data = xmalloc (sizeof (datum));

	 memcpy ((void *) data -> data, &datum, sizeof (datum));

	 ++data;
	 ++ret;
      }
   }

   return ret;
}

static int plugin_initdata_set_defdbdir (dictPluginData *data, int data_size)
{
   if (data_size <= 0)
      err_fatal (__func__, "too small initial array");

   data -> size = -1;
   data -> data = xstrdup (DICT_DICTIONARY_PATH);
   data -> id   = DICT_PLUGIN_INITDATA_DEFDBDIR;

   return 1;
}

static int plugin_initdata_set_alphabet_8bit (
   dictPluginData *data, int data_size)
{
   if (data_size <= 0)
      err_fatal (__func__, "too small initial array");

   data -> size = -1;
   data -> data = xstrdup (global_alphabet_8bit);
   data -> id   = DICT_PLUGIN_INITDATA_ALPHABET_8BIT;

   return 1;
}

static int plugin_initdata_set_alphabet_ascii (
   dictPluginData *data, int data_size)
{
   if (data_size <= 0)
      err_fatal (__func__, "too small initial array");

   data -> size = -1;
   data -> data = xstrdup (global_alphabet_ascii);
   data -> id   = DICT_PLUGIN_INITDATA_ALPHABET_ASCII;

   return 1;
}

/* all dict [i]->data are xmalloc'ed */
static int plugin_initdata_set (
   dictPluginData *data, int data_size,
   const dictDatabase *db)
{
   int count = 0;
   dictPluginData *p = data;

   count = plugin_initdata_set_defdbdir (data, data_size);
   data      += count;
   data_size -= count;

   count = plugin_initdata_set_dbnames (data, data_size);
   data      += count;
   data_size -= count;

   count = plugin_initdata_set_stratnames (data, data_size, db);
   data      += count;
   data_size -= count;

   count = plugin_initdata_set_data (data, data_size, db);
   data      += count;
   data_size -= count;

   count = plugin_initdata_set_alphabet_8bit (data, data_size);
   data      += count;
   data_size -= count;

   count = plugin_initdata_set_alphabet_ascii (data, data_size);
   data      += count;
   data_size -= count;

   return data - p;
}

static void plugin_init_data_free (
   dictPluginData *data, int data_size)
{
   int i=0;

   for (i = 0; i < data_size; ++i){
      if (data -> data)
	 xfree ((void *) data -> data);

      ++data;
   }
}

/* Reads plugin's file name from .dict file */
/* do not free() returned value*/
static char *dict_plugin_filename (
   const dictDatabase *db,
   const dictWord *dw)
{
   static char filename [FILENAME_MAX];

   char *buf = dict_data_obtain (db, dw);
   char *p = buf;
   int len;

   if (!strncmp (p, DICT_ENTRY_PLUGIN, strlen (DICT_ENTRY_PLUGIN))){
      while (*p != '\n')
	 ++p;
   }

   while (*p == '\n' || isspace ((unsigned char) *p))
      ++p;

   len = strlen (p);

   while (
      len > 0 &&
      (p [len - 1] == '\n' || isspace ((unsigned char) p [len - 1])))
   {
      --len;
   }

   p [len] = 0;

   if (p [0] != '.' && p [0] != '/'){
      if (sizeof (filename) < strlen (DICT_PLUGIN_PATH) + strlen (p) + 1)
	 err_fatal (__func__, "too small initial array\n");

      strcpy (filename, DICT_PLUGIN_PATH);
      strcat (filename, p);
   }else{
      strlcpy (filename, p, sizeof (filename));
   }

   xfree (buf);

   return filename;
}


static void dict_plugin_test (dictPlugin *plugin, int version, int ret)
{
   const char *err_msg = NULL;

   if (ret){
      err_msg = plugin -> dictdb_error (
	 plugin -> data);

      if (err_msg){
	 err_fatal (
	    __func__,
	    "%s\n",
	    plugin -> dictdb_error (plugin -> data));
      }else{
	 err_fatal (
	    __func__,
	    "Error code %i\n", ret);
      }
   }

   switch (version){
   case 0:
      break;
/*
   case 1:
      if (!i -> plugin -> dictdb_set)
	 err_fatal (__func__, "'%s' function is not found\n", DICT_PLUGINFUN_SET);
      break;
*/
   default:
      err_fatal (__func__, "Invalid version returned by plugin\n");
   }
}

static void dict_plugin_dlsym (dictPlugin *plugin)
{
   PRINTF(DBG_INIT, (":I:     getting functions addresses\n"));

   plugin -> dictdb_open   = (dictdb_open_type)
      lt_dlsym (plugin -> handle, DICT_PLUGINFUN_OPEN);
   plugin -> dictdb_free   = (dictdb_free_type)
      lt_dlsym (plugin -> handle, DICT_PLUGINFUN_FREE);
   plugin -> dictdb_search = (dictdb_search_type)
      lt_dlsym (plugin -> handle, DICT_PLUGINFUN_SEARCH);
   plugin -> dictdb_close  = (dictdb_close_type)
      lt_dlsym (plugin -> handle, DICT_PLUGINFUN_CLOSE);
   plugin -> dictdb_error  = (dictdb_error_type)
      lt_dlsym (plugin -> handle, DICT_PLUGINFUN_ERROR);
   plugin -> dictdb_set   = (dictdb_set_type)
      lt_dlsym (plugin -> handle, DICT_PLUGINFUN_SET);

   if (!plugin -> dictdb_open ||
       !plugin -> dictdb_search ||
       !plugin -> dictdb_free ||
       !plugin -> dictdb_error ||
       !plugin -> dictdb_close)
   {
      PRINTF(DBG_INIT, (":I:     faild\n"));
      exit (1);
   }
}

static dictPlugin *create_plugin (
   const char *datababsename,
   const char *plugin_filename,
   const dictPluginData *plugin_init_data,
   int plugin_init_data_size)
{
   dictPlugin *plugin;
   int ret;
   int version;

   PRINTF(
      DBG_INIT, (
	 ":I:   Initializing db/plugin '%s'/'%s'\n",
	 datababsename ? datababsename : "(null)", plugin_filename));

   plugin = xmalloc (sizeof (dictPlugin));
   memset (plugin, 0, sizeof (dictPlugin));

   PRINTF(DBG_INIT, (":I:     opening plugin\n"));
   plugin -> handle = lt_dlopen (plugin_filename);
   if (!plugin -> handle){
      PRINTF(DBG_INIT, (":I:     faild: %s\n", dlerror ()));
      exit (1);
   }

   dict_plugin_dlsym (plugin);

   PRINTF(DBG_INIT, (":I:     initializing plugin\n"));
   ret = plugin -> dictdb_open (
      plugin_init_data, plugin_init_data_size, &version, &plugin -> data);

   dict_plugin_test (plugin, version, ret);

   return plugin;
}

int dict_plugin_init (dictDatabase *db)
{
   int ret = 0;
   lst_List list;
   const char *plugin_filename = NULL;
   dictWord *dw;

   dictPluginData init_data [3000];
   int init_data_size = 0;

   if (db -> pluginFilename){
      plugin_filename = db -> pluginFilename;
   }else if (db -> index){

      list = lst_create ();

      ret = dict_search_database_ (list, DICT_ENTRY_PLUGIN, db, DICT_STRAT_EXACT);
      switch (ret){
      case 1: case 2:
	 dw = (dictWord *) lst_pop (list);

	 plugin_filename = dict_plugin_filename (db, dw);

	 dict_destroy_datum (dw);
	 break;
      case 0:
	 break;
      default:
	 err_internal( __func__, "Corrupted .index file'\n" );
      }

      dict_destroy_list (list);
   }

   if (plugin_filename){
      init_data_size = plugin_initdata_set (
	 init_data, sizeof (init_data)/sizeof (init_data [0]),
	 db);

      db -> plugin = create_plugin (
	 db -> databaseName,
	 plugin_filename, init_data, init_data_size);

      plugin_init_data_free (init_data, init_data_size);
   }

   return 0;
}

void dict_plugin_destroy ( dictDatabase *db )
{
   int ret;

   if (!db)
      return;

   if (!db -> plugin)
      return;

   if (db -> plugin -> dictdb_close){
      ret = db -> plugin -> dictdb_close (db -> plugin -> data);
      if (ret){
	 PRINTF(DBG_INIT, ("exiting plugin failed"));
	 exit (1);
      }
   }

   ret = lt_dlclose (db -> plugin -> handle);
   if (ret)
      PRINTF(DBG_INIT, ("%s", lt_dlerror ()));

   xfree (db -> plugin);
   db -> plugin = NULL;
}

void call_dictdb_free (lst_List db_list)
{
   const dictDatabase *db = NULL;
   lst_Position pos;

   LST_ITERATE (db_list, pos, db){
      if (db -> plugin){
	 if (db -> plugin -> dictdb_free_called){
	    db -> plugin -> dictdb_free (db -> plugin -> data);

	    db -> plugin -> dictdb_free_called = 0;
	 }
      }
   }
}
