/* dictdplugin_judy.c -- 
 * Created: Tue Aug  5 19:19:48 2003 by vle@gmx.net
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
#include "data.h"
#include "str.h"
#include "plugins_common.h"

#include <maa.h>
#include <Judy.h>

#if STRING_H
#include <string.h>
#endif

#include <stdio.h>
#include <errno.h>

#if HAVE_LIMITS_H
#include <limits.h>
#endif

#if WCTYPE_H
#include <ctype.h>
#endif

#define BUFSIZE 4096

#ifndef BOOL
#define BOOL char
#endif

/**********************************************************/

//#define DONOT_USE_INTERNAL_HEAP /* internal heap may speed-up the plugin */

#include "heap.h"

typedef struct global_data_s {
   char m_err_msg  [BUFSIZE];

   void *m_heap;
   void *m_heap2;

   int m_mres_count;
   const char ** m_mres;
   int *m_mres_sizes;

   int *m_offs_size_array;
   dictData *m_data;

   int m_strat_exact;
   int m_strat_prefix;
   int m_strat_lev;
   int m_strat_word;

   Pvoid_t m_judy_array;
   size_t  m_max_hw_len;

   char m_conf_index_fn  [NAME_MAX+1];
   char m_conf_data_fn   [NAME_MAX+1];
   char m_default_db_dir [NAME_MAX+1];

   BOOL m_conf_allchars;
   BOOL m_conf_utf8;

   BOOL m_flag_allchars;
   BOOL m_flag_utf8;

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

   d -> m_strat_exact     = -1;
   d -> m_strat_prefix    = -1;
   d -> m_strat_lev       = -1;
   d -> m_strat_word      = -1;

   return d;
}

static void global_data_destroy (global_data *d)
{
   dictdb_free (d);

   if (d -> m_offs_size_array)
      xfree (d -> m_offs_size_array);

   if (d -> m_alphabet)
      xfree (d -> m_alphabet);

   if (d -> m_alphabet_global_8bit)
      xfree (d -> m_alphabet_global_8bit);

   if (d -> m_alphabet_global_ascii)
      xfree (d -> m_alphabet_global_ascii);

   JudySLFreeArray (&d -> m_judy_array, 0);
   heap_destroy (&d -> m_heap);
   heap_destroy (&d -> m_heap2);

   dict_data_close (d -> m_data);

   if (d)
      xfree (d);
}

/********************************************************************/

static void set_strat (
   const dictPluginData_strategy * strat_data,
   global_data * dict_data)
{
   if (!strcmp (strat_data -> name, "exact")){
      dict_data -> m_strat_exact = strat_data -> number;
   }else if (!strcmp (strat_data -> name, "prefix")){
      dict_data -> m_strat_prefix = strat_data -> number;
   }else if (!strcmp (strat_data -> name, "lev")){
      dict_data -> m_strat_lev = strat_data -> number;
   }else if (!strcmp (strat_data -> name, "word")){
      dict_data -> m_strat_word = strat_data -> number;
   }
}

static void concat_dir_and_fn (
   char *dest, size_t dest_size, const char *dir, const char *fn)
{
   if (fn [0] != '/'){
      strlcpy (dest, dir, dest_size);

      if (dest [strlen (dest) - 1] != '/')
	 strlcat (dest, "/", dest_size);

      strlcat (dest, fn, dest_size);
   }else{
      strlcpy (dest, fn, dest_size);
   }
}

static BOOL split_index (
   global_data *dict_data,
   char *buf,
   unsigned long *def_offset,
   unsigned long *def_size)
{
   char *tab          = 0;
   char *def_offset_s = 0;
   char *def_size_s   = 0;

   tab = strchr (buf, '\t');
   if (!tab){
      plugin_error (dict_data, "corrupted index file");
      return 0;
   }

   *tab = 0;
   def_offset_s = tab + 1;

   tab = strchr (def_offset_s, '\t');
   if (!tab){
      plugin_error (dict_data, "corrupted index file");
      return 0;
   }
   *tab = 0;
   def_size_s = tab + 1;

   *def_offset = b64_decode (def_offset_s);
   *def_size   = b64_decode (def_size_s);

   return 1;
}

