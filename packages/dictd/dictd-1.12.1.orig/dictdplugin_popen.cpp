/* dictdplugin_popen.cpp -- 
 * Created: Mon Sep  16 14:54 2002 by Aleksey Cheusov <vle@gmx.net>
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
 *
 **************************************************************************
 * 
 * This is the example of dictd plugin.
 * It runs an external program giving them a word to be search and
 * search strategy returning stdout as a word definition or
 * a list of matches.
 * usage:
 *    searcher <strategy> <word>
 *      This call is used for MATCH queries.
 *      Each line from stdout is the found match.
 *    searcher <word>
 *      This call is used for DEFINE queries.
 *      Stdout is the word definition.
 *
 * It obviously works slowly.
 * Do not use it at all or use it carefully!
 *
 * Format of the 00-database-plugin-data entry:
 *  <command_line>
 *  <valid_characters>
 *
 *  Run 'dictfmt_plugin --help' for a help
 */

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string>
#include <unistd.h>
#include <sstream>
#include <list>
#include <assert.h>
#include <string.h>

#include "dictdplugin.h"

class global_data {
public:
   std::string m_err_msg;
   std::string m_command;
   std::string m_result;
   char *      m_result_buf;

   const char * m_res;
   int m_res_size;

   const char ** m_mres;
   int *m_mres_sizes;

   int m_errno;
   int m_status;

   char m_valid_chars [UCHAR_MAX + 1];
   dictPluginData_strategy *m_strategies;

   global_data ();
   ~global_data ();
};

global_data::global_data ()
{
   m_res        = 0;
   m_res_size   = 0;

   m_mres       = 0;
   m_mres_sizes = 0;

   m_errno      = 0;
   m_status     = 0;

   m_result_buf = NULL;
   m_strategies = NULL;

   memset (m_valid_chars, 0, sizeof (m_valid_chars));
}

global_data::~global_data ()
{
   if (m_strategies)
      delete [] m_strategies;

   if (m_mres_sizes)
      delete [] m_mres_sizes;

   if (m_mres)
      delete [] m_mres;

   if (m_result_buf)
      free (m_result_buf);
}

