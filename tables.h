/* TABLES_H */

#ifndef TABLES_H
#define TABLES_H

/* Tabela de Literais */

struct lit_table;
typedef struct lit_table LitTable;

// Cria uma estrutura vazia
LitTable* createLitTable();

// Adicionar o literal na tabela
int addLiteral(LitTable* lt, char* s);

// Retorna o ponteiro para o literal da tabela
char* getLiteral(LitTable* lt, int i);

// Printa a tabela de literais
void printLitTable(LitTable* lt);

// Free na labela de literais
void freeLitTable(LitTable* lt);


/* Tabela de Símbolos */

struct sym_table;
typedef struct sym_table SymTable;

// Cria uma estrutura vazia
SymTable* createSymTable();

// Adiciona uma variável nova na tabela
int addVar(SymTable* st, char* s, int line, int size, int scope);

// Retorna o índice da variável ou -1 caso ela não exista
int lookupVar(SymTable* st, char* s, int scope);

// Retorna o nome da variável no índice escolhido
char* getSymName(SymTable* st, int i);

// Retorna a linha em que a variável foi declarada de acordo com o índice
int getSymLine(SymTable* st, int i);

// Retorna o tamanho da variável de acordo com o índice
int getSymSize(SymTable* st, int i);

// Retorna o escopo da variável de acordo com o índice
int getSymScope(SymTable* st, int i);

// Printa a tablea de símbolos
void printSymTable(SymTable* st);

// Free na tabela de símbolos
void freeSymTable(SymTable* st);

/* Tabela de Funções */

struct func_table;
typedef struct func_table FuncTable;

// Cria uma eftrutura vazia
FuncTable* createFuncTable();

// Adiciona uma variável nova na tabela
int addFunc(FuncTable* ft, char* s, int line, int arity);

// Retorna o índice da variável ou -1 caso ela não exifta
int lookupFunc(FuncTable* ft, char* s);

// Retorna o nome da variável no índice escolhido
char* getFuncName(FuncTable* ft, int i);

// Retorna a linha em que a variável foi declarada de acordo com o índice
int getFuncLine(FuncTable* ft, int i);

// Retorna o escopo da variável de acordo com o índice
int getFuncArity(FuncTable* ft, int i);

// Printa a tablea de símbolos
void printFuncTable(FuncTable* ft);

// Free na tabela de símbolos
void freeFuncTable(FuncTable* ft);

#endif // TABLES_H