static void it_incr1 (
   global_data *dict_data,
   PPvoid_t value,
   const char* word,
   unsigned long offs,
   unsigned long size)
{
   if (
      !strcmp (word, "00-database-utf8") ||
      !strcmp (word, "00databaseutf8"))
   {
      dict_data -> m_flag_utf8 = 1;
   }

   if (
      !strcmp (word, "00-database-allchars") ||
      !strcmp (word, "00databaseallchars"))
   {
      dict_data -> m_flag_allchars = 1;
   }

   ++ *(PWord_t) value;
}

/* iterate over entries WORD/VALUE in judy array JUDY */
#define JUDY_ITERATE(JUDY,VALUE,WORD)            \
   for (;                                        \
        VALUE;                                   \
        VALUE = JudySLNext (JUDY, (uint8_t *) WORD, 0))

#define JUDY_ITERATE_ALL(JUDY,VALUE,WORD)        \
   WORD [0] = 0;                                 \
   VALUE = JudySLFirst (JUDY, (uint8_t *) WORD, 0); \
   JUDY_ITERATE(JUDY,VALUE,WORD)

/*
static void debug_print (global_data *dict_data)
{
   char word [BUFSIZE] = "";
   PPvoid_t value;

   assert (sizeof (word) > dict_data -> m_max_hw_len);

   JUDY_ITERATE_ALL (dict_data -> m_judy_array, value, word){
      fprintf (stderr, "%s --> %li\n", word, * (PWord_t) value);
   }
}
*/

static Word_t count2offs (global_data *dict_data)
{
   char word [BUFSIZE] = "";
   PPvoid_t value;
   Word_t sum = 0;
   Word_t val;

   assert (sizeof (word) > dict_data -> m_max_hw_len);

   JUDY_ITERATE_ALL (dict_data -> m_judy_array, value, word){
      val = (*(PWord_t) value);
      *(PWord_t) value = sum;
      sum += val;
   }

   return sum;
}

static void read_index_file (
   global_data *dict_data,
   void (*fun) (
      global_data *dict_data,
      PPvoid_t value,
      const char* word,
      unsigned long offs,
      unsigned long size))
{
   char buf [BUFSIZE];
   FILE *fd       = 0;
   PPvoid_t value = NULL;
   int word_count = 0;

   unsigned long def_offset;
   unsigned long def_size;

   size_t len;

   fd = fopen (dict_data -> m_conf_index_fn, "r");
   if (!fd){
      plugin_error (dict_data, strerror(errno));
      return;
   }

   while (fgets (buf, BUFSIZE, fd) != (char *) NULL){
      if ('\n' == buf [strlen (buf) - 1])
	 buf [strlen (buf) - 1] = 0;

      if (!split_index (dict_data, buf, &def_offset, &def_size)){
	 fclose (fd);
	 return;
      }

      if (
	 tolower_alnumspace (
	    buf, buf,
	    dict_data -> m_conf_allchars, 0, dict_data -> m_conf_utf8))
      {
	 plugin_error (dict_data, "tolower_alnumspace failed while reading .index file");
	 fclose (fd);
	 return;
      }

      len = strlen (buf);
      if (len > dict_data -> m_max_hw_len)
	 dict_data -> m_max_hw_len = len;

      value = JudySLIns (&dict_data -> m_judy_array, (uint8_t *) buf, 0);
      assert (value != (PPvoid_t) 0 && value != (PPvoid_t) -1);

      (*fun) (dict_data, value, buf, def_offset, def_size);

      ++word_count;
   }

   if (ferror (fd)){
      fclose (fd);
      plugin_error (dict_data, "reading error");
      return;
   }

   fclose (fd);
}

