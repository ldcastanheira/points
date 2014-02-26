/****************************************************************************/
/**
 * \file
 * \brief Generic CLI
 * \external
 */
/****************************************************************************/

#define _GNU_SOURCE

#include <readline/readline.h>
#include <readline/history.h>
#include <string.h>
#include <stdlib.h>

#include "cli.h"

static char PROMPT[30];
static const struct cmd_tab *CMDTAB;

/**
 * Internal command that print a help command's instructions
 * 'n' number of parameters 
 * 'tab' command's table
 */
static void help(int n, char *args[], const struct cmd_tab *tab)
{
	int i, j;
	char *cmd = args[0];
	
	for (i = 0; tab[i].token[0] != NULL; i++)
	{
		if (cmd == NULL || strcmp(tab[i].token[0], cmd) == 0)
		{
			for (j = 0; tab[i].token[j] != NULL; j++)		
				printf("%s ", tab[i].token[j]);
			for (j = 0; tab[i].parms[j] != NULL; j++)		
				printf("%s ", tab[i].parms[j]);
			printf("\n");
		}
	}
}

/**
 * Table with internal commands
 */
struct cmd_tab internal_tab[] = 
{
	{{"help"}, help , {""}},
	{{NULL}, NULL , {NULL}},
};

/**
 * Find a command in the table given as argumment
 * 'tab' the table with commands
 * 'token' the token chain of command (including the arguments)
 * 'params' returns the first argument in the token chain
 * return the position of command in the table or -1 if command no found
 */
static int find_cmd(const struct cmd_tab *tab, char *token[], int *params)
{
	int i, j;
	int found;

	for (i = 0; tab[i].token[0] != NULL; i++)
	{
		found = 1;
		for (j = 0; tab[i].token[j] != NULL; j++)
		{
			if (token[j] == NULL || strcmp(tab[i].token[j], token[j]))
			{
				found = 0;
				break;
			}
		}
		if (found)
		{
			*params = j;
			return i;
		}
	}
	return -1;
}

int exec_cmd(const char *command, const struct cmd_tab *tab)
{
	int i, ncmd;
	int cmd_idx, params;
	const char delimiters[] = " ";
	char *token[N_TOKENS + N_PARAM], *cp;

	cp = strdupa(command);
	token[0] = strtok(cp, delimiters);      
	for (i = 1; i < N_TOKENS && token[i-1] != NULL; i++)
		token[i] = strtok (NULL, delimiters);

	if (i >= N_TOKENS)
		return -CLI_CMD_TOO_LONG;

	ncmd = i - 1;

	if ((cmd_idx = find_cmd(tab, token, &params)) >= 0)
	{
		tab[cmd_idx].handler(ncmd-params, &token[params], tab);
		return CLI_OK;
	}
	else if ((cmd_idx = find_cmd(internal_tab, token, &params)) >= 0)
	{
		internal_tab[cmd_idx].handler(ncmd-params, &token[params], tab);
		return CLI_OK;
	}
	else if (token[0] != NULL && !strcmp(token[0], "exit"))
		return CLI_EXIT;

	else if (strlen(command) > 0)
		return -CLI_CMD_NOT_FOUND;

	return CLI_OK;
}

void prompt(char *prompt, const struct cmd_tab *tab)
{
	if (prompt != NULL)
		strncpy(PROMPT, prompt, sizeof(PROMPT));

	if (tab != NULL)
		CMDTAB = tab;
}

void cli()
{
	char *command;

	read_history(".ptshistory");

	while ((command = readline(PROMPT)) != NULL)
	{
		int ret = exec_cmd(command, CMDTAB);

		add_history(command);
		write_history(".ptshistory");

		switch (ret) {
			case CLI_EXIT: 
				return;
			case -CLI_CMD_NOT_FOUND:
				printf("%s: command not found\n", command);
				break;
			case -CLI_CMD_TOO_LONG:
				printf("%s: command too long\n", command);
				break;
		}
		free(command);
	}
}


FILE *open_log(const char *filename)
{
	return fopen(filename, "w");
}

