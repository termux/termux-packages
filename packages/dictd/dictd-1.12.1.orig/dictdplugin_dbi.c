/* dictdplugin_dbi.c -- 
 * Created: Mon Mar  15 20:19:57 2004 by vle@gmx.net
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

#include "dictP.h"
#include "dictdplugin.h"
//#include "data.h"
#include "str.h"
#include "plugins_common.h"

#include <maa.h>
#include <dbi/dbi.h>

#include <stdio.h>

#define BUFSIZE 4096

#ifndef BOOL
#define BOOL char
#endif

/**********************************************************/

//#define DONOT_USE_INTERNAL_HEAP /* internal heap may speed-up the plugin */

//#define CONNECT_TO_SERVER_ONCE /* not implemented yet */

#include "heap.h"

typedef struct global_data_s {
   char m_err_msg  [BUFSIZE];

   void *m_heap;
   void *m_heap2;

   int m_mres_count;
   const char ** m_mres;
   int *m_mres_sizes;

   int m_strat_exact;
   int m_max_strategy_num;
   char **m_strategynum2query;
   char *m_define_query;
   hsh_HashTable m_strategy2strategynum;

   BOOL m_conf_all_chars;
   BOOL m_conf_utf8;

//   BOOL m_flag_allchars; // ???
//   BOOL m_flag_utf8;

   dbi_conn   m_dbi_conn;

   char *m_dbi_driver_dir;
   char *m_dbi_driver_name;
   char *m_dbi_option_host;
   char *m_dbi_option_port;
   char *m_dbi_option_dbname;
   char *m_dbi_option_username;
   char *m_dbi_option_password;

//   int m_dbi_option_case_sensitive;

   char *m_alphabet_global_8bit;
   char *m_alphabet_global_ascii;
   char *m_alphabet;
} global_data;

int dictdb_close (void *dict_data);
int dictdb_open (
   const dictPluginData *init_data,
   int init_data_size,
   int *version,
   void ** dict_data);
const char *dictdb_error (void *dict_data);
int dictdb_free (void * dict_data);
int dictdb_search (
   void *dict_data,
   const char *word, int word_size,
   int search_strategy,
   int *ret,
   const char **result_extra, int *result_extra_size,
   const char * const* *result,
   const int **result_sizes,
   int *results_count);

/**********************************************************/

static void plugin_error (global_data *dict_data, const char *err_msg)
{
   strlcpy (dict_data -> m_err_msg, err_msg, BUFSIZE);
}

static global_data * global_data_create (void)
{
   global_data *d = (global_data *) xmalloc (sizeof (*d));

   memset (d, 0, sizeof (*d));

   d -> m_strat_exact    = -2;
   d -> m_conf_all_chars = 0;
   d -> m_conf_utf8      = 1;

   return d;
}

static void global_data_destroy (global_data *d)
{
   int i;
   hsh_Position hsh_pos;
   void * hsh_key;
   void * hsh_data;

   dictdb_free (d);

   if (d -> m_dbi_driver_dir)
      xfree (d -> m_dbi_driver_dir);
   if (d -> m_dbi_driver_name)
      xfree (d -> m_dbi_driver_name);
   if (d -> m_dbi_option_host)
      xfree (d -> m_dbi_option_host);
   if (d -> m_dbi_option_port)
      xfree (d -> m_dbi_option_port);
   if (d -> m_dbi_option_dbname)
      xfree (d -> m_dbi_option_dbname);
   if (d -> m_dbi_option_username)
      xfree (d -> m_dbi_option_username);
   if (d -> m_dbi_option_password)
      xfree (d -> m_dbi_option_password);

   if (d -> m_alphabet)
      xfree (d -> m_alphabet);
   if (d -> m_alphabet_global_8bit)
      xfree (d -> m_alphabet_global_8bit);
   if (d -> m_alphabet_global_ascii)
      xfree (d -> m_alphabet_global_ascii);

   if (d -> m_strategynum2query){
      for (i = 0; i <= d -> m_max_strategy_num; ++i){
	 if (d -> m_strategynum2query [i])
	    xfree (d -> m_strategynum2query [i]);
      }
      xfree (d -> m_strategynum2query);
   }

   if (d -> m_define_query)
      xfree (d -> m_define_query);

   HSH_ITERATE (d -> m_strategy2strategynum, hsh_pos, hsh_key, hsh_data){
      if (hsh_key)
	 xfree (hsh_key);
   }
   hsh_destroy (d -> m_strategy2strategynum);

   heap_destroy (&d -> m_heap);
   heap_destroy (&d -> m_heap2);

   if (d)
      xfree (d);
}

