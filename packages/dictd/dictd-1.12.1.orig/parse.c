/* parse.c -- Support for calling parsers from Libmaa
 * Created: Mon Apr 24 17:40:51 1995 by faith@dict.org
 * Copyright 1995, 1997, 2002 Rickard E. Faith (faith@dict.org)
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
 *
 * \section{Parsing (and Lexing) Support}
 * 
 */

#include "dictP.h"
#include "maa.h"
#include "parse.h"

static int           _prs_debug_flag   = 0;
static const char    *_prs_cpp_options = NULL;

extern int        yydebug;
extern FILE       *yyin;
extern int        yyparse( void );

/* \doc |prs_set_debug| specifies the value of |yyerror| that |prs_file|
   will use. */

void prs_set_debug( int debug_flag )
{
   _prs_debug_flag = debug_flag;
}

/* \doc |prs_set_cpp_options| sets the options for |cpp| to |cpp_options|,
   ensuring that |prs_file| will use |cpp| as a filter.  If |cpp_options|
   is "NULL", then |cpp| will not be used at a filter. */

void prs_set_cpp_options( const char *cpp_options )
{
   _prs_cpp_options = cpp_options ? str_find( cpp_options ) : NULL;
}

/* \doc |prs_file| calls opens |filename| for input, sets |yyerror| to the
   value specified by |prs_set_debug|, and calls |yyparse|, perhaps using
   |cpp| as an input filter.

   A similar function should deal with multiple parsers in the same
   program, but this has not been implemented.  Also, either this function
   or another function should start an interactive parse session. */

void prs_file_pp (const char *pp, const char *filename)
{
   char              *buffer;

   if (!filename)
      err_fatal( __func__, "No filename specified\n" );

   if (!pp){
      prs_file_nocpp (filename);
      return;
   }

   buffer = alloca (strlen (pp) + strlen (filename) + 100);

   sprintf (buffer, "%s '%s' 2>/dev/null", pp, filename);


   PRINTF(MAA_PARSE,("%s: %s\n", __func__, buffer));
   if (!(yyin = popen( buffer, "r" )))
      err_fatal_errno( __func__,
		       "Cannot open \"%s\" for read\n", buffer );

   src_new_file( filename );
   yydebug = _prs_debug_flag;
   yyparse();
   pclose( yyin );
}

void prs_file( const char *filename )
{
   char              *buffer;
   const char        **pt;
   static const char *cpp = NULL;
   static const char *cpps[] = { "/lib/cpp",
                                 "/usr/lib/cpp",
                                 "/usr/ccs/lib/cpp",	/* Solaris */
                                 "/usr/lang/cpp",
                                 0 };
   static const char *extra_options = "";
   FILE              *tmp;
   
   if (!filename)
      err_fatal( __func__, "No filename specified\n" );

   if (!cpp) {
      if ((cpp = getenv( "KHEPERA_CPP" ))) {
         PRINTF(MAA_PARSE,("%s: Using KHEPERA_CPP from %s\n", __func__, cpp));
      }
      
                                /* Always look for gcc's cpp first, since
                                   we know it is ANSI C compliant. */
      if (!cpp && (tmp = popen( "gcc -print-file-name=cpp", "r" ))) {
         char buf[1024];
         char *t;
         
         if (fread( buf, 1, 1023, tmp ) > 0) {
            if ((t = strchr( buf, '\n' ))) *t = '\0';
            PRINTF(MAA_PARSE,("%s: Using GNU cpp from %s\n", __func__, buf));
            cpp = str_find( buf );
            extra_options = "-nostdinc -nostdinc++";
         }
         pclose( tmp );
      }

                                /* Then look for the vendor's cpp, which
                                   may or may not be useful (e.g., on SunOS
                                   4.x machines, it isn't ANSI C
                                   compatible.  Considering ANSI C is C89,
                                   and this is 1996, one might think that
                                   Sun would have fixed this... */
      if (!cpp) {
         for (pt = cpps; **pt; pt++) {
            if (!access( *pt, X_OK )) {
               PRINTF(MAA_PARSE,
                      ("%s: Using system cpp from %s\n", __func__, *pt));
               cpp = *pt;
               break;
            }
         }
      }
      
      if (!cpp)
	 err_fatal( __func__,
		    "Cannot locate cpp -- set KHEPERA_CPP to cpp's path\n" );
   }

   buffer = alloca( strlen( cpp )
                    + sizeof( filename )
		    + (_prs_cpp_options ? strlen( _prs_cpp_options ) : 0)
		    + 100 );

   sprintf( buffer, "%s -I. %s %s 2>/dev/null", cpp,
	    _prs_cpp_options ? _prs_cpp_options : "", filename );

   PRINTF(MAA_PARSE,("%s: %s\n", __func__, buffer));
   if (!(yyin = popen( buffer, "r" )))
      err_fatal_errno( __func__,
		       "Cannot open \"%s\" for read\n", filename );

   src_new_file( filename );
   yydebug = _prs_debug_flag;
   yyparse();
   pclose( yyin );
}

/* \doc |prs_file_nocpp| calls opens |filename| for input, sets |yyerror|
   to the value specified by |prs_set_debug|, and calls |yyparse|.

   A similar function should deal with multiple parsers in the same
   program, but this has not been implemented.  Also, either this function
   or another function should start an interactive parse session. */

void prs_file_nocpp( const char *filename )
{
   if (!filename)
      err_fatal( __func__, "No filename specified\n" );

   if (!(yyin = fopen( filename, "r" )))
      err_fatal_errno( __func__,
		       "Cannot open \"%s\" for read\n", filename );

   src_new_file( filename );
   yydebug = _prs_debug_flag;
   yyparse();
   fclose( yyin );
}

/* \doc |prs_stream| parses an already opened stream called |name|. */

void prs_stream( FILE *str, const char *name )
{
   yyin = str;
   src_new_file( name );
   yydebug = _prs_debug_flag;
   yyparse();
}

/* \doc |prs_make_integer| converts a |string| of specified |length| to an
   integer.  This function is useful in scanners that do not
   "NULL"-terminate |yytext|. */

int prs_make_integer( const char *string, int length )
{
   char *buffer = alloca( length + 1 );
   
   if (!length) return 0;
   strncpy( buffer, string, length );
   buffer [length] = 0;

   return atoi( buffer );
}

/* \doc |prs_make_double| converts a |string| of specified |length| to a
   double.  This function is useful in scanners that do not
   "NULL"-terminate |yytext|. */

double prs_make_double( const char *string, int length )
{
   char *buffer = alloca( length + 1 );

   if (!length) return 0;
   strncpy( buffer, string, length );
   buffer [length] = 0;

   return atof( buffer );
}

#ifdef SHARED_LIBMAA
#if defined(__linux__) && defined(__ELF__)
#include <gnu-stabs.h>
# ifdef weak_symbol
int yydebug;
FILE *yyin;
int yyparse( void ) { return 0; }
weak_symbol(yydebug);
weak_symbol(yyin);
weak_symbol(yyparse);
# endif
#endif
#endif