static void it_fill_array (
   global_data *dict_data,
   PPvoid_t value,
   const char* word,
   unsigned long offs,
   unsigned long size)
{
   Word_t val = * (PWord_t) value;

   while (dict_data -> m_offs_size_array [val + val + 0] != -1){
      ++val;
   }

   dict_data -> m_offs_size_array [val + val + 0] = offs;
   dict_data -> m_offs_size_array [val + val + 1] = size;
}

static void init_index_file (global_data *dict_data)
{
   Word_t sum  = 0;
   size_t array_size = 0;

   char word [BUFSIZE]="";
   PPvoid_t value;
   Word_t val;

   dict_data -> m_judy_array = NULL;

   read_index_file (dict_data, it_incr1);
   if (dict_data -> m_err_msg [0])
      return;

   if (!dict_data -> m_conf_utf8 && dict_data -> m_flag_utf8){
      plugin_error (
	 dict_data,
	 "'utf-8' flag in plugin configuration and database files differ");
      return;
   }

   if (dict_data -> m_conf_allchars != dict_data -> m_flag_allchars){
      plugin_error (
	 dict_data,
	 "'allchars' flag in the plugin configuration and database files differ");
      return;
   }

/*   debug_print (dict_data); */

   sum = count2offs (dict_data);
   array_size = 2 * (sum/* + 1*/) * sizeof (int);

   assert (sizeof (word) > dict_data -> m_max_hw_len);

   dict_data -> m_offs_size_array = xmalloc (array_size);
   memset (dict_data -> m_offs_size_array, -1, array_size);

   read_index_file (dict_data, it_fill_array);
   if (dict_data -> m_err_msg [0])
      return;

   JUDY_ITERATE_ALL (dict_data -> m_judy_array, value, word){
      val = *(PWord_t) value;
      *value = dict_data -> m_offs_size_array + val * 2;
/*
	fprintf (stderr, "%s --> %p\n", word, *value);
	fprintf (stderr, "%s --> %li\n", word, *(PWord_t)value - (long)dict_data -> m_offs_size_array);
*/
   }
/*
   JUDY_ITERATE_ALL (dict_data -> m_judy_array, value, word){
      fprintf (
	 stderr,
	 "%s --> %i %i\n",
	 word,
	 ((int *) *value) [0],
	 ((int *) *value) [1]);
   }
*/
}

static void init_data_file (global_data *dict_data)
{
   assert (!dict_data -> m_data);

   dict_data -> m_data = dict_data_open (dict_data -> m_conf_data_fn, 0);
}

static int process_name_value (
   const char *option, const char *value,
   void *data)
{
   global_data *dict_data = (global_data *) data;

   if (!strcmp(option, "allchars")){
      if (strcmp (value, "0") && strcmp (value, "")){
         dict_data -> m_conf_allchars = 1;
      }
   }else if (!strcmp(option, "utf8")){
      if (strcmp (value, "0") && strcmp (value, "")){
         dict_data -> m_conf_utf8 = 1;
      }
   }else if (!strcmp(option, "index")){
      concat_dir_and_fn (
         dict_data -> m_conf_index_fn,
         sizeof (dict_data -> m_conf_index_fn),
         dict_data -> m_default_db_dir,
         value);
   }else if (!strcmp(option, "data")){
      concat_dir_and_fn (
         dict_data -> m_conf_data_fn,
         sizeof (dict_data -> m_conf_data_fn),
         dict_data -> m_default_db_dir,
         value);
   }

   return 0;
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

   err = heap_create (&dict_data -> m_heap, NULL);
   if (err){
      plugin_error (dict_data, heap_error (err));
      return 2;
   }

   err = heap_create (&dict_data -> m_heap2, NULL);
   if (err){
      plugin_error (dict_data, heap_error (err));
      return 3;
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

	    buf = xstrdup(init_data [i].data);

	    process_lines (buf, len, dict_data, process_name_value, on_error);

	    if (dict_data -> m_err_msg [0]){
	       dictdb_free (dict_data);
	       return 4;
	    }

	    if (buf)
	       xfree (buf);

	    if (!dict_data -> m_conf_index_fn [0]){
	       plugin_error (dict_data, "missing 'index' option");
	       return 5;
	    }

	    if (!dict_data -> m_conf_data_fn [0]){
	       plugin_error (dict_data, "missing 'data' option");
	       return 6;
	    }
	 }
	 break;

      case DICT_PLUGIN_INITDATA_DEFDBDIR:
	 strlcpy (
	    dict_data -> m_default_db_dir,
	    init_data [i].data,
	    sizeof (dict_data -> m_default_db_dir));
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

   init_index_file (dict_data);
   init_data_file  (dict_data);

   if (dict_data -> m_err_msg [0])
      return 7;

   if (dict_data -> m_max_hw_len > BUFSIZE - 100){
      plugin_error (dict_data, "Index file contains too long word");
      return 8;
   }

   init_alphabet (dict_data);

/*   debug_print (dict_data); */
   return 0;
}

