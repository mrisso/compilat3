	/* TRABALHO 3 DE COMPILADORES - MATHEUS HEMERLY RISSO */

/* Opções do Bison: */
%output "parser.c"
%defines "parser.h"
%define parse.error verbose
%define parse.lac full


%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "parser.h"
#include "tables.h"

int yylex();
void yyerror(const char *err);
extern int yylineno; // Usando yylineno do scanner
extern char *yytext; // Usando yytext do scanner

/* Tratamento de Variáveis */

// Verifica se a variável existe na tabela
void searchVar(char *name);

// Adiciona uma nova variável na tabela
void newVar(char *name, int size);

/* Tratamento de Funções */

// Verifica se a função existe na tabela
void searchFunc(char *name, int arg);

// Adiciona uma nova função na tabela
void newFunc(char *name, int arity);

LitTable *lt;
SymTable *st;
FuncTable *ft;

int arg = 0;
char name[128]; //SYMBOL_MAX_SIZE
int arity = 0;
int scope = 0;

%}

/* TOKENS */
%token ELSE IF INPUT INT OUTPUT RETURN VOID WHILE WRITE NEQ ASSIGN SEMI COMMA LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE NUM ID STRING

%left LT GT EQ NE LE GE
%left PLUS MINUS
%left TIMES OVER

%union
{
	char *str;
	int num;
}

%%

/* CONVENÇÕES SINTÁTICAS */

program : func-decl-list;

func-decl-list : func-decl-list func-decl | func-decl;

func-decl : func-header func-body{scope++;};

func-header : ret-type ID LPAREN params RPAREN{newFunc($<str>2,arity); arity=0; free($<str>2);}; //Criação de uma nova função

func-body : LBRACE opt-var-decl opt-stmt-list RBRACE;

opt-var-decl : %empty | var-decl-list;

opt-stmt-list : %empty | stmt-list;

ret-type : INT | VOID;

params : VOID | param-list;

param-list : param-list COMMA param | param;

param : INT ID {newVar($<str>2, 0); arity++; free($<str>2); }| INT ID LBRACK RBRACK{newVar($<str>2, -1); arity++; free($<str>2);};

var-decl-list : var-decl-list var-decl | var-decl;

var-decl : INT ID SEMI {newVar($<str>2, 0); free($<str>2);} | INT ID LBRACK NUM RBRACK SEMI {newVar($<str>2,$<num>4); free($<str>2);};

stmt-list : stmt-list stmt | stmt;

stmt : assign-stmt | if-stmt | while-stmt | return-stmt | func-call SEMI;

assign-stmt : lval ASSIGN arith-expr SEMI;

lval : ID {searchVar($<str>1); free($<str>1);} | ID LBRACK NUM RBRACK {searchVar($<str>1); free($<str>1);} | ID LBRACK ID RBRACK {searchVar($<str>1); searchVar($<str>3); free($<str>1); free($<str>3);};

if-stmt : IF LPAREN bool-expr RPAREN block | IF LPAREN bool-expr RPAREN block ELSE block;

block : LBRACE opt-stmt-list RBRACE;

while-stmt : WHILE LPAREN bool-expr RPAREN block;

return-stmt : RETURN SEMI | RETURN arith-expr SEMI;

func-call : output-call | write-call | user-func-call;

input-call : INPUT LPAREN RPAREN;

output-call : OUTPUT LPAREN arith-expr RPAREN;

write-call : WRITE LPAREN STRING RPAREN;

user-func-call : ID LPAREN opt-arg-list RPAREN{searchFunc($<str>1,arg); arg=0; free($<str>1);};

opt-arg-list : %empty | arg-list;

arg-list : arg-list COMMA arith-expr{arg++;} | arith-expr{arg++;};

bool-expr : arith-expr LT arith-expr | arith-expr LE arith-expr | arith-expr GT arith-expr
| arith-expr GE arith-expr | arith-expr EQ arith-expr | arith-expr NEQ arith-expr;

arith-expr : arith-expr PLUS arith-expr | arith-expr MINUS arith-expr
| arith-expr TIMES arith-expr | arith-expr OVER arith-expr
| LPAREN arith-expr RPAREN | lval | input-call | user-func-call | NUM;

%%

void searchVar(char *name)
{
	if(lookupVar(st,name,scope) == -1)
	{
        printf("SEMANTIC ERROR (%d): variable '%s' was not declared.\n", yylineno, name);
		free(name);
		freeLitTable(lt);
		freeSymTable(st);
		freeFuncTable(ft);
        exit(1);
	}
}

void newVar(char *name, int size)
{
	int i;
	if((i = lookupVar(st,name,scope)) != -1)
	{
        printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d.\n", yylineno, name, getSymLine(st, i));
		free(name);
		freeLitTable(lt);
		freeSymTable(st);
		freeFuncTable(ft);
        exit(1);
	}
	addVar(st, name, yylineno, size, scope);
}

void searchFunc(char *name, int arg)
{
	int i = lookupFunc(ft, name);

	if(i == -1)
	{
        printf("SEMANTIC ERROR (%d): function '%s' was not declared.\n",yylineno, name);
		free(name);
		freeLitTable(lt);
		freeSymTable(st);
		freeFuncTable(ft);
        exit(1);
	}

	int arity = getFuncArity(ft, i);

	if(arg != arity)
	{
		printf("SEMANTIC ERROR (%d): function '%s' was called with %d arguments but declared with %d parameters.\n", yylineno, name, arg, arity);
		free(name);
		freeLitTable(lt);
		freeSymTable(st);
		freeFuncTable(ft);
		exit(1);
	}

	free(name);
}

void newFunc(char *name, int arity)
{
	int i;
	if((i = lookupFunc(ft, name)) != -1)
	{
        printf("SEMANTIC ERROR (%d): function '%s' already declared at line %d.\n", yylineno, name, getFuncLine(ft, i));
		free(name);
		freeLitTable(lt);
		freeSymTable(st);
		freeFuncTable(ft);
        exit(1);
	}

	addFunc(ft, name, yylineno, arity);
	free(name);
}

void yyerror (char const *err) 
{
	printf("PARSE ERROR (%d): %s\n", yylineno, err);
}

int main() 
{
	lt = createLitTable();
	st = createSymTable();
	ft = createFuncTable();

    int err = yyparse();

    if (err == 0)
	{
        printf("PARSE SUCCESSFUL!\n");
    }

	else //Não imprimir as tabelas no parsing sem sucesso
	{
    	freeLitTable(lt);
    	freeSymTable(st);
		freeFuncTable(ft);
		return 1;
	}

	//Impressão das tabelas
	
    printf("\n");
    printLitTable(lt);
	printf("\n\n");
    printSymTable(st);
	printf("\n\n");
	printFuncTable(ft);

    freeLitTable(lt);
    freeSymTable(st);
	freeFuncTable(ft);

    return 0;
}
