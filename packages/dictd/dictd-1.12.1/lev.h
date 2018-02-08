/* lev.h -- 
 * Created: Thu Jan 8 19:05:03 2004 by vle@gmx.net
 * Copyright 1996, 1997, 1998, 2000, 2002 Rickard E. Faith (faith@dict.org)
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

#define DICT_SEARCH_LEVENSHTEIN_8BIT__DEL_TRANS(buf, word, args) \
				/* Deletions */ \
   for (i = 0; i < len; i++) {                  \
      p = buf;                                  \
      for (j = 0; j < len; j++)                 \
	 if (i != j) *p++ = word[j];            \
      *p = '\0';                                \
      CHECK(buf, args);                         \
   }                                            \
                                                \
                                /* Transpositions */ \
   strcpy( buf, word );         \
   for (i = 1; i < len; i++) {  \
      tmp = buf[i-1];           \
      buf[i-1] = buf[i];        \
      buf[i] = tmp;             \
                                \
      CHECK(buf, args);         \
                                \
      tmp = buf[i-1];           \
      buf[i-1] = buf[i];        \
      buf[i] = tmp;             \
   }

static int dict_search_lev_8bit (
   const char *word,
   const char *alphabet,
   LEV_ARGS *args)
{
   int        len   = strlen(word);
   char       *buf  = alloca(len+2);
   char       *p    = buf;
   int        count = 0;
   set_Set    s     = set_create(NULL,NULL);
   size_t     i, j, k;
   const char *pt;

   size_t alphabet_len = strlen (alphabet);
   char new_char;

   LEV_VARS

   assert (alphabet);

   DICT_SEARCH_LEVENSHTEIN_8BIT__DEL_TRANS(buf, word, args)

				/* Insertions */
   for (i = 0; i < len; i++) {
      for (k = 0; k < alphabet_len; k++) {
	 p = buf;
         for (j = 0; j < len; j++) {
            *p++ = word[j];
            if (i == j)
	       *p++ = alphabet [k];
         }
         *p = '\0';
	 CHECK(buf, args);
      }
   }
                                /* Insertions at the beginning */
   strcpy( buf + 1, word );
   for (k = 0; k < alphabet_len; k++) {
      buf[ 0 ] = alphabet [k];
      CHECK(buf, args);
   }

                                  /* Substitutions */
   strcpy( buf, word );
   for (i = 0; i < len; i++) {
      for (j = 0; j < alphabet_len; j++) {
	 new_char = alphabet [j];

	 if (buf[i] != new_char){
	    tmp = buf [i];
	    buf [i] = new_char;
	    CHECK(buf, args);
	    buf [i] = tmp;
	 }
      }
   }

   PRINTF(DBG_LEV,("  Got %d matches\n",count));
   set_destroy(s);

   return count;
}

#if HAVE_UTF8
static int dict_search_lev_utf8 (
   const char *word,
   const char *alphabet,
   LEV_ARGS *args)
{
   size_t    size  = strlen (word);
   size_t    len   = mbstowcs__ (NULL, word, 0);
   char      *buf  = xmalloc (size + MB_CUR_MAX__ + 1);
   char      *buf2 = xmalloc (len * (MB_CUR_MAX__ + 1));
   char      *buf3;
   mbstate_t ps;
   int       count = 0;
   const char *pt;
   dictWord   *datum;

   const char *p;
   char *d;
   char *d2;
   size_t char_len;
   size_t i;
   set_Set    s    = set_create (NULL,NULL);

   LEV_VARS

   assert (alphabet);

   memset (&ps, 0, sizeof (ps));

   PRINTF(DBG_LEV,("buf size = %d buf2 size %d\n", len + MB_CUR_MAX__ + 1,
		   len * (MB_CUR_MAX__ + 1)));

   i = 0;
   for (p = word; *p; ){
      char_len = mbrlen__ (p, MB_CUR_MAX__, &ps);
      assert ((long) char_len > 0);

      buf3 = buf2 + i * (MB_CUR_MAX__ + 1);
      memcpy (buf3, p, char_len);
      buf3 [char_len] = 0;

      p += char_len;
      ++i;
   }

   /* Transpositions */
   for (i=1; i < len; ++i){
      d = copy_utf8_string (buf2, buf, i - 1);
      d = copy_utf8_string (buf2 + (MB_CUR_MAX__ + 1) * i, d, 1);
      d = copy_utf8_string (buf2 + (MB_CUR_MAX__ + 1) * (i - 1), d, 1);
      d = copy_utf8_string (buf2 + (MB_CUR_MAX__ + 1) * (i + 1), d, len - i - 1);

      CHECK(buf, args);
      PRINTF(DBG_LEV,("query: `%s`\n", buf));
   }

   /* Insertions at the end of word */
   memcpy (buf, word, size + 1);
   d = buf + size;
   p = alphabet;

   while (*p){
      char_len = mbrlen__ (p, MB_CUR_MAX__, &ps);
      if (char_len == (size_t) -1)
	 err_internal (__func__, "Alphabet is not a valid utf-8 string\n");

      memcpy (d, p, char_len);
      d [char_len] = 0;

      p += char_len;

      CHECK(buf, args);
      PRINTF(DBG_LEV,("query: `%s`\n", buf));
   }

   /* Deletions, Insertions and Substitutions */
   for (i=0; i < len; ++i){
      d = copy_utf8_string ((char *) buf2, (char *) buf, i);
      p = alphabet;

      /* Deletions */
      copy_utf8_string (buf2 + (MB_CUR_MAX__ + 1) * (i + 1), d, len - i - 1);
      CHECK(buf, args);
      PRINTF(DBG_LEV,("query: `%s`\n", buf));

      while (*p){
	 char_len = mbrlen__ (p, MB_CUR_MAX__, &ps);
	 if (char_len == (size_t) -1)
	    err_internal (__func__, "Alphabet is not a valid utf-8 string\n");

	 memcpy (d, p, char_len);
	 p += char_len;

	 /* Insertions */
	 copy_utf8_string (buf2 + (MB_CUR_MAX__ + 1) * i, d + char_len, len - i);
	 CHECK(buf, args);
	 PRINTF(DBG_LEV,("query: `%s`\n", buf));

	 /* Substitutions */
#if 1
	 d2 = d + char_len;
	 char_len = mbrlen__ (d2, MB_CUR_MAX__, &ps);
	 assert ((long) char_len >= 0);

	 while ((d2 [0] = d2 [char_len]) != 0){
	    ++d2;
	 }
#else
	 copy_utf8_string (buf2 + (MB_CUR_MAX__ + 1) * (i + 1), d + char_len, len - i - 1);
#endif
	 CHECK(buf, args);
	 PRINTF(DBG_LEV,("query: `%s`\n", buf));
      }
   }

   set_destroy (s);

   xfree (buf);
   xfree (buf2);

   return count;
}
#endif

static int dict_search_lev (
   const char *word,
   const char *alphabet,
   int flag_utf8,
   LEV_ARGS *args)
{
   assert (alphabet);

#if HAVE_UTF8
   if (flag_utf8){
      return dict_search_lev_utf8 (
	 word, alphabet, args);
   }else{
#endif
      return dict_search_lev_8bit (
	 word, alphabet, args);
#if HAVE_UTF8
   }
#endif
}
