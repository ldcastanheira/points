#include <lua5.1/lua.h>
#include <lua5.1/lauxlib.h>
#include <lua5.1/lualib.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>

#include "cli.h"
#include "main.h"

static lua_State	*L;

void f_load(int n, char *arg[], const struct cmd_tab *tab);
void f_select(int n, char *arg[], const struct cmd_tab *tab);
void f_summary(int n, char *arg[], const struct cmd_tab *tab);
void f_todo(int n, char *arg[], const struct cmd_tab *tab);
void f_progress(int n, char *arg[], const struct cmd_tab *tab);
void f_hc(int n, char *arg[], const struct cmd_tab *tab);
void f_hb(int n, char *arg[], const struct cmd_tab *tab);
void f_show(int n, char *arg[], const struct cmd_tab *tab);
void f_export(int n, char *arg[], const struct cmd_tab *tab);
void f_addmodule(int n, char *arg[], const struct cmd_tab *tab);
void f_execcmd(int n, char *arg[], const struct cmd_tab *tab);

struct cmd_tab start[] = 
{
	pts_load,
	pts_addmodule,
	pts_execcmd,
};
struct cmd_tab loaded[] = 
{
	pts_load,
	pts_select,
	pts_addmodule,
	pts_execcmd,
};
struct cmd_tab selected[] = 
{
	pts_load,
	pts_addmodule,
	pts_execcmd,
	pts_select,
	pts_summary,
	pts_progress,
	pts_todo,
	pts_hc,
	pts_hb,
};
struct cmd_tab screenlocked[] = 
{
	pts_load,
	pts_addmodule,
	pts_execcmd,
	pts_select,
	pts_summary,
	pts_progress,
	pts_todo,
	pts_hc,
	pts_hb,
	pts_show,
	pts_export,
};

void f_load(int n, char *arg[], const struct cmd_tab *tab)
{
	// loading new method
	lua_getglobal(L, "points");
	lua_pushstring(L, "new");
	lua_gettable(L, -2); // put function on the top
	
	// pushing arguments
	lua_getglobal(L, "points");
	lua_pushstring(L, arg[0]);

	// calling function
	if (lua_pcall(L, 2, 1, 0) != 0) {
		printf("Fail loading database\n");
		if (lua_tostring(L, -1) == NULL)
			return;
		printf("%s\n", lua_tostring(L, -1));
		return;
	}

	// getting the result
	if (!lua_istable(L, -1))
		return;

	// saving points instance in "pts" variable
	lua_setglobal(L, "pts");

	prompt("loaded >> ", loaded);
}

void f_addmodule(int n, char *arg[], const struct cmd_tab *tab)
{
	lua_getglobal(L, "dofile");

	lua_pushstring(L, arg[0]);

	// calling function
	if (lua_pcall(L, 1, 0, 0) != 0) {
		const char *err;

		err = lua_tostring(L, -1);
		printf("Fail loading %s file\n", arg[0]);
		printf("%s\n", err);
		return;
	}

	prompt(NULL, loaded);
}

void f_execcmd(int n, char *arg[], const struct cmd_tab *tab)
{
	int i;
	lua_getglobal(L, arg[0]);

	// pushing arguments
	for (i=1; i<n; i++) {
		if (isdigit(arg[i][0]))
			lua_pushnumber(L, atoi(arg[i]));
		else
			lua_pushstring(L, arg[i]);
	}

	// calling function
	if (lua_pcall(L, n-1, 0, 0) != 0) {
		printf("Fail running %s command\n", arg[0]);
		return;
	}

	prompt(NULL, loaded);
}


void f_select(int n, char *arg[], const struct cmd_tab *tab)
{
	// loading new method
	lua_getglobal(L, "pts");
	lua_pushstring(L, "select");
	lua_gettable(L, -2); // put function on the top
	
	// pushing arguments
	lua_getglobal(L, "pts");
	lua_pushstring(L, arg[0]);
	lua_pushstring(L, arg[1]);

	// calling function
	if (lua_pcall(L, 3, 1, 0) != 0) {
		return;
	}
	
	// getting the result
	if (!lua_istable(L, -1))
		return;

	// saving view instance in "v" variable
	lua_setglobal(L, "v");

	prompt("selected >> ", selected);
}

static void view_cmd(char *cmd, int n, char *arg[])
{
	int i;

	// loading progress method
	lua_getglobal(L, "v");
	lua_pushstring(L, cmd);
	lua_gettable(L, -2); // put function on the top
	
	// pushing arguments
	lua_getglobal(L, "v");

	for (i=0; i<n; i++) {
		if (isdigit(arg[i][0]))
			lua_pushnumber(L, atoi(arg[i]));
		else
			lua_pushstring(L, arg[i]);
	}

	// calling function
	if (lua_pcall(L, n+1, 0, 0) != 0) {
		return;
	}
}

void f_summary(int n, char *arg[], const struct cmd_tab *tab)
{
	view_cmd("summary", n, arg);
}

void f_todo(int n, char *arg[], const struct cmd_tab *tab)
{
	view_cmd("todo", n, arg);
	prompt(NULL, screenlocked);
}

void f_progress(int n, char *arg[], const struct cmd_tab *tab)
{
	view_cmd("progress", n, arg);
	prompt(NULL, screenlocked);
}

void f_hc(int n, char *arg[], const struct cmd_tab *tab)
{
	view_cmd("hc", n, arg);
	prompt(NULL, screenlocked);
}

void f_hb(int n, char *arg[], const struct cmd_tab *tab)
{
	view_cmd("hb", n, arg);
	prompt(NULL, screenlocked);
}

void f_show(int n, char *arg[], const struct cmd_tab *tab)
{
	view_cmd("show", n, arg);
}

void f_export(int n, char *arg[], const struct cmd_tab *tab)
{
	view_cmd("export", n, arg);
}

int main(int argc, char *argv[])
{
	L = luaL_newstate();
	luaL_openlibs(L);
	char *envval = getenv("PTSPATH");
	char *file;

	if (envval == NULL) 
	{
		printf("Please set PTSPATH environment\n");
		exit(EXIT_FAILURE);
	}

	file = strcat(getenv("PTSPATH"), "/points-module.lua");
	if (access(file, R_OK))
	{
		printf("Points module not found\n");
		exit(EXIT_FAILURE);
	}

	// TODO: lock for points-module in all directory of PATH variable
	if (luaL_dofile(L, file)) 
	{
		printf("Error loading points module.\n");
		exit(EXIT_FAILURE);
	}

	prompt(">> ", start);
	cli();

	return 0;
}

