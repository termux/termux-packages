/* dictfmt.c -- 
 * Created: Sun Jul 20 20:17:11 1997 by faith@acm.org
 * Copyright 1997, 1998, 2003 Rickard E. Faith (faith@acm.org)
 * Copyright 2002-2008 Aleksey Cheusov (vle@gmx.net)
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
#include "str.h"

#include <maa.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <ctype.h>

#if HAVE_WCTYPE_H
#include <wctype.h>
#endif

#include <locale.h>

#if HAVE_GETOPT_H
#include <getopt.h>
#endif

#define FMT_MAXPOS  72
#define FMT_INDENT  0

#define JARGON    1
#define FOLDOC    2
#define EASTON    3
#define PERIODIC  4
#define HITCHCOCK 5
#define CIA1995   6
#define VERA      7
#define INDEXONLY 8

#define BSIZE 102400

static int  Debug;
static FILE *str;

/* defaults to creating ASCII database */
static int utf8_mode     = 0;
static int bit8_mode     = 0;

static int index_keep_orig_mode = 0;

static int allchars_mode = 0;
static int cs_mode       = 0;

static int quiet_mode    = 0;

static int dictfmt_ver_mode = 1;

static int indexonly_base64 = 0;

static const char *hw_separator     = "";
static const char *idxdat_separator = "\034";

static int         without_hw      = 0;
static int         without_header  = 0;
static int         without_url     = 0;
static int         without_time    = 0;
static int         without_info    = 0;
static int         break_headwords = 0;

static FILE *fmt_str;
static int  fmt_indent;
static int  fmt_pos;
static int  fmt_pending;
static int  fmt_hwcount;
static int  fmt_maxpos = FMT_MAXPOS;
static int  fmt_ignore_headword = 0;

static int ignore_hw_url       = 0;
static int ignore_hw_shortname = 0;
static int ignore_hw_info      = 0;
static int ignore_hw_def_strat = 0;

static const char *locale           = NULL;
static const char *default_strategy = NULL;
static const char *mime_header      = NULL;

static str_Pool alphabet_pool = NULL;

static int      type = 0;

/* analog to wcswidth(3) */
static int mbswidth_ (const char *s)
{
   int ret = 0;
   wchar_t wchar;

   int width;
   size_t len;
   mbstate_t ps;

   memset (&ps, 0, sizeof (ps));

   while (*s){
      len = mbrtowc__ (&wchar, s, MB_CUR_MAX__, &ps);

      switch (len){
      case (size_t) (-1):
      case (size_t) (-2):
	 return -1;

      default:
	 width = wcwidth__ (wchar);
	 if (-1 == width)
	    width = 1; /* we also count non-printable characters */

	 ret += width;
      }

      s += len;
   }

   return ret;
}

static void init (const char *fn)
{
   maa_init (fn);

   alphabet_pool = str_pool_create ();
}

static void destroy (void)
{
   str_pool_destroy (alphabet_pool);
   alphabet_pool = NULL;

/*   maa_shutdown ();*/
}

static void destroy_and_exit (int exit_status)
{
   destroy ();
   exit (exit_status);
}

static void fmt_openindex( const char *filename )
{
   char buffer [1024];

   if (bit8_mode || utf8_mode || allchars_mode)
      snprintf( buffer, sizeof (buffer), "sort -t '\t' -k 1,1 " );
   else
      snprintf( buffer, sizeof (buffer), "sort -t '\t' -df -k 1,1 " );

   if (filename){
      strlcat (buffer, "> ", sizeof (buffer));
      strlcat (buffer, filename, sizeof (buffer));
   }
   strlcat (buffer, "\n", sizeof (buffer));

   if (!(fmt_str = popen( buffer, "w" ))) {
      fprintf( stderr, "Cannot open %s for write\n", buffer );

      destroy_and_exit (1);
   }
}

static void fmt_newline( void )
{
   int i;

   if (!str){
      return;
   }

   if (fmt_ignore_headword){
      return;
   }

   fputc('\n', str);
   for (i = 0; i < fmt_indent; i++){
      fputc(' ', str);
   }

   fmt_pos     = 0;
   fmt_pending = 0;
}

static void fmt_wrap_and_print (const char *s)
{
   size_t len;
   int print_space;

   if (utf8_mode){
      len = mbswidth_ (s);
      if (len == (size_t) -1){
	 err_fatal (__func__, "'%s' is not a valid utf-8 string\n", s);
      }
   }else{
      len = strlen (s);
   }

   print_space = (fmt_pending || !len);

   if (fmt_pos && fmt_pos + print_space + len > fmt_maxpos){
      fmt_newline();
   }

   if (fmt_pending || !len){
      fputc (' ', str);
      ++fmt_pos;
   }

   if (len > 0){
      fprintf (str, "%s", s);
      fmt_pos += len;
      fmt_pending = 1;
   }
}