int dictdb_close (void *data)
{
   global_data_destroy (data);
   return 0;
}

const char *dictdb_error (void *dict_data)
{
   global_data *data = (global_data *)dict_data;

   if (data -> m_err_msg [0])
      return data -> m_err_msg;
   else
      return NULL;
}

int dictdb_free (void * data)
{
   int i;
   global_data *dict_data = (global_data *) data;
/*   fprintf (stderr, "dictdb_free\n"); */

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

   return 0;
}

/* set dict_data->m_mres_count and dict_data->m_mres */
static int match_exact (
   global_data *dict_data,
   const char *word)
{
   int const * const *result_curr;

   if (!word [0])
      return 0;

   result_curr = (int const *const *) JudySLGet (
      dict_data -> m_judy_array, (uint8_t *) word, 0);

   if (!result_curr){
      return 0;
   }

   dict_data -> m_mres = (const char **)
      heap_alloc (dict_data -> m_heap2, sizeof (dict_data -> m_mres [0]));

   dict_data -> m_mres [0] =
      heap_strdup (dict_data -> m_heap, word);

   dict_data -> m_mres_count = 1;

   return 0;
}

static int match_prefix (
   global_data *dict_data,
   const char *word)
{
   PPvoid_t value;

   char curr_word [BUFSIZE];
   size_t len = strlen (word);
   int cmp_res;

   strlcpy (curr_word, word, sizeof (curr_word));

   value = JudySLGet (dict_data -> m_judy_array, (uint8_t *) curr_word, 0);
   if (!value)
      value = JudySLNext (dict_data -> m_judy_array, (uint8_t *) curr_word, 0);

/*   fprintf (stderr, "first=%s %p\n", curr_word, value);*/

   for (
      ;
      value;
      value = JudySLNext (dict_data -> m_judy_array, (uint8_t *) curr_word, 0))
   {
      cmp_res = strncmp (word, curr_word, len);

      if (cmp_res){
/*	    fprintf (stderr, "%s != %s\n", word, curr_word); */
	 break;
      }

      ++dict_data -> m_mres_count;

      dict_data -> m_mres = (const char **)
	 heap_realloc (
	    dict_data -> m_heap2,
	    dict_data -> m_mres,
	    dict_data -> m_mres_count * sizeof (dict_data -> m_mres [0]));

      dict_data -> m_mres [dict_data -> m_mres_count - 1] =
	 heap_strdup (dict_data -> m_heap, curr_word);
   }

   return 0;
}

