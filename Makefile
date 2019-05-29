
all: bison flex gcc

bison: parser.y
	bison -v parser.y

flex: scanner.l
	flex scanner.l

table: tables.c
	gcc -Wall -c tables.c

gcc: scanner.c parser.c table
	gcc -o trab3 scanner.c parser.c tables.o

clean:
	@rm -f *.o *.output scanner.c parser.h parser.c parser

rm:
	@rm -f trab3 *.o *.output scanner.c parser.h parser.c parser