static void fmt_string( const char *s )
{
   char *sdup = NULL;
   char *pt   = NULL;
   char *p    = NULL;
#if 0
   char *t;
#endif

   if (!str)
      return;

   assert (s);

   if (fmt_ignore_headword){
      return;
   }

   sdup = strdup (s);
   p = pt = sdup;

   while ((pt = strchr(p, ' '))) {
      *pt = '\0';

      fmt_wrap_and_print (p /*pt == p ? " " : p*/);

      p = pt + 1;
   }

   if (*p)
      fmt_wrap_and_print (p);

   free(sdup);
}

#ifdef HAVE_UTF8
/*
  makes anagram of the 8-bit string 's'
  if length == -1 then str is 0-terminated string
*/
static void stranagram_8bit (char *s, int length)
{
   char* i = s;
   char* j;
   char v;

   assert (s);

   if (length == -1)
      length = strlen (s);

   j = s + length - 1;

   while (i < j){
      v = *i;
      *i = *j;
      *j = v;

      ++i;
      --j;
   }
}

/*
  makes anagram of the utf-8 string 's'
  Returns non-zero if success, 0 otherwise
*/
static int stranagram_utf8 (char *s)
{
   size_t len;
   char   *p;

   mbstate_t ps;

   assert (s);

   memset (&ps,  0, sizeof (ps));

   for (p = s; *p; ){
      len = mbrlen__ (p, MB_CUR_MAX__, &ps);
      if ((int) len < 0)
	 return 0; /* not a UTF-8 string */

      if (len > 1)
	 stranagram_8bit (p, len);

      p += len;
   }

   stranagram_8bit (s, -1);
   return 1;
}

#endif

/*
  Remove spaces at the end of the string
 */
static char *trim_right (char *s)
{
   wchar_t mbc;
   int len;

   if (!utf8_mode){
      len = strlen (s);

      while (len > 0 && isspace ((unsigned char) s [len - 1])){
	 s [--len] = 0;
      }

      return s;
   }else{
#ifdef HAVE_UTF8
      if (!stranagram_utf8 (s))
	 abort ();

      do {
	 len = mbtowc__ (&mbc, s, MB_CUR_MAX__);
	 assert (len >= 0);

	 if (len == 0 || !iswspace__ (mbc))
	    break;

	 s += len;
      }while (1);

      if (!stranagram_utf8 (s))
	 abort ();

#else
      abort();
#endif

      return s;
   }
}

/*
  Remove spaces at the beginning of the string
 */
static char *trim_left (char *s)
{
   wchar_t mbc;
   int len;

   if (!utf8_mode){
      while (isspace((unsigned char) *s)){
	 ++s;
      }

      return s;
   }else{
#ifdef HAVE_UTF8
      do {
	 len = mbtowc__ (&mbc, s, MB_CUR_MAX__);
	 assert (len >= 0);

	 if (len == 0 || !iswspace__ (mbc))
	    break;

	 s += len;
      }while (1);

#else
      abort();
#endif

      return s;
   }
}

/*
  Remove needless at the center of the string
 */
static void trim_center (char *s)
{
   wchar_t mbc;
   int len;
   char *h, *t;
   int prev_spc = 0;
   int spc = 0;

   if (!utf8_mode){
      h = t = s;

      while (*h){
	 spc = isspace ((unsigned char) *h);

	 if (spc && prev_spc){
	    ++h;
	 }else{
	    *t++ = *h++;
	 }

	 prev_spc = spc;
      }

      *t = 0;
   }else{
#ifdef HAVE_UTF8
      h = t = s;

      while (*h){
	 len = mbtowc__ (&mbc, h, MB_CUR_MAX__);
	 assert (len >= 0);

	 spc = iswspace__ (mbc);

	 if (spc && prev_spc){
	 }else{
	    memcpy (t, h, len);
	    t += len;
	 }
	 h += len;

	 prev_spc = spc;
      }

      *t = 0;
#else
      abort();
#endif
   }
}

/*
  Remove spaces at the beginning and the end of the string
 */
static char *trim_lcr (char *s)
{
/*   trim_center (s);*/
   trim_center (s);
   return trim_left (trim_right (s));
}

static int is_headword_special (const char *hw)
{
   return (!strncmp (hw, "00-database", 11) ||
	   !strncmp (hw, "00database", 10));
}

static void increase_fmt_hwcount ()
{
   if (!quiet_mode){
      if (fmt_hwcount && !(fmt_hwcount % 100)) {
	 fprintf( stderr, "%10d headwords\r", fmt_hwcount );
      }
   }

   ++fmt_hwcount;
}

