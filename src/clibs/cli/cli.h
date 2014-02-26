/****************************************************************************/
/**
 * \file
 * \brief Generic CLI
 * \external
 */
/****************************************************************************/

#ifndef PS_PROMPT_H
#define PS_PROMPT_H

#define N_TOKENS	20
#define N_PARAM		20

#include <stdio.h>

struct cmd_tab;

typedef void (*cmd_handler) (int , char *[], const struct cmd_tab *);

//! valores de retorno da execução do comando
enum CLI_ERRORS
{
	CLI_OK,
	CLI_CMD_NOT_FOUND,
	CLI_CMD_TOO_LONG,
	CLI_EXIT,
};

//! estrutura da tabela de comandos
struct cmd_tab
{
	char *token[N_TOKENS];
	cmd_handler handler;	
	char *parms[N_PARAM];
};

#ifdef __cplusplus
    extern "C" {
#endif
	/**
	 * \brief  Executa o comando
	 * \param  command string do comando
	 * \param  tab tabela de comandos
	 * \return \sa enum CLI_ERRORS
	 */
	int exec_cmd(const char *, const struct cmd_tab *tab);

	/**
	 * \brief  Seta os parametros do promt
	 * \param  prompt string que identifica o prompt (p. ex. ">>")
	 * \param  tab  ponteiro para a tabela de comandos do usuário
	 * \return 
	 */
	void prompt(char *prompt, const struct cmd_tab *tab);

	/**
	 * \brief  Executa o prompt
	 * \return 
	 */
	void cli();


	/**
	 * \brief  Abre o arquivo de log da cli
	 * \param  filename nome do arquivo de log
	 * \return \sa fopen
	 */
	FILE *open_log(const char *filename);
#ifdef __cplusplus
}
#endif

#define LOG(fd, str, args...)	\
do {\
	char msg[200];\
	sprintf(msg, str, ##args);\
	fwrite(msg, strlen(msg), 1, fd);\
	fflush(fd);\
} while(0)

#endif

