
CC = g++
FLAGS = -w -std=c++17 -g

INCLUDE = -I/usr/X11R6/include -I/usr/include/GL -I/usr/include -I ./
LIBDIR = -L/usr/X11R6/lib -L/usr/local/lib
LIBS = -lGLEW -lGL -lGLU -lglut -lm -lpng

opengl: opengl.cpp readpng.cpp
	$(CC) $(FLAGS) -o opengl $(INCLUDE) $(LIBDIR) opengl.cpp readpng.cpp $(LIBS)

glslRenderer: demo/demo.cpp readpng.cpp
	$(CC) $(FLAGS) -o demoRenderer $(INCLUDE) $(LIBDIR) demo/demo.cpp readpng.cpp $(LIBS)

clean:
	rm -f *.o opengl demoRenderer core

run_demo:
	.demoRenderer 800 800

all: clean opengl

.PHONY: clean run_demo sll