static void set_strat (
   const dictPluginData_strategy * strat_data,
   global_data * d)
{
   assert (strat_data -> number >= 0);
   assert (strat_data -> name);

   hsh_insert (
      d -> m_strategy2strategynum,
      xstrdup (strat_data -> name),
      (void *) (strat_data -> number + 1)); /* +1: 0 --> not NULL*/

   if (d -> m_max_strategy_num < strat_data -> number){
      d -> m_max_strategy_num = strat_data -> number;

      d -> m_strategynum2query = xrealloc (
	 d -> m_strategynum2query,
	 sizeof (char *) * (1 + strat_data -> number));

      while (d -> m_max_strategy_num <= strat_data -> number){
	 d -> m_strategynum2query [d -> m_max_strategy_num++] = 0;
      }
      d -> m_max_strategy_num = strat_data -> number;
   }

   if (!strcmp (strat_data -> name, "exact")){
      d -> m_strat_exact = strat_data -> number;
   }
}

static int strategy2strategynum (
   const global_data *dict_data,
   const char *strategy)
{
   const void *data = hsh_retrieve (
      dict_data -> m_strategy2strategynum,
      strategy);

   if (data){
      return -1 + (int) data;
   }else{
      return -1;
   }
}

/*
  strat: -1 for DEFINE command
 */
static const char * strategynum2query (
   const global_data *dict_data,
   int strat)
{
   if (strat == -1){
      return dict_data -> m_define_query;
   }else if (strat < 0 || strat > dict_data -> m_max_strategy_num){
      return NULL;
   }else{
      return dict_data -> m_strategynum2query [strat];
   }
}

static void on_error (const char *bad_line, void *data)
{
   global_data *dict_data = (global_data *) data;

   snprintf (
      dict_data -> m_err_msg,
      BUFSIZE,
      "invalid configure line: '%s'",
      bad_line);
}

static int string2bool (const char *str)
{
   if (
      !strcasecmp ("1", str)
      || !strcasecmp ("true", str)
      || !strcasecmp ("yes", str))
   {
      return 1;
   }else{
      return 0;
   }
}

static int process_name_value (
   const char *name,
   const char *value,
   void *d)
{
   const char *strategy_name = NULL;
   int         strategy_num  = 0;
   global_data *dict_data = (global_data *) d;

   if (!strcmp(name, "driverdir")){
      dict_data-> m_dbi_driver_dir = xstrdup (value);
   }else if (!strcmp(name, "drivername")){
      dict_data-> m_dbi_driver_name = xstrdup (value);
   }else if (!strcmp(name, "option_host")){
      dict_data-> m_dbi_option_host = xstrdup (value);
   }else if (!strcmp(name, "option_port")){
      dict_data-> m_dbi_option_port = xstrdup (value);
   }else if (!strcmp(name, "option_dbname")){
      dict_data-> m_dbi_option_dbname = xstrdup (value);
   }else if (!strcmp(name, "option_username")){
      dict_data-> m_dbi_option_username = xstrdup (value);
   }else if (!strcmp(name, "option_password")){
      dict_data-> m_dbi_option_password = xstrdup (value);
   }else if (!strcmp(name, "all_chars")){
      dict_data-> m_conf_all_chars = string2bool (value);
   }else if (!strcmp(name, "utf8")){
      dict_data-> m_conf_utf8 = string2bool (value);
   }else if (!strcmp(name, "query_define")){
      dict_data-> m_define_query = xstrdup (value);
   }else if (!strncmp (name, "query_", 6) && strlen (name) > 7){
      strategy_name = name + 6;
      strategy_num  = strategy2strategynum (d, strategy_name);

      if (strategy_num < 0){
	 snprintf (
	    dict_data-> m_err_msg,
	    BUFSIZE,
	    "unknown strategy: '%s'",
	    strategy_name);

	 return 2;
      }

      assert (
	 strategy_num >= 0 &&
	 strategy_num <= dict_data-> m_max_strategy_num);

      dict_data-> m_strategynum2query [strategy_num] = xstrdup (value);
   }else{
      char err_msg [BUFSIZE]; 
      snprintf (err_msg, sizeof (err_msg), "unknown option '%s'", name);
      plugin_error (d, err_msg);
      return 3;
   }

   return 0;
}

