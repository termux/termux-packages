/* clientscan.l -- 
 * Created: Fri Jul 11 11:33:46 1997 by faith@acm.org
 * Copyright 1997, 1998, 1999 Rickard E. Faith (faith@acm.org)
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
#include <stdlib.h>

#include "dict.h"
#include "clientparse.h"
extern int  yylex( void );
extern int  yydebug;
extern void yyerror( const char *message );
#define RETURN(val) do {                  \
   yylval.token.src = src_get( yyleng );  \
   return val;                            \
} while (0)
%}
%s OTHER
comment                     #.*
word                        ([[:alnum:]_/\-\.\*][[:alnum:]_/\-\.\*]*)
string                      \"(([^\"\n])|\"\")*\"
badstring                   \"(([^\"\n])|\"\")*
NL                          \n
WS                          [[:blank:]]+
%%
<INITIAL>{
   .*{NL}                   src_line(yytext,yyleng); yyless(0); BEGIN(OTHER);
   .*                       src_line(yytext,yyleng); yyless(0); BEGIN(OTHER);
}

server                      RETURN(TOKEN_SERVER);
port                        RETURN(TOKEN_PORT);
user                        RETURN(TOKEN_USER);
filter                      RETURN(TOKEN_FILTER);
{word}                      { yylval.token.string = str_findn(yytext, yyleng);
                              RETURN(TOKEN_STRING);
                            }
{string}                    { yylval.token.string
				 = str_findn(yytext+1, yyleng-2);
                              RETURN(TOKEN_STRING);
                            }
{NL}                        BEGIN(INITIAL);
{WS}                        src_advance( yyleng );
{comment}                   src_advance( yyleng );
.                           RETURN(yytext[0]);
<<EOF>>                     RETURN(0);
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