static void write_hw_to_index (
   const char *word,
   const char *data,
   int start, int end)
{
   int len = 0;
   char *new_word = NULL;

   if (!word)
       return;

   increase_fmt_hwcount ();

   len = strlen (word);

   if (len > 0){
      new_word = malloc (len + 1);
      if (!new_word){
	 perror ("malloc failed");

	 destroy_and_exit (1);
      }

      if (tolower_alnumspace (
	     word, new_word, allchars_mode, cs_mode, utf8_mode))
      {
	 fprintf (stderr, "'%s' is not a UTF-8 string", word);

	 destroy_and_exit (1);
      }
      trim_center (new_word);

      fprintf( fmt_str, "%s\t%s\t", new_word, b64_encode(start) );
      fprintf( fmt_str, "%s", b64_encode(end-start) );

      if (!data && index_keep_orig_mode && strcmp (word, new_word)){
	 data = word;
      }

      if (data && !is_headword_special (word)){
	 fprintf( fmt_str, "\t%s\n", data);
      }else{
	 fprintf( fmt_str, "\n");
      }

      free (new_word);
   }
}

static char *split_and_write_hw_to_index (
   char *word, char *data, int start, int end)
{
   char *p = word;
   char *sep = NULL;

   char *idx_data_sep = NULL;
   size_t sep_len = 0;

   if (!data && idxdat_separator){
      idx_data_sep = strstr (word, idxdat_separator);
      if (idx_data_sep){
	 sep_len = strlen (idxdat_separator);
	 idx_data_sep [0] = 0;

	 data = idx_data_sep + sep_len;
      }
   }

   do {
      sep = NULL;
      if (hw_separator [0] && !is_headword_special (word)){
	 sep = strstr (p, hw_separator);
	 if (sep)
	    *sep = 0;
      }

      write_hw_to_index (trim_lcr (p), data, start, end);

      if (!sep)
	 break;

      p = sep + strlen (hw_separator);
   }while (1);

   return p;
}

static int contain_nonascii_symbol (const char *word)
{
   if (!word)
      return 0;

   while (*word){
      if (!isascii ((unsigned char) *word))
	 return 1;

      ++word;
   }

   return 0;
}

static void update_alphabet (const char *word)
{
   char *p;
   size_t len = 0;
   mbstate_t ps;
   char old_char;

   if (!word ||
       !strncmp (word, "00-database", 11) ||
       !strncmp (word, "00database", 10))
   {
      return;
   }

   len = strlen (word);
   p = (char *) alloca (len + 1);
   tolower_alnumspace (word, p, allchars_mode, cs_mode, utf8_mode);

   memset (&ps, 0, sizeof (ps));

   while (*p){
      len = utf8_mode ? mbrlen__ (p, MB_CUR_MAX__, &ps) : 1;
      assert ((int) len >= 0);

      old_char = p [len];
      p [len] = 0;
      str_pool_find (alphabet_pool, p);
      p [len] = old_char;

      p += len;
   }
}

/* return 1 if word should be skipped */
static int fmt_newheadword_special (const char *word)
{
   if (
      word &&
      (!strcmp (word, "00-database-default-strategy") ||
       !strcmp (word, "00databasedefaultstrategy")))
   {
      if (ignore_hw_def_strat){
	 fmt_ignore_headword = 1;
	 return 1;
      }

      /* we will ignore following occurences of 00-database-default-strategy*/
      ignore_hw_def_strat = 1;
   }

   if (
      word &&
      (!strcmp (word, "00-database-url") ||
       !strcmp (word, "00databaseurl")))
   {
      if (ignore_hw_url){
	 fmt_ignore_headword = 1;
	 return 1;
      }

      /* we will ignore all the following occurences of 00-database-url*/
      ignore_hw_url = 1;
   }

   if (
      word &&
      (!strcmp (word, "00-database-short") ||
       !strcmp (word, "00databaseshort")))
   {
      if (ignore_hw_shortname){
	 fmt_ignore_headword = 1;
	 return 1;
      }

      /* we will ignore all the following occurences of 00-database-short*/
      ignore_hw_shortname = 1;
   }

   if (
      word &&
      (!strcmp (word, "00-database-info") ||
       !strcmp (word, "00databaseinfo")))
   {
      if (ignore_hw_info){
	 fmt_ignore_headword = 1;
	 return 1;
      }

      /* we will ignore all the following occurences of 00-database-short*/
      ignore_hw_info = 1;
   }

   return 0;
}

static void fmt_test_nonascii (const char *word)
{
   if (!bit8_mode && !utf8_mode){
      if (contain_nonascii_symbol (word)){
	 fprintf (stderr, "\n8-bit head word \"%s\"is encountered while \"C\" locale is used\n", word);
	 destroy_and_exit (1);
      }
   }
}