#if 0
static void init_alphabet (global_data *dict_data)
{
   int ret = 0;
   int exit_code = 0;
   const char * const* defs;
   const int * defs_sizes;
   int count = 0;
   int len = 0;
   char *p = NULL;
   char *alphabet = NULL;

   assert (dict_data);

   exit_code = dictdb_search (
      dict_data, "00-database-alphabet", -1,
      dict_data -> m_strat_exact,
      &ret,
      NULL, 0,
      &defs, &defs_sizes,
      &count);

   if (!exit_code && ret == DICT_PLUGIN_RESULT_FOUND && count > 0){
      if (-1 == defs_sizes [0])
	 len = strlen (defs [0]);
      else
	 len = defs_sizes [0];

      alphabet = dict_data -> m_alphabet = xmalloc (len + 1);
      memcpy (alphabet, defs [0], len);
      alphabet [len] = 0;

      p = strchr (alphabet, '\n');
      if (p)
	 *p = 0;

/*      fprintf (stderr, "alphabet = `%s`\n", alphabet);*/
   }

   dictdb_free (dict_data);
}
#endif

static void init_allchars (global_data *dict_data)
{
   int ret = 0;
   int exit_code = 0;
   const char * const* defs;
   const int * defs_sizes;
   int count = 0;

   assert (dict_data);

   dict_data -> m_conf_all_chars = 1;

   exit_code = dictdb_search (
      dict_data, "00-database-allchars", -1,
      dict_data -> m_strat_exact,
      &ret,
      NULL, 0,
      &defs, &defs_sizes,
      &count);

   if (!exit_code && ret == DICT_PLUGIN_RESULT_FOUND && count > 0){
      dictdb_free (dict_data);
      return;
   }

   exit_code = dictdb_search (
      dict_data, "00databaseallchars", -1,
      dict_data -> m_strat_exact,
      &ret,
      NULL, 0,
      &defs, &defs_sizes,
      &count);

   if (!exit_code && ret == DICT_PLUGIN_RESULT_FOUND && count > 0){
      dictdb_free (dict_data);
      return;
   }

   dictdb_free (dict_data);
   dict_data -> m_conf_all_chars = 0;
}

static int strcmp_ (const void *a, const void *b)
{
   return strcmp ((const char *) a, (const char *) b);
}

static void dbi_error (global_data *dict_data, dbi_conn conn)
{
   const char *dbi_err_msg = NULL;

   if (conn){
      dbi_conn_error (conn, &dbi_err_msg);
      plugin_error (dict_data, dbi_err_msg);
   }else{
      plugin_error (dict_data, "DBI connection canot be opened");
   }
}

static int init_dbi_conn (global_data *dict_data)
{
   dbi_conn *conn = &dict_data -> m_dbi_conn;
   const char *driver   = dict_data -> m_dbi_driver_name;
   const char *host     = dict_data -> m_dbi_option_host;
   const char *db_name  = dict_data -> m_dbi_option_dbname;
   const char *username = dict_data -> m_dbi_option_username;
   const char *password = dict_data -> m_dbi_option_password;

   if (
      (NULL == (*conn = dbi_conn_new (driver))) ||
      (host     && -1 == dbi_conn_set_option (*conn, "host", host)) ||
      (username && -1 == dbi_conn_set_option (*conn, "username", username)) ||
      (password && -1 == dbi_conn_set_option (*conn, "password", password)) ||
      (db_name  && -1 == dbi_conn_set_option (*conn, "dbname", db_name)))
   {
      if (*conn){
	 dbi_error (dict_data, *conn);
      }else{
	 plugin_error (dict_data, "cannot create dbi_conn");
      }

      return 12;
   }

   return 0;
}

