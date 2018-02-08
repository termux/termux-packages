/* servscan.l -- Scanner for dictd server configuration file
 * Created: Fri Feb 28 08:23:03 1997 by faith@cs.unc.edu
 * Copyright 1997, 1999, 2000, 2002 Rickard E. Faith (faith@acm.org)
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

%option stack debug
%{
#include "dictd.h"
#include "servparse.h"
extern int  yylex( void );
extern int  yydebug;
extern void yyerror( const char *message );
static void include_file( void );
static void include_complete( void );
YY_BUFFER_STATE orig_buffer = NULL;
src_Type orig_source = NULL;
#define RETURN(val) do {                  \
   yylval.token.src = src_get( yyleng );  \
   return val;                            \
} while (0)

/*
  \n    --> new line character
  \\    --> backslash
  \<NL> --> no symbol
  \"    --> double quote symbol
*/
static int escape_string (char *s, int len)
{
   int ret = 0;
   int i   = 0;

   for (i=0; i < len; ++i){
      if (s [i] != '\\'){
	 s [ret++] = s [i];
      }else if (s [i+1] == '\\'){
	 s [ret++] = '\\';

	 ++i;
      }else if (s [i+1] == 'n'){
	 s [ret++] = '\n';

	 ++i;
      }else if (s [i+1] == '"'){
	 s [ret++] = '"';

	 ++i;
      }else if (s [i+1] != '\n'){
	 s [ret++] = s [++i];
      }else{
	 ++i;
      }
   }

   return ret;
}

%}
%s OTHER
integer                     [[:digit:]]+
comment                     #.*
word                        ([[:alnum:]_/\-\.\*][[:alnum:]_/\-\.\*]*)
string                      \"(([^\"\n])|\"\"|\\\n|\\\")*\"
NL                          \n
WS                          [[:blank:]]+
%%
<INITIAL>{
   .*{NL}                   src_line(yytext,yyleng); yyless(0); BEGIN(OTHER);
   .*                       src_line(yytext,yyleng); yyless(0); BEGIN(OTHER);
}
include{WS}({word}|{string})   include_file();
access                      RETURN(TOKEN_ACCESS);
allow                       RETURN(TOKEN_ALLOW);
deny                        RETURN(TOKEN_DENY);
group                       RETURN(TOKEN_GROUP);
database                    RETURN(TOKEN_DATABASE);
database_exit               RETURN(TOKEN_DATABASE_EXIT);
data                        RETURN(TOKEN_DATA);
index                       RETURN(TOKEN_INDEX);
index_suffix                RETURN(TOKEN_INDEX_SUFFIX);
index_word                  RETURN(TOKEN_INDEX_WORD);
filter                      RETURN(TOKEN_FILTER);
prefilter                   RETURN(TOKEN_PREFILTER);
postfilter                  RETURN(TOKEN_POSTFILTER);
name                        RETURN(TOKEN_NAME);
user                        RETURN(TOKEN_USER);
authonly                    RETURN(TOKEN_AUTHONLY);

site                        RETURN(TOKEN_SITE);
site_no_banner              RETURN(TOKEN_SITE_NO_BANNER);
site_no_uptime              RETURN(TOKEN_SITE_NO_UPTIME);
site_no_dblist              RETURN(TOKEN_SITE_NO_DBLIST);

invisible                   RETURN(TOKEN_INVISIBLE);
database_virtual            RETURN(TOKEN_DATABASE_VIRTUAL);
info                        RETURN(TOKEN_INFO);
database_list               RETURN(TOKEN_DATABASE_LIST);
database_plugin             RETURN(TOKEN_DATABASE_PLUGIN);
plugin                      RETURN(TOKEN_PLUGIN);
disable_strategy            RETURN(TOKEN_DISABLE_STRAT);
default_strategy            RETURN(TOKEN_DEFAULT_STRAT);

dbname_nomime               RETURN(TOKEN_NOMIME_DBNAME);
dbname_mime                 RETURN(TOKEN_MIME_DBNAME);
database_mime               RETURN(TOKEN_DATABASE_MIME);

