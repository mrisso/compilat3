#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tables.h"

/* Tabela de Literais */

#define LITERAL_MAX_SIZE 128
#define LITERALS_TABLE_MAX_SIZE 100

struct lit_table {
    char t[LITERALS_TABLE_MAX_SIZE][LITERAL_MAX_SIZE];
    int size;
};

LitTable* createLitTable() {
    LitTable *lt = malloc(sizeof * lt);
    lt->size = 0;
    return lt;
}

int addLiteral(LitTable* lt, char* s) {
    for (int i = 0; i < lt->size; i++) {
        if (strcmp(lt->t[i], s) == 0) {
            return i;
        }
    }
    strcpy(lt->t[lt->size], s);
    int idx_added = lt->size;
    lt->size++;
    return idx_added;
}

char* getLiteral(LitTable* lt, int i) {
    return lt->t[i];
}

void printLitTable(LitTable* lt) {
    printf("Literals table:\n");
    for (int i = 0; i < lt->size; i++) {
        printf("Entry %d -- %s\n", i, getLiteral(lt, i));
    }
}

void freeLitTable(LitTable* lt) {
    free(lt);
}

/* Tabela de Símbolos */

#define SYMBOL_MAX_SIZE 128
#define SYMBOL_TABLE_MAX_SIZE 100

typedef struct {
  char name[SYMBOL_MAX_SIZE];
  int line;
  int size;
  int scope;
} SymEntry;

struct sym_table {
    SymEntry t[SYMBOL_TABLE_MAX_SIZE];
    int size;
};

SymTable* createSymTable() {
    SymTable *st = malloc(sizeof * st);
    st->size = 0;
    return st;
}

int lookupVar(SymTable* st, char* s, int scope) {
    for (int i = 0; i < st->size; i++) {
        if (strcmp(st->t[i].name, s) == 0 && st->t[i].scope == scope)  {
            return i;
        }
    }
    return -1;
}

int addVar(SymTable* st, char* s, int line, int size, int scope) {
    strcpy(st->t[st->size].name, s);
    st->t[st->size].line = line;
	st->t[st->size].size = size;
	st->t[st->size].scope = scope;
    int idx_added = st->size;
    st->size++;
    return idx_added;
}

char* getSymName(SymTable* st, int i) {
    return st->t[i].name;
}

int getSymLine(SymTable* st, int i) {
    return st->t[i].line;
}

int getSymSize(SymTable* st, int i){
	return st->t[i].size;
}

int getSymScope(SymTable* st, int i){
	return st->t[i].scope;
}

void printSymTable(SymTable* st) {
    printf("Variables table:\n");
    for (int i = 0; i < st->size; i++) {
		 printf("Entry %d -- name: %s, line: %d, scope: %d, size: %d\n", i, getSymName(st, i), getSymLine(st, i), getSymScope(st,i), getSymSize(st,i));
    }
}

void freeSymTable(SymTable* st) {
    free(st);
}

/* Tabela de Funções */

#define FUNC_MAX_SIZE 128
#define FUNC_TABLE_MAX_SIZE 100

typedef struct {
  char name[FUNC_MAX_SIZE];
  int line;
  int arity;
} FuncEntry;

struct func_table {
    FuncEntry t[FUNC_TABLE_MAX_SIZE];
    int size;
};

FuncTable* createFuncTable() {
    FuncTable *ft = malloc(sizeof * ft);
    ft->size = 0;
    return ft;
}

int lookupFunc(FuncTable* ft, char* s) {
    for (int i = 0; i < ft->size; i++) {
        if (strcmp(ft->t[i].name, s) == 0)  {
            return i;
        }
    }
    return -1;
}

int addFunc(FuncTable* ft, char* s, int line, int arity){
    strcpy(ft->t[ft->size].name, s);
    ft->t[ft->size].line = line;
	ft->t[ft->size].arity = arity;
    int idx_added = ft->size;
    ft->size++;
    return idx_added;
}

char* getFuncName(FuncTable* ft, int i) {
    return ft->t[i].name;
}

int getFuncLine(FuncTable* ft, int i) {
    return ft->t[i].line;
}

int getFuncArity(FuncTable* ft, int i){
	return ft->t[i].arity;
}

void printFuncTable(FuncTable* ft) {
    printf("Functions table:\n");
    for (int i = 0; i < ft->size; i++) {
		 printf("Entry %d -- name: %s, line: %d, arity: %d\n", i, getFuncName(ft, i), getFuncLine(ft, i), getFuncArity(ft,i));
    }
}

void freeFuncTable(FuncTable* ft) {
    free(ft);
}