/* returns zero if success */
static int connect_to_sqldb (
   global_data *dict_data)
{
#ifndef CONNECT_TO_SERVER_ONCE
   int err;

   err = init_dbi_conn (dict_data);
   if (err)
      return err;
#endif

   if (-1 == dbi_conn_connect (dict_data -> m_dbi_conn)){
      dbi_error (dict_data, dict_data -> m_dbi_conn);

      return 13;
   }

   return 0;
}

int dictdb_open (
   const dictPluginData *init_data,
   int init_data_size,
   int *version,
   void ** data)
{
   int i;
   int err;

   global_data *dict_data = global_data_create ();
   *data = (void *) dict_data;

   maa_init ("dictdplugin_dbi");

   err = heap_create (&dict_data -> m_heap, NULL);
   if (err){
      plugin_error (dict_data, heap_error (err));
      return 1;
   }

   err = heap_create (&dict_data -> m_heap2, NULL);
   if (err){
      plugin_error (dict_data, heap_error (err));
      return 2;
   }

   err = dbi_initialize (NULL);
   if (err < 1){
      plugin_error (dict_data, "cannot initialize DBI");
      return 3;
   }

   dict_data -> m_strategy2strategynum = hsh_create (hsh_string_hash, strcmp_);
   if (!dict_data -> m_strategy2strategynum){
      plugin_error (dict_data, "cannot initialize hash table");
      return 11;
   }

   if (version)
      *version = 0;

   for (i=0; i < init_data_size; ++i){
      switch (init_data [i].id){
      case DICT_PLUGIN_INITDATA_STRATEGY:
	 set_strat (
	    (const dictPluginData_strategy * ) init_data [i].data,
	    dict_data);

	 break;

      case DICT_PLUGIN_INITDATA_DICT:
	 {
	    int len = init_data [i].size;
	    char *buf = NULL;

	    if (-1 == len)
	       len = strlen (init_data [i].data);

	    buf = xstrdup (init_data [i].data);

	    process_lines (buf, len, dict_data, process_name_value, on_error);

	    if (dict_data -> m_err_msg [0]){
	       dictdb_free (dict_data);
	       return 4;
	    }

	    if (buf)
	       xfree (buf);
	 }
	 break;

      case DICT_PLUGIN_INITDATA_ALPHABET_8BIT:
	 dict_data -> m_alphabet_global_8bit = xstrdup (init_data [i].data);

	 break;
      case DICT_PLUGIN_INITDATA_ALPHABET_ASCII:
	 dict_data -> m_alphabet_global_ascii = xstrdup (init_data [i].data);

	 break;

      default:
	 break;
      }
   }

   if (dict_data -> m_err_msg [0])
      return 7;

#ifdef CONNECT_TO_SERVER_ONCE
   //
   err = init_dbi_conn (dict_data);
   if (err)
      return err;

   //
   err = connect_to_sqldb (dict_data);
   if (err)
      return err;
#endif

   init_allchars (dict_data);

   return 0;
}

int dictdb_close (void *data)
{
   global_data_destroy (data);

   dbi_shutdown ();

   maa_shutdown ();

   return 0;
}

const char *dictdb_error (void *dict_data)
{
   global_data *data = (global_data *) dict_data;

   if (data -> m_err_msg [0])
      return data -> m_err_msg;
   else
      return NULL;
}

#define DBI_CONN_CLOSE(conn)   \
   if ((conn))                 \
      dbi_conn_close ((conn)); \
   (conn) = NULL;