static void fmt_newheadword( const char *word )
{
   static char *prev      = NULL;
   static size_t prev_len = 0;
   size_t word_len        = 0;

   static int  start = 0;
   static int  end;
   char *      sep   = NULL;
   char *      p;

   if (!prev){
      prev_len = 1000;
      prev = xmalloc (prev_len);
      prev [0] = 0;
   }

   if (fmt_newheadword_special (word))
      return;

   update_alphabet (word);

   fmt_ignore_headword = 0;

   fmt_test_nonascii (word);

   fmt_indent = 0;
   fflush(stdout);
   end = ftell(str);

   if (fmt_str && *prev) {
      p = split_and_write_hw_to_index (prev, NULL, start, end);
   }

   if (word) {
      /* copy word to prev */
      word_len = strlen (word);
      if (word_len > prev_len){
	 prev_len = word_len;
	 prev = xrealloc (prev, word_len + 1);
      }

      strcpy(prev, word);
      start = end;
   }

   if (
      word &&
      !without_hw &&
      strncmp (word, "00-database", 11) &&
      strncmp (word, "00database", 10))
   {
     p = prev;
     if (hw_separator[0] && break_headwords)
       while ((sep = strstr (p, hw_separator))) {
         *sep = 0;
         fmt_string (p);
         fmt_newline();
         *sep = hw_separator[0];
         p = sep + strlen (hw_separator);
       }
     fmt_string (p);
     fmt_newline();
   }
}

static void fmt_closeindex( void )
{
   if (type != INDEXONLY){
      fmt_newheadword (NULL);
   }

   if (fmt_str){
      pclose( fmt_str );
   }

   if (!quiet_mode){
      fprintf( stderr, "%12d headwords\n", fmt_hwcount );
   }
}

static void banner( FILE *out_stream )
{
   fprintf( out_stream, "dictfmt-%s\n", DICT_VERSION );
   fprintf( out_stream,
	    "Copyright 1997-2000 Rickard E. Faith (faith@cs.unc.edu)\n"
	    "Copyright 2002-2007 Aleksey Cheusov (vle@gmx.net)\n"
	    "\n");
}

static void license( void )
{
   static const char *license_msg[] = {
     "This program is free software; you can redistribute it and/or modify it",
     "under the terms of the GNU General Public License as published by the",
     "Free Software Foundation; either version 1, or (at your option) any",
     "later version.",
     "",
     "This program is distributed in the hope that it will be useful, but",
     "WITHOUT ANY WARRANTY; without even the implied warranty of",
     "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU",
     "General Public License for more details.",
     "",
     "You should have received a copy of the GNU General Public License along",
     "with this program; if not, write to the Free Software Foundation, Inc.,",
     "675 Mass Ave, Cambridge, MA 02139, USA.",
   0 };
   const char        **p = license_msg;
   
   banner ( stdout );
   while (*p) fprintf( stdout, "   %s\n", *p++ );
}

static void help( FILE *out_stream )
{
   static const char *help_msg[] = {
   "Usage: dictfmt -c5|-t|-e|-f|-h|-j|-p [-u url] [-s name] [options] basename",
   "       dictfmt -i|-I [options]",
   "Create a dictionary databse and index file for use by a dictd server",
   "",
     "-c5       headwords are preceded by a line containing at least \n\
                5 underscore (_) characters",
     "-t        implies -c5, --without-headword and --without-info options",
     "-e        file is in html format",
     "-f        headwords start in col 0, definitions start in col 8",
     "-j        headwords are set off by colons",
     "-p        headwords are preceded by %p, with %d on following line",
     "-i        reformat stdin having three-column .index file format",
     "-u <url>  URL of site where database was obtained",
     "-s <name> name of the database", 
     "--license\n\
-L        display copyright and license information",
     "--version\n\
-V        display version information",
     "-D        debug",
"--utf8    for creating utf-8 dictionary",
"--quiet\n\
--silent\n\
-q        quiet operation",
"--help    display this help message", 
"--locale   <locale> specifies the locale used for sorting.\n\
           if no locale is specified, the \"C\" locale is used.",
"--allchars all characters (not only alphanumeric and space)\n\
           will be used in search if this argument is supplied",
"--headword-separator <sep> sets headword separator which allows\n\
                     several words to have the same definition\n\
                     Example: autumn%%%fall can be used\n\
                     if '--headword-separator %%%' is supplied",
"--index-data-separator <sep> sets index/data separator which allows\n\
                     to explicitely set fourth column in .index file,\n\
                     the default is \"\\034\"",
"--break-headwords    multiple headwords will be written on separate lines\n\
                     in the .dict file.  For use with '--headword-separator.",
"--index-keep-orig    fourth column in .index file stores original headword\n\
                     which is returned by MATCH command",
"--case-sensitive     Create .index/.dict files for case sensitive search",
"--without-headword   headwords will not be copied to .dict file",
"--without-header     header will not be copied to DB info entry",
"--without-url        URL will not be copied to DB info entry",
"--without-time       time of creation will not be copied to DB info entry",
"--without-info       DB info entry will not be created.\n\
                     This may be useful if 00-database-info headword\n\
                     is expected from stdin (dictunformat outputs it).",
"--columns            Set the number of columns for wrapping text\n\
                     before writing it to .dict file.\n\
                     If it is zero, wrapping is off.",
"--default-strategy  Sets the default search strategy for the database.\n\
                    Special entry 00-database-default-strategy is created\n\
                    for this purpose.",
"--mime-header       Sets MIME header stored in .data file which\n\
                    prepend definition\n\
                    when client sent OPTION MIME to `dictd'",
"--without-ver      do not create 00-database-dictfmt-<VER> entry in .index",
      0 };
   const char        **p = help_msg;

   banner( out_stream );
   while (*p) fprintf( out_stream, "%s\n", *p++ );
}