#define CHECK(word, dict_data) \
   if ((word) [0]){                                              \
      value = JudySLGet ((dict_data) -> m_judy_array, ((uint8_t *) word), 0);\
      if (value && strcmp (prev_buf, (word))){                   \
         strlcpy (prev_buf, (word), BUFSIZE);                    \
                                                              \
         ++(dict_data) -> m_mres_count;                       \
                                                              \
         (dict_data) -> m_mres = (const char **)              \
            heap_realloc (                                    \
               (dict_data) -> m_heap2,                        \
               (dict_data) -> m_mres,                         \
               (dict_data) -> m_mres_count                    \
                  * sizeof ((dict_data) -> m_mres [0]));      \
         (dict_data) -> m_mres [(dict_data) -> m_mres_count - 1] = \
            heap_strdup ((dict_data) -> m_heap, (word));      \
      }                                                       \
   }

#define LEV_VARS \
   PPvoid_t value; \
   char prev_buf [BUFSIZE] = ""; \
   char tmp;

#define LEV_ARGS global_data

static char const global_alphabet [] =
   "qwertyuiopasdfghjklzxcvbnm0123456789";

#include "lev.h"

static int match_lev (
   global_data *dict_data,
   const char *word)
{
   const char *alphabet = dict_data -> m_alphabet;

   if (!alphabet)
      alphabet = global_alphabet;

   dict_search_lev (word, alphabet, dict_data -> m_flag_utf8, dict_data);
   return 0;
}

static int match_word (
   global_data *dict_data,
   const char *word)
{
   return 0;
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
	 dict_data -> m_conf_allchars, 0, dict_data -> m_conf_utf8))
   {
      plugin_error (dict_data, "tolower_alnumspace in dictdb_search failed");
      return 1;
   }

   if (word_size > dict_data -> m_max_hw_len){
/*      fprintf (stderr, "This word is too long\n"); */
      return 0;
   }

   if (match_search_type){
      /* MATCH command */

      dict_data -> m_mres_count = 0;

      if (search_strategy == dict_data -> m_strat_exact){
	 exit_code = match_exact (
	    dict_data, word_copy2);
      }else if (search_strategy == dict_data -> m_strat_word){
	 exit_code = match_word (
	    dict_data, word_copy2);
      }else if (search_strategy == dict_data -> m_strat_prefix){
	 exit_code = match_prefix (
	    dict_data, word_copy2);
      }else if (search_strategy == dict_data -> m_strat_lev){
	 exit_code = match_lev (
	    dict_data, word_copy2);
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
   }else{
      /* DEFINE command */

      int const * const * offs_size;
      int const * const * offs_size_next;
      int cnt;
      int i;

      if (!word_copy2 [0])
	 return 0;

      offs_size = (int const *const *) JudySLGet (
	 dict_data -> m_judy_array, (uint8_t *) word_copy2, 0);

      if (!offs_size)
	 return 0;

      offs_size_next = (const int *const *) JudySLNext (
	 dict_data -> m_judy_array, (uint8_t *) word_copy2, 0);

      if (offs_size_next){
	 cnt = (const int *) *offs_size_next - (const int *) *offs_size;
	 cnt /= 2;
      }else{
	 cnt = 1;/* fix this */;
      }

      dict_data -> m_mres =
	 (const char **) heap_alloc (
	    dict_data -> m_heap2,
	    cnt * sizeof (dict_data -> m_mres [0]));
      dict_data -> m_mres_sizes = (int *) alloc_minus1_array (cnt);

      dict_data -> m_mres_count = cnt;

      for (i = 0; i < cnt; ++i){
	 dict_data -> m_mres [i] =
	    dict_data_read_ (
	       dict_data -> m_data,
	       (*offs_size) [i + i], (*offs_size) [i + i + 1],
	       NULL, NULL);
      }

      *result        = dict_data -> m_mres;
      *result_sizes  = dict_data -> m_mres_sizes;
      *results_count = cnt;
      *ret           = DICT_PLUGIN_RESULT_FOUND;

      return 0;
   }
}