global                      RETURN(TOKEN_GLOBAL);
port                        RETURN(TOKEN_PORT);
delay                       RETURN(TOKEN_DELAY);
depth                       RETURN(TOKEN_DEPTH);
timestamp                   RETURN(TOKEN_TIMESTAMP);
log_option                  RETURN(TOKEN_LOG_OPTION);
debug_option                RETURN(TOKEN_DEBUG_OPTION);
locale                      RETURN(TOKEN_LOCALE);
add_strategy                RETURN(TOKEN_ADD_STRAT);
listen_to                   RETURN(TOKEN_LISTEN_TO);
syslog                      RETURN(TOKEN_SYSLOG);
syslog_facility             RETURN(TOKEN_SYSLOG_FACILITY);
log_file                    RETURN(TOKEN_LOG_FILE);
pid_file                    RETURN(TOKEN_PID_FILE);
fast_start                  RETURN(TOKEN_FAST_START);
without_mmap                RETURN(TOKEN_WITHOUT_MMAP);

limit                       RETURN(TOKEN_LIMIT_CHILDS);
limit_childs                RETURN(TOKEN_LIMIT_CHILDS);
limit_matches               RETURN(TOKEN_LIMIT_MATCHES);
limit_definitions           RETURN(TOKEN_LIMIT_DEFS);
limit_time                  RETURN(TOKEN_LIMIT_TIME);
limit_queries               RETURN(TOKEN_LIMIT_QUERIES);

{integer}                   { yylval.token.integer = atoi(yytext);
                              RETURN(TOKEN_NUMBER);
                            }
{word}                      { yylval.token.string = str_findn(yytext, yyleng);
                              RETURN(TOKEN_STRING);
                            }
{string}                    {
				yylval.token.string =
				   str_findn (
				      yytext+1,
				      escape_string (yytext+1, yyleng-2));
				RETURN(TOKEN_STRING);
                            }
{NL}                        BEGIN(INITIAL);
{WS}                        src_advance( yyleng );
{comment}                   src_advance( yyleng );
.                           RETURN(yytext[0]);
<<EOF>>                     { if (orig_buffer) include_complete();
                              else RETURN(0);
                            }
%%
int yywrap( void )
{
   return 1;
}

void yyerror( const char *message )
{
   src_parse_error( stderr, yylval.token.src, message );
   err_fatal( __func__, "parse error\n" );
   exit( 1 );
}

static void include_file( void ) {
   const char *file;
   int i;
   for ( i = 8; yytext[i] == ' ' || yytext[i] == '\t'; ++i )
      ;  /* advance past include{WS} to filename */
   if ( yytext[i] == '"' )  /* process {string} */
      file = str_findn(yytext+i+1, yyleng-i-2);
   else                     /* process {word} */
      file = str_findn(yytext+i, yyleng-i);
   orig_source = src_get( yyleng );
   if ( orig_buffer ) {
      src_print_error( stderr, orig_source, NULL );
      err_fatal( __func__, "Nested includes are not permitted\n" );
      exit( 1 );
   }
   orig_buffer = YY_CURRENT_BUFFER;
   yyin = fopen( file, "r" );
   if ( ! yyin ) {
      src_print_error( stderr, orig_source, NULL );
      err_fatal( __func__, "Cannot open \"%s\" for read\n", file );
      exit( 1 );
   }
   src_new_file( file );
   src_new_line ( 0 );
   yy_switch_to_buffer(
      yy_create_buffer( yyin, YY_BUF_SIZE ) );
   BEGIN(INITIAL);
}

static void include_complete( void ) {
   const char *orig_line;
   yy_delete_buffer( YY_CURRENT_BUFFER );
   yy_switch_to_buffer( orig_buffer );
   orig_buffer = NULL;
   BEGIN(OTHER);
   src_new_file( src_filename( orig_source ) );
   orig_line = src_source_line( orig_source );
   src_line( orig_line, strlen( orig_line ) );
   src_new_line( src_linenumber( orig_source ) );
   src_advance( src_offset( orig_source ) + src_length( orig_source ) );
   orig_source = NULL;
}