int dictdb_free (void * data)
{
   int i;
   global_data *dict_data = (global_data *) data;
//   fprintf (stderr, "dictdb_free\n");

   if (dict_data){
      free_minus1_array (dict_data -> m_mres_sizes);
      dict_data -> m_mres_sizes = NULL;

      for (i = 0; i < dict_data -> m_mres_count; ++i){
	 heap_free (dict_data -> m_heap, (void *) dict_data -> m_mres [i]);
      }
      dict_data -> m_mres_count = 0;

      heap_free (dict_data -> m_heap2, dict_data -> m_mres);
      dict_data -> m_mres = NULL;
   }


   DBI_CONN_CLOSE(dict_data -> m_dbi_conn);

   return 0;
}

/* returns zero if success */
static int copy_sqlres (
   dbi_conn conn,
   const char *query,
//   lst_List list,
   global_data *dict_data)
{
   dbi_result result;
   const char *headword = NULL;
   int number_of_fields = 0;
   int number_of_rows   = 0;
   int num;

//   fprintf (stderr, "query: %s\n", query);
   result = dbi_conn_query (conn, query);
   if (!result){
      dbi_error (dict_data, conn);
      return 8;
   }

   number_of_fields = dbi_result_get_numfields (result);
   if (1 != number_of_fields){
      plugin_error (
	 dict_data,
	 "SQL query should return the rows having one field only.");
      dbi_result_free (result);
      return 4;
   }

   number_of_rows = dbi_result_get_numrows (result);
   if (!number_of_rows){
      dbi_result_free (result);
      return 0;
   }

   dict_data -> m_mres = (const char **)
      heap_alloc (
	 dict_data -> m_heap2,
	 number_of_rows * sizeof (dict_data -> m_mres [0]));
   memset (
      dict_data -> m_mres,
      0,
      number_of_rows * sizeof (dict_data -> m_mres [0]));

   dict_data -> m_mres_count = number_of_rows;
   dict_data -> m_mres_sizes = (int *) alloc_minus1_array (number_of_rows);

   num = 0;
   while (dbi_result_next_row (result)) {
      headword = dbi_result_get_string_idx (result, 1);
      if (!headword){
	 plugin_error (dict_data, "dbi_result_get_string_idx failed");
	 dbi_result_free (result);
	 return 5;
      }

      dict_data -> m_mres [num] = heap_strdup (dict_data -> m_heap, headword);
      ++num;
   }

   dbi_result_free (result);

   return 0;
}

static int run_sql_query (
   global_data *dict_data,
   const char *query)
{
   int err = 0;

//   dict_data -> m_dbi_driver = dbi_conn_get_driver (dict_data -> m_dbi_conn);

#ifndef CONNECT_TO_SERVER_ONCE
   if (connect_to_sqldb (dict_data)){
      dbi_error (dict_data, dict_data -> m_dbi_conn);

      DBI_CONN_CLOSE(dict_data -> m_dbi_conn);

      return 14;
   }
#endif

   err = copy_sqlres (
      dict_data -> m_dbi_conn, query, dict_data);

   if (err){
#ifdef CONNECT_TO_SERVER_ONCE
//      fprintf (stderr, "copy_sqlres returned %i\n", err);
//      fprintf (stderr, "  error message: `%s`\n", dict_data -> m_err_msg);

      // try to restore connection
      DBI_CONN_CLOSE(dict_data -> m_dbi_conn);

      if (
	 connect_to_sqldb (dict_data) ||
	 copy_sqlres (
	    dict_data -> m_dbi_conn, query, dict_data))
      {
	 dbi_error (dict_data, dict_data -> m_dbi_conn);

	 DBI_CONN_CLOSE(dict_data -> m_dbi_conn);

	 return 10;
      }
#else
      dbi_error (dict_data, dict_data -> m_dbi_conn);

      DBI_CONN_CLOSE(dict_data -> m_dbi_conn);

      return 10;
#endif
   }

#ifndef CONNECT_TO_SERVER_ONCE
   DBI_CONN_CLOSE(dict_data -> m_dbi_conn);
#endif

   return 0;
}

