
SRCS=$(shell grep 'dofile' loader.lua | sed s/dofile//g |sed s/\"//g | sed 's/src\///')

all: lua

lua: $(SRCS) loader.lua
	luac -o points-module.lua $(SRCS) 

clean:
	rm points-module.lua

