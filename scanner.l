	/* TRABALHO 2 DE COMPILADORES - MATHEUS HEMERLY RISSO */

	/* Opções do Flex */

	/* Nome do Arquivo de Saída: */
%option outfile="scanner.c"
	/* Não Usar Algumas Funções Desnecessárias */
%option noyywrap
/* Incrementar Automaticamente o Contador de quebra de linhas */
%option yylineno

	/* Include do .h dos Tokens e Declaração de Funções */
%{

#include "parser.h"
#include "tables.h"

#define trataToken(type) return type

void trataErro ();

extern LitTable *lt;

%}

	/* Condicional para tratar comentários */
%x COMENTARIO

%%

	/* Ignorar Espaço e Tab */
[ \t] { }

	/* Palavras Reservadas */

"else"	 { trataToken(ELSE); }
"if"	 { trataToken(IF); }
"input"	 { trataToken(INPUT); }
"int"	 { trataToken(INT); }
"output" { trataToken(OUTPUT); }
"return" { trataToken(RETURN); }
"void"	 { trataToken(VOID); }
"while"	 { trataToken(WHILE); }
"write"	 { trataToken(WRITE); }

	/* Operadores */

"+"	{ trataToken(PLUS); }
"-"	{ trataToken(MINUS); }
"*"	{ trataToken(TIMES); }
"/"	{ trataToken(OVER); }
"<"	{ trataToken(LT); }
"<="	{ trataToken(LE); }
">"	{ trataToken(GT); }
">="	{ trataToken(GE); }
"=="	{ trataToken(EQ); }
"!="	{ trataToken(NEQ); }
"="	{ trataToken(ASSIGN); }

	/* Pontuações */

";"	{ trataToken(SEMI); }
","	{ trataToken(COMMA); }
"("	{ trataToken(LPAREN); }
")"	{ trataToken(RPAREN); }
"["	{ trataToken(LBRACK); }
"]"	{ trataToken(RBRACK); }
"{"	{ trataToken(LBRACE); }
"}"	{ trataToken(RBRACE); }

	/* Outros */

	/* NUM ( 0 a 9) */
[0-9]+	{ yylval.num = atoi(yytext); return NUM; }

	/* ID */
[a-zA-Z][a-zA-Z0-9]*	{ yylval.str = strdup(yytext); return ID; }

	/* Ignorar Comentários */
"//".+|\n	{ }
	/* Entra no condicional de comentário */
"/*"	{ BEGIN(COMENTARIO); }
	/* Sai do condicional ao final do com. */
<COMENTARIO>"*/"	{ BEGIN(INITIAL); }
	/* Ignora o que está dentro */
<COMENTARIO>.|\n	{ }


	/* STRING */
\".*\"	{ yylval.num = addLiteral(lt, yytext); return STRING; }

	/* UNKNOWN */
.	{ trataErro(); }


%%

	/* Funções de tratamento */

void trataErro()
{
	printf("SCANNING ERROR (%d): Unknown symbol %s\n", yylineno, yytext);
	exit(1);
}
