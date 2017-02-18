# List all the cpp files you would like this makefile to compile into a single
# file below...
# Additionally, write the name of the output binary
TARGETS=$(wildcard src/*.cpp)
OUTFILE=main
# Set your compiler
CXX=g++ -g -std=c++11

all: $(OUTFILE)

$(OUTFILE): stanford
	@echo Compiling your code...
	$(CXX) -I$(HOME)/.lib/cpplib/include -L$(HOME)/.lib/cpplib -o $(OUTFILE) $(TARGETS) -lstanford

stanford: $(HOME)/.lib/cpplib $(HOME)/.lib/cpplib/libstanford.a

$(HOME)/.lib/cpplib/libstanford.a: $(HOME)/.lib/cpplib
	@echo Compiling Stanford CPPLib... This may take a while...
	make $(patsubst %.cpp,%.o,$(shell find $(HOME)/.lib/cpplib/src -name \*.cpp -not -name main.cpp))
	ar -cvq $(HOME)/.lib/cpplib/libstanford.a $(HOME)/.lib/cpplib/src/*.o
	@echo Done compiling the Stanford CPPLib.

$(HOME)/.lib/cpplib/src/%.o: $(HOME)/.lib/cpplib/src/%.cpp
	$(CXX) -fPIC -I$(HOME)/.lib/cpplib/include -c $< -o $@

$(HOME)/.lib/cpplib:
	@mkdir -p $(HOME)/.lib
	@wget -O$(HOME)/.lib/cpplib.zip http://eecs.mines.edu/Courses/csci262/resources/dist/cpplib.zip
	@unzip -d $(HOME)/.lib -q -o $(HOME)/.lib/cpplib.zip
	@rm $(HOME)/.lib/cpplib.zip

run: $(OUTFILE)
	./$(OUTFILE) $(ARGS)

zip:
	zip $(OUTFILE).zip $(TARGETS) *.h *.hpp README

clean:
	-rm -f $(OUTFILE)

libclean:
	-rm -rf $(HOME)/.lib/cpplib