static void set_utf8bit_mode (const char *locale_)
{
   const char *charset = NULL;
   int ascii_mode;

   if (!setlocale(LC_COLLATE, locale_) || !setlocale(LC_CTYPE, locale_)){
      fprintf (stderr, "invalid locale '%s'\n", locale_);
      destroy_and_exit (2);
   }

   charset = nl_langinfo (CODESET);

   utf8_mode = !strcmp (charset, "UTF-8");

#if !HAVE_UTF8
   if (utf8_mode){
      err_fatal (
	 __func__,
	 "utf-8 support was disabled at compile time\n");
   }
#endif

   ascii_mode = 
      !strcmp (charset, "ANSI_X3.4-1968") ||
      !strcmp (charset, "US-ASCII") ||
      (locale_ [0] == 'C' && locale_ [1] == 0);

   bit8_mode = !ascii_mode && !utf8_mode;

#ifndef SYSTEM_UTF8_FUNCS
   if (utf8_mode){
      fprintf (stderr, "Using --locale xx_YY.UTF-8 for creating utf-8 database is deprecated,\n\
use --utf8 option instead.\n");
   }
#endif
}

static const char string_unknown [] = "unknown";
static const char *url = string_unknown;
static const char *sname = string_unknown;

static void fmt_headword_for_def_strat (void)
{
   if (!default_strategy)
      return;

   fmt_newheadword ("00-database-default-strategy");
   fmt_string (default_strategy);
   fmt_newline ();
}

static void fmt_headword_for_MIME_header (void)
{
   int old_max_pos = fmt_maxpos;

   if (!mime_header)
      return;

   fmt_maxpos = INT_MAX; /* no wrap for this special headword */

   fmt_newheadword ("00-database-mime-header");
   fmt_string (mime_header);
   fmt_newline ();

   fmt_maxpos = old_max_pos; /* restore */
}

static void fmt_headword_for_url (void)
{
   fmt_newheadword ("00-database-url");
   fmt_string (url);
   fmt_newline ();

   ignore_hw_url = 1;
}

static int qsort_compare_strings (const void *a, const void *b)
{
   return strcmp (*(const char **)a, *(const char **)b);
}

static void fmt_headword_for_alphabet (void)
{
   const char *key;
   size_t sum_size = 0;
   str_Position pos;
   char *alphabet;
   int alphabet_size = 0;
   const char **keys = NULL;
   int i;

   fmt_newheadword("00-database-alphabet");

   STR_ITERATE (alphabet_pool, pos, key){
      sum_size += strlen (key);
      ++alphabet_size;
   }

   keys = xmalloc (alphabet_size * sizeof (keys [0]));

   i = 0;
   STR_ITERATE (alphabet_pool, pos, key){
      keys [i++] = key;
   }

   qsort (keys, alphabet_size, sizeof (keys [0]), qsort_compare_strings);

   alphabet = xmalloc (sum_size + 1);
   alphabet [0] = 0;
   for (i=0; i < alphabet_size; ++i){
      strcat (alphabet, keys [i]);
   }

   fmt_string (alphabet);

   xfree (alphabet);

   fmt_newline ();
}

static void fmt_headword_for_shortname (void)
{
   fmt_newheadword("00-database-short");
   fmt_string ("00-database-short");
   fmt_newline ();
   fmt_string( "     " );
   fmt_string( sname );
   fmt_newline ();

   ignore_hw_shortname = 1;
}

static void fmt_headword_for_info (void)
{
   time_t     t;
   char       buffer[BSIZE];

   fmt_newheadword("00-database-info");

   if (!without_time){
      fmt_string("This file was converted from the original database on:" );
      fmt_newline();
      time(&t);

      snprintf( buffer, sizeof (buffer), "          %25.25s", ctime(&t) );
      buffer [strlen (buffer) - 1] = 0; /* for removing \n */

      fmt_string( buffer );
      fmt_newline();
      fmt_newline();
   }

   if (!without_url){
      fmt_string( "The original data is available from:" );
      fmt_newline();
      fmt_string( "     " );
      fmt_string( url );
      fmt_newline();
      fmt_newline();
   }

   if (!without_header){
      static const char msg [] =
	 "The original data was distributed with the notice shown below."
	 " No additional restrictions are claimed.  Please redistribute"
	 " this changed version under the same conditions and restriction"
	 " that apply to the original version.";
      if (fmt_maxpos == INT_MAX){
	 /* --columns 0 */
	 fmt_maxpos = FMT_MAXPOS;
	 fmt_string(msg);
	 fmt_maxpos = INT_MAX;
      }else{
	 fmt_string(msg);
      }

      fmt_newline();
      fmt_newline();
   }
}

static void fmt_headword_for_utf8 (void)
{
   if (utf8_mode){
      fmt_newheadword("00-database-utf8");
      fmt_newline();
   }
}