extern "C" {
   int dictdb_close (void *dict_data);
   int dictdb_open (
      const dictPluginData *init_data,
      int /*init_data_size*/,
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
};

int dictdb_open (
   const dictPluginData *init_data,
   int init_data_size,
   int *version,
   void ** dict_data)
{
   if (version)
      *version = 0;

   global_data *data = new global_data;

   *dict_data = (void *) data;

   int max_strat_num = -1;

   int i;
   for (i=0; i < init_data_size; ++i){
      switch (init_data [i].id){
      case DICT_PLUGIN_INITDATA_STRATEGY:
	 {
	    const dictPluginData_strategy *strat_data =
	       (const dictPluginData_strategy * ) init_data [i].data;
//	    std::cerr << "strat number: " << strat_data -> number << '\n';
//	    std::cerr << "strat name: " << strat_data -> name << '\n';
	    if (strat_data -> number > max_strat_num)
	       max_strat_num = strat_data -> number;
	 }
	 break;
      case DICT_PLUGIN_INITDATA_DICT:
	 {
	    std::stringstream ostr;
	    if (-1 == init_data [i].size)
	       ostr << (const char *) init_data [i].data << '\0';
	    else
	       ostr << std::string ((const char *) init_data [i].data, init_data [i].size) << '\0';

	    std::getline (ostr, data -> m_command);

	    std::string valid_chars;
	    std::getline (ostr, valid_chars);

	    if (ostr.fail () && !ostr.eof ())
	       return 5;

	    for (
	       const char *p = valid_chars.c_str ();
	       *p;
	       ++p)
	    {
	       data -> m_valid_chars [(unsigned char) *p] = 1;
	    }
	 }
	 break;
      default:
				/* skipped */
	 break;
      }
   }

   ++max_strat_num;

   assert (max_strat_num > 0);
   data -> m_strategies = new dictPluginData_strategy [max_strat_num];
   memset (data -> m_strategies, 0, sizeof(dictPluginData_strategy) * max_strat_num);

   for (i=0; i < init_data_size; ++i){
      switch (init_data [i].id){
      case DICT_PLUGIN_INITDATA_STRATEGY:
	 const dictPluginData_strategy *strat_data =
	    (const dictPluginData_strategy * ) init_data [i].data;
	 data -> m_strategies [strat_data -> number] = *strat_data;
	 break;
      }
   }

   return 0;
}

int dictdb_close (void *dict_data)
{
   dictdb_free (dict_data);

   global_data *data = (global_data *) dict_data;
   delete data;

   return 0;
}

const char *dictdb_error (void *dict_data)
{
   global_data *data = (global_data *)dict_data;

   switch (data -> m_status){
   case 0:
      return  NULL;
   case 1:
      data -> m_err_msg = "popen() failed :";
      break;
   case 2:
      data -> m_err_msg = "ferror() failed :";
      break;
   default :
      fprintf (stderr, "%s: invalid plugin exit status\n", __FUNCTION__);
      exit (3);
   }

   if (data -> m_errno){
      data -> m_err_msg += strerror (data -> m_errno);
   }

   if (data -> m_err_msg.size ())
      return data -> m_err_msg.c_str ();
   else
      return NULL;
}

int dictdb_free (void * dict_data)
{
   global_data *data = (global_data *) dict_data;

   delete [] data -> m_mres;
   data -> m_mres = NULL;

   delete [] data -> m_mres_sizes;
   data -> m_mres_sizes = NULL;

   free (data -> m_result_buf);
   data -> m_result_buf = NULL;

   data -> m_result  = "";
   data -> m_err_msg = "";

   return 0;
}

int dictdb_search (
   void *dict_data,
   const char *word, int word_size,
   int search_strategy,
   int *ret,
   const char **result_extra, int *result_extra_size,
   const char * const* *result,
   const int **result_sizes,
   int *results_count)
{
   dictdb_free (dict_data);

// init
   global_data *data = (global_data *)dict_data;

   if (result_extra)
      *result_extra      = NULL;
   if (result_extra_size)
      *result_extra_size = 0;
   if (result_sizes)
      *result_sizes     = NULL;

   *ret = DICT_PLUGIN_RESULT_NOTFOUND;

// Is this for me?
   if (-1 == word_size)
      word_size = strlen (word);

   const int match_search_type = search_strategy & DICT_MATCH_MASK;
   search_strategy &= ~DICT_MATCH_MASK;

//   fprintf (stderr, "is it for me?\n");

// does the WORD contain valid characters only?
   for (int i = 0; i < word_size; ++i){
      if (!data -> m_valid_chars [(unsigned char) word [i]])
	 return 0;
   }

//   fprintf (stderr, "WORD: %s\n", word);

   std::string pipe (data -> m_command);
   if (match_search_type){
      pipe += ' ';
      pipe += data -> m_strategies [search_strategy].name;
   }
   pipe += " \'";
   pipe += std::string (word, word_size);
   pipe += '\'';

//   std::cerr << pipe << '\n';

// opening a pipe
   FILE *fd = popen (pipe.c_str (), "r");
   if (!fd){
      data -> m_errno  = errno;
      data -> m_status = 1;
      return 1;
   }

   data -> m_result = "";

// reading
   char buff [10000];
   int count = 0;

   *results_count = 0;
   do {
      count = fread (buff, 1, sizeof (buff) - 1, fd);
//      fgets (buff, sizeof (buff) - 1, fd);
      if (count > 0){
	 buff [count] = 0;

	 *results_count= 1;

	 data -> m_result += buff;
      }
   }while (!ferror (fd) && count == sizeof (buff) - 1);

   if (ferror (fd) && !feof (fd)){
      data -> m_errno = errno;
      data -> m_status = 2;
      pclose (fd);
      return 2;
   }

   pclose (fd);

   if (0 == *results_count)
      return 0;

   *ret = DICT_PLUGIN_RESULT_FOUND;

// prepearing results
   if (match_search_type){
      *results_count = 0;

      int buf_size = data -> m_result.size ();
      data -> m_result_buf = strdup (data -> m_result.c_str ());
      data -> m_result = "";

      char *p;
      for (p = data -> m_result_buf; *p;){
	 if ('\n' != *p && (p == data -> m_result_buf || p [-1] == 0)){
	    ++ *results_count;
	 }
	 if ('\n' == *p){
	    *p = 0;
	 }

	 ++p;
      }

      data -> m_mres       = new const char * [*results_count];
      data -> m_mres_sizes = new int [*results_count];

      p = data -> m_result_buf;
      int matches_count = 0;
      for (int i = 0; i<buf_size; ++i){
	 if (0 != *p && (!i || p [-1] == 0)){
	    data -> m_mres [matches_count]       = p;
	    data -> m_mres_sizes [matches_count] = -1;

	    ++matches_count;
	 }

	 ++p;
      }

      assert (matches_count == *results_count);

      *result       = data -> m_mres;
      *result_sizes = data -> m_mres_sizes;
   }else{
      data -> m_res            = data -> m_result.c_str ();
      data -> m_res_size       = data -> m_result.size ();

      *result        = &data -> m_res;
      *result_sizes  = &data -> m_res_size;
   }

   return 0;
}
