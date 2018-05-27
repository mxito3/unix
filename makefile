mtest:cosine.o sine.o add.o
	gcc cosine.o sine.o add.o -o mtest
cosine.o:cosine.c cosine.h mlib.h
	gcc cosine.c -c cosine.o
sine.o:sine.c sine.h mlib.h
	gcc sine.c -c sine.o 
add.o:add.c add.h mlib.h
	gcc add.c -c add.o

	