static int fmt_query (
   global_data *dict_data,
   char *buffer, size_t len,
   const char *fmt,  /* something containing %%, %q and ordinary symbols */
   const char *word) /* query */
{
   size_t word_len = strlen (word);

   while (*fmt){
      if (len < 3){
	 plugin_error (dict_data, "too long query1");
	 return 1;
      }

      switch (*fmt){
      case '%':
	 switch (fmt [1]){
	 case '\0':
	    *buffer++ = '%';
	    *buffer++ = '\0';
	    return 0;

	 case '%':
	    *buffer++ = '%';
	    --len;
	    fmt  += 2;
	    break;

	 case 'q':
	    if (len < word_len+1){
	       plugin_error (dict_data, "too long query2");
	       return 1;
	    }

	    strcpy (buffer, word);
	    len    -= word_len;
	    buffer += word_len;
	    fmt    += 2;
	    break;

	 default:
	    plugin_error (dict_data, "%% and %q are allowed only");
	    return 1;
	 }
	 break;

      default:
	 *buffer++ = *fmt++;
	 --len;
      }
   }

   *buffer = 0;

   return 0;
}

/* set dict_data->m_mres_count and dict_data->m_mres */
static int match (
   global_data *dict_data,
   int strat,
   const char *word)
{
   char query [BUFSIZE];
   const char *query_fmt = NULL;

   if (!word [0])
      return 0;

   query_fmt = strategynum2query (dict_data, strat);
   if (!query_fmt)
      return 0;

   if (fmt_query (dict_data, query, BUFSIZE, query_fmt, word))
      return 1;

   return run_sql_query (dict_data, query);
}

/* set dict_data->m_mres_count and dict_data->m_mres */
static int define (
   global_data *dict_data,
   const char *word)
{
   return match (dict_data, -1, word);
}

int dictdb_search (
   void *data,
   const char *word, int word_size,
   int search_strategy,
   int *ret,
   const char **result_extra, int *result_extra_size,
   const char * const* *result,
   const int **result_sizes,
   int *results_count)
{
   int match_search_type;
   char word_copy2 [BUFSIZE];
   int exit_code = 0;

   global_data *dict_data = (global_data *) data;

//   fprintf (stderr, "dictdb_search %s\n", word);

   if (result_extra)
      *result_extra      = NULL;
   if (result_extra_size)
      *result_extra_size = 0;
   if (result_sizes)
      *result_sizes     = NULL;

   *ret = DICT_PLUGIN_RESULT_NOTFOUND;

   if (-1 == word_size){
      word_size = strlen (word);
   }

   match_search_type = search_strategy & DICT_MATCH_MASK;
   search_strategy &= ~DICT_MATCH_MASK;

   assert (!dict_data -> m_mres);
   assert (!dict_data -> m_mres_sizes);
   assert (!dict_data -> m_mres_count);
   assert (heap_isempty (dict_data -> m_heap));

   strlcpy (word_copy2, word, sizeof (word_copy2));

   if (
      tolower_alnumspace (
	 word_copy2, word_copy2,
	 dict_data -> m_conf_all_chars, 0, dict_data -> m_conf_utf8))
   {
      plugin_error (dict_data, "tolower_alnumspace in dictdb_search failed");
      return 7;
   }

   if (match_search_type){
      /* MATCH command */

      dict_data -> m_mres_count = 0;

      exit_code = match (dict_data, search_strategy, word_copy2);
   }else{
      /* DEFINE command */

      exit_code = define (dict_data, word_copy2);
   }

   if (exit_code)
      return exit_code;

   if (!dict_data -> m_mres_count)
      return 0;

   dict_data -> m_mres_sizes =
   (int *) alloc_minus1_array (dict_data -> m_mres_count);

   *result        = dict_data -> m_mres;
   *result_sizes  = dict_data -> m_mres_sizes;
   *results_count = dict_data -> m_mres_count;

   *ret = DICT_PLUGIN_RESULT_FOUND;

   return 0;
}
