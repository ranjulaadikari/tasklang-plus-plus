all: tasklang

tasklang: parser.tab.c parser.tab.h lex.yy.c
	gcc -o tasklang parser.tab.c lex.yy.c -lfl

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l
	flex lexer.l

clean:
	rm -f tasklang parser.tab.c parser.tab.h lex.yy.c