static void fmt_headword_for_8bit (void)
{
   if (bit8_mode){
      fmt_newheadword("00-database-8bit-new");
      fmt_newline();
   }
}

static void fmt_headword_for_allchars (void)
{
   if (allchars_mode){
      fmt_newheadword("00-database-allchars");
      fmt_newline();
   }
}

static void fmt_headword_for_casesensitive (void)
{
   if (cs_mode){
      fmt_newheadword("00-database-case-sensitive");
      fmt_newline();
   }
}

static void fmt_headword_for_dictfmt_ver (void)
{
   char ver [200];
   snprintf (ver, sizeof (ver),
	     "00-database-dictfmt-%s", DICT_VERSION);

   if (dictfmt_ver_mode){
      fmt_newheadword (ver);
      fmt_string (ver);
      fmt_newline ();
   }
}

/* ...before reading the input */
static void fmt_predefined_headwords_before ()
{
   if (type == INDEXONLY)
      return;

   fmt_headword_for_utf8 ();
   fmt_headword_for_8bit ();
   fmt_headword_for_allchars ();
   fmt_headword_for_casesensitive ();
   fmt_headword_for_def_strat ();
   fmt_headword_for_MIME_header ();
   fmt_headword_for_dictfmt_ver ();

   if (url != string_unknown){
      /*
	-u option is not applied and we add 00-database-url headword
      */
      fmt_headword_for_url ();
   }

   if (sname != string_unknown){
      /*
	-s option is not applied and we add 00-database-short headword
      */
      fmt_headword_for_shortname ();
   }

   if (!without_info){
      fmt_headword_for_info ();
   }
}

/* ...after reading the input */
static void fmt_predefined_headwords_after ()
{
   if (type == INDEXONLY)
      return;

   fmt_headword_for_url ();
   fmt_headword_for_shortname ();
   fmt_headword_for_alphabet ();
}

static int xatoi (const char *nptr)
{
   char *end;
   long ret = strtol (nptr, &end, 10);
   if (end == nptr || end [0] != 0)
      err_fatal (__func__, "bad decimal '%s'\n", nptr);

   return (int) ret;
}

