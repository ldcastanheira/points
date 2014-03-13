
Compiling and Executing
============================

# Building and executing Points

In the development directory do it

	$cd src
	$scons

It will build the lua module _points-module.lua_ and the binary
_points_. While executing, the binary _points_ needs to find the lua module. It
is done through the enviroument variable _PTSPATH_ that can be added to
.bashrc file. For example:

	$ export PTSPATH=$HOME/points

# Running in development mode

The binary built is only a cli that execute the functions of lua module. During the
lua code development the best way is interface using the cli of lua itself. To
run the lua mudule from lua do this:

	$ lua -i src/loader.lua

The *loader.lua* will load all necessaried files to execute Points. The lua
file sequence compilation is also get from this file, in other words, if you
add another file to the software it should be loaded by *loader.lua* file as
well.

