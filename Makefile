
CC = g++
FLAGS = -w -std=c++17 -g

INCLUDE = -I/usr/X11R6/include -I/usr/include/GL -I/usr/include -I ./
LIBDIR = -L/usr/X11R6/lib -L/usr/local/lib
LIBS = -lGLEW -lGL -lGLU -lglut -lm -lpng

opengl: opengl.cpp readpng.cpp
	$(CC) $(FLAGS) -o opengl $(INCLUDE) $(LIBDIR) opengl.cpp readpng.cpp $(LIBS)


demo: ./demo/demo.cpp readpng.cpp
	$(CC) $(FLAGS) -o demo/demoRenderer $(INCLUDE) $(LIBDIR) demo/demo.cpp readpng.cpp $(LIBS)

run_demo: demo
	./demo/demoRenderer 800 800

clean:
	rm -f *.o opengl demo/demoRenderer

all: clean opengl

.PHONY: clean all