int main( int argc, char **argv )
{
   int        c;
   char       buffer[BSIZE];
   char       buffer2[BSIZE];
   char       indexname[1024]="/nonexistentfile.index";
   char       dataname[1024]="/nonexistentfile.data";

   int        header = 0;
   char       *pt;
   char       *s, *d;
   unsigned char *buf;
   size_t     len;

   const char *basename = NULL;

   struct option      longopts[]  = {
      { "help",       0, 0, 501 },
      { "locale",     1, 0, 502 },
      { "allchars",   0, 0, 503 },
      { "headword-separator",   1, 0, 504 },
      { "without-headword",     0, 0, 505 },
      { "without-header",       0, 0, 506 },
      { "without-url",          0, 0, 507 },
      { "without-time",         0, 0, 508 },
      { "without-info",         0, 0, 509 },
      { "columns",              1, 0, 510 },
      { "break-headwords",      0, 0, 511 },
      { "quiet",                0, 0, 'q' },
      { "silent",               0, 0, 'q' },
      { "version",              0, 0, 'V' },
      { "license",              0, 0, 'L' },
      { "default-strategy",     1, 0, 512 },
      { "mime-header",          1, 0, 513 },
      { "utf8",                 0, 0, 514 },
      { "index-keep-orig",      0, 0, 515 },
      { "case-sensitive",       0, 0, 516 },
      { "index-data-separator", 1, 0, 517 },
      { "without-ver",          0, 0, 518 },
      { NULL,                   0, 0, 0   },
   };

   init (argv[0]);

   while ((c = getopt_long( argc, argv, "qVLjvfepiIhDu:s:c:t",
                                    longopts, NULL )) != EOF)
      switch (c) {
      case 'q': quiet_mode = 1;            break;
      case 'L': license();
	 destroy_and_exit (1);
	 break;
      case 'V': banner( stdout );
	 destroy_and_exit (1);
	 break;
      case 501: help( stdout );
	 destroy_and_exit (1);
	 break;         
      case 'j': type = JARGON;             break;
      case 'f': type = FOLDOC;             break;
      case 'e': type = EASTON;             break;
      case 'p': type = PERIODIC;           break;
      case 'i':
	 type = INDEXONLY;
	 break;
      case 'I':
	 type = INDEXONLY;
	 indexonly_base64 = 1;
	 break;
      case 'h':
	 type = HITCHCOCK;
	 without_hw = 1;
	 break;
      case 'v': type = VERA;               break;
      case 'D': ++Debug;                   break;
      case 'u': url = optarg;              break;
      case 's': sname = optarg;            break;
      case 'c':                            
	 switch (*optarg) {                
	 case '5': type = CIA1995;
	    break;
	 default:
	    fprintf( stderr,
		     "Only CIA 1995 (-c5) currently supported\n" );

	    destroy_and_exit (1);
	 }

	 break;
      case 502: locale         = optarg;      break;
      case 503: allchars_mode  = 1;           break;
      case 504: hw_separator   = optarg;      break;
      case 505: without_hw     = 1;           break;
      case 506: without_header = 1;           break;
      case 507: without_url    = 1;           break;
      case 508: without_time   = 1;           break;
      case 509: without_info   = 1;           break;
      case 510:
	 fmt_maxpos = atoi (optarg);

	 if (fmt_maxpos <= 0){
	    fmt_maxpos = INT_MAX;
	 }
	 break;
      case 511:
	 break_headwords = 1;
	 break;
      case 512:
	 default_strategy = str_copy (optarg);
	 break;
      case 513:
	 mime_header = str_copy (optarg);
	 break;
      case 514:
	 bit8_mode = 0;
	 utf8_mode = 1;
	 break;
      case 515:
	 index_keep_orig_mode = 1;
	 break;
      case 516:
	 cs_mode = 1;
	 break;
      case 517:
	 idxdat_separator = optarg;
	 break;
      case 518:
	 dictfmt_ver_mode = 0;
	 break;

      case 't':
	 without_info = 1;
	 without_hw   = 1;
	 type         = CIA1995;
	 fmt_maxpos   = INT_MAX;
	 break;

      default:
         help (stderr);
	 
	 destroy_and_exit (1);
      }

   if (type != INDEXONLY) {
      if (optind + 1 != argc) {
	 help (stderr);

	 destroy_and_exit (1);
      }

      basename = argv [optind];
   }

   if (locale)
      set_utf8bit_mode (locale);

   setenv("LC_ALL", "C", 1); /* this is for 'sort' subprocess */

   if (!basename){
      fmt_openindex (NULL);
   }else{
      if (-1 == snprintf (
	     indexname, sizeof (indexname), "%s.index", basename )||
	  -1 == snprintf (
	     dataname,  sizeof (dataname), "%s.dict", basename ))
      {
	 err_fatal (__func__, "Too long filename\n");
      }

      fmt_openindex( indexname );
   }

   if (basename && !Debug){
      if (!(str = fopen (dataname, "w"))) {
	 fprintf(stderr, "Cannot open %s for write\n", dataname);

	 destroy_and_exit (1);
      }
   }

   fmt_predefined_headwords_before ();

   while (buf = (unsigned char *) buffer, fgets (buffer, BSIZE-1, stdin)) {
      len = strlen (buffer);

      if (len)
	 buffer [len-1] = '\0'; /* remove newline */
      
      switch (type) {
      case HITCHCOCK:
	 if (strlen(buffer) == 1) {
	    header = 1;
	    continue;;
	 }
	 if (header) {
	    strcpy( buffer2, buffer );
	    if ((pt = strchr( buffer2, ','))) {
	       *pt = '\0';
	       fmt_newheadword(buffer2);
	       *pt = ',';
	    }
	 }
	 break;
      case EASTON:
	 strcpy( buffer2, buffer );
	 for (s = buffer2, d = buffer; *s; ++s) {
	    if (*s == '<') {
	       header = 1;
	       switch (s[1]) {
	       case 'I': *d++ = '_'; break;
	       case 'A':
		  if (s[3] == 'N') goto skip;
		  *d++ = '{';
		  break;
	       case 'P': goto skip;
	       case 'B': goto copy;
	       case '/':
		  switch(s[2]) {
		  case 'I': *d++ = '_'; break;
		  case 'A': *d++ = '}'; break;
		  case 'B': goto copy;
		  default:
		     fprintf( stderr,
			      "Unknown tag: %s (%c%c)\n",
			      buffer2, s[1], s[2] );

		     destroy_and_exit (1);
		  }
		  break;
	       default:
		  fprintf( stderr, "Unknown tag: %s (%c)\n", buffer2, s[1] );

		  destroy_and_exit (1);
	       }
	       while (*s && *s != '>') s++;
	       continue;
	    }
      copy:
	    *d++ = *s;
	 }
	 *d = '\0';
#if 0
	 printf( "BEFORE: %s\n", buffer2 );
	 printf( "AFTER: %s\n", buffer );
#endif

	 if (*buffer == '<') {
	    switch (buffer[1]) {
	    case 'B':
	       if ((pt = strstr( buffer+3, " - </B>" ))) {
		  *pt = '\0';
		  fmt_newheadword(buffer+3);
		  continue;
	       } else {
		  fprintf( stderr, "No end: %s\n", buffer );

		  destroy_and_exit (1);
	       }
	       break;
	    default:
	       fprintf( stderr, "Unknown: %s\n", buffer );

	       destroy_and_exit (1);
	    }
	 } else {
	    if (buffer[0] == ' ' && buffer[1] == ' ') fmt_newline();
	 }
	 break;
      case JARGON:
	 switch (*buffer) {
	 case ':':
	    header = 1;
	    if ((pt = strchr( buffer+1, ':' ))) {
	       s = pt + 1;
	       if (*s == ':') ++s;
	       
	       *pt = '\0';
	       fmt_newheadword (buffer+1);
	       memmove( buf, s, strlen(s)+1 ); /* move \0 also */
	    }
	    break;
	 case '*':
	 case '=':
	 case '-':
	    if (buffer[0] == buffer[1]
		&& buffer[0] == buffer[2]
		&& buffer[0] == buffer[3])
	       continue;		/* Skip lines with *'s and ='s */
	 }
	 break;
      case PERIODIC:
	 switch (*buffer) {
	 case '%':
	    if (buffer[1] == 'h') {
	       if (!header) {
		  header = 1;
		  continue;
	       } else {
		  fmt_newheadword(buffer+3);
		  continue;
	       }
	    } else if (buffer[1] == 'd') {
	       continue;
	    }	    
	    break;
	 }
	 break;
      case VERA:
          switch (*buffer) {
          case '@':
              if (header && !strncmp(buffer, "@item ", 6)) {
		 fmt_newheadword(buffer+6);
              }
              continue;
          }
          if (!header) {
              fmt_string("This is a special GNU edition of V.E.R.A.,");
              fmt_string("a list dealing with computational acronyms.");
              fmt_newline();
              fmt_string("Copyright 1993/2002 Oliver Heidelbach <ohei [at] snafu de>");
              fmt_newline();
              fmt_newline();
              fmt_string(
"Permission is granted to copy, distribute and/or modify this document"
" under the terms of the GNU Free Documentation License, Version 1.1"
" or any later version published by the Free Software Foundation;"
" with no Invariant Sections, with no Front-Cover Texts, and with "
" no Back-Cover Texts.");
              fmt_newline();
              fmt_newline();
              fmt_string(
"Within the above restrictions the distribution of this"
" document is explicitly encouraged and I hope you'll find"
" it of some value.");
              fmt_newline();
              fmt_newline();
              fmt_string(
"This dictionary has nothing to do with Systems Science Inc. "
"or its products.");
              fmt_newline();
              ++header;
          }
          break;
      case FOLDOC:
         if (*buffer && *buffer != ' ' && *buffer != '\t') {
           ++header;
           if (header >= 3) {
             fmt_newheadword(buffer);
             continue;
           }
         }
         if (header < 3 && without_info)
           continue;
	 if (*buf == ' '){
	    ++buf;
	 }
	 if (*buf == '\t') {
	    memmove( buf+2, buf, strlen((char *) buf)+1 ); /* move \0 */
	    buf[0] = buf[1] = buf[2] = ' ';
	 }
	 break;
      case CIA1995:
	 if (*buffer == '@') {
	    buf++;
	 } else if (strncmp(buffer, "_____",5) == 0) {
	    buf = (unsigned char *) buffer;
	    fgets (buffer,BSIZE-1,stdin); /* empty line */
	    fgets (buffer,BSIZE-1,stdin);
	    if (strlen(buffer))
	       buffer[strlen(buffer)-1] = '\0'; /* remove newline */

	    buf = (unsigned char *) trim_left (buffer);
/*	    buf = (unsigned char *) trim_left (buffer);*/

	    if (*buf != '\0') {
	       fmt_indent = 0;
	       fmt_newheadword ((const char *) buf);
	       continue;
	    }
 	 }
 	 break;
      case INDEXONLY:
	 {
	    const char *headword = NULL;
	    const char *offset   = NULL;
	    const char *size     = NULL;
	    const char *data     = NULL;

	    int i_offset = 0;
	    int i_size   = 0;

	    headword = strtok (buffer, "\t");
	    if (!headword){
	       fprintf (stderr, "strtok failed 1\n");
	       exit (1);
	    }

	    offset = strtok (NULL, "\t");
	    if (!offset){
	       fprintf (stderr, "strtok failed 2\n");
	       exit (1);
	    }

	    size = strtok (NULL, "\t\n");
	    if (!size){
	       fprintf (stderr, "strtok failed 3\n");
	       exit (1);
	    }

	    data = strtok (NULL, "\n");

	    if (indexonly_base64){
	       i_offset = (int) b64_decode (offset);
	    }else{
	       i_offset = xatoi (offset);
	    }

	    if (indexonly_base64){
	       i_size = (int) b64_decode (size);
	    }else{
	       i_size = xatoi (size);
	    }

	    write_hw_to_index (headword, data, i_offset, i_offset + i_size);
	 }
	 break;
      default:
	 fprintf(stderr, "Unknown input format type %d\n", type );

	 destroy_and_exit (2);
      }
      if (buf){
	 fmt_string ((const char *) buf);
	 fmt_indent = 0;
	 fmt_newline ();
/*	 fmt_indent = FMT_INDENT; */
      }
   skip:;
   }

   fmt_predefined_headwords_after ();

   fmt_closeindex();

   if (str)
      fclose(str);

   destroy ();

   return 0;
}
