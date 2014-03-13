
Introdu��o
============================

Como coordenador de equipe, � parte do meu trabalho fechar o escopos das
entregas e estimar a data de entrega do software. Por meses, enfrentava uma
grande dificuldade em acertar a data de entrega e monitorar as novas demandas
que surgiam ao longo do desenvolvimento. Neste cen�rio nasceu o Points!

Points � um programa simples e objetivo, baseado no que alguns chamam de KISS,
'Keep It Short and Simple'. Como uma ferramenta de desenvolvimento �gil de
software, Points n�o tem a preten��o de ser o centro das aten��es da equipe de
desenvolvimento. Ao contr�rio de algumas ferramentas desta �rea, n�o tem
features para intera��o entre os membros da equipe, como chat ou forum. Seu
�nico objetivo � controlar o prazo e escopo do projeto.

Alinhado com o seu prop�sito, Points n�o est� sendo desenvolvido com o
prop�sito de ser *bonito*. Todo o esfor�o de desenvolvimento � voltado para
funcionalidade e praticidade, de forma a ajud�-lo a estimar e acompanhar a
evolu��o do seu projeto at� o seu objetivo.


Conceitos B�sicos
============================

O Scrum prega o desenvolvimento interativo, com entrega parciais, onde o
cliente pode acompanhar o desenvolvimento do software sprint a sprint. Contudo,
existem casos onde precisamos no in�cio do projeto (ou de uma vers�o) estimar
uma data de entrega. 

A experi�ncia mostrou que o uso de pontos ajuda a estimar uma data mais precisa
que o m�todo com uso de cronograma, contudo isto apenas n�o basta para tratar
demandas n�o previstas no in�cio do projeto (data em que a data de entrega �
prometida). Para resolver este problema Points combina o uso do conceito de
**buffer** com o uso de pontos do Scrum. O buffer � estimado como um percentual
de esfor�o de todo projeto e tamb�m � medido em pontos.

Tp = Pp + Up

Tp = Total de pontos do projeto
Pp = Soma dos pontos das tarefas planejadas 
Up = Soma dos pontos das tarefas n�o planejadas (tamanho do buffer)

Naturalmente, com o andamento do projeto o buffer ser� gradativamente consumido
por **tarefas n�o planejadas**. Tarefas n�o planejadas s�o tarefas que n�o s�o
conhecidas no momento em que a data de entrega � prometida, mas que
inevitavelmente ir�o aparecer ao longo do desenvolvimento. Points oferece uma
interface para controle de ocupa��o deste buffer de forma a evitar que tarefas
n�o planejadas acabem por prejudicar o andamento do projeto.

Para garantir a entrega, Points tamb�m oferece uma interface para visualizar a
velocidade do fechamento das tarefas. Neste caso, a ferramenta faz distin��o do
*estado da tarefas*, onde esta pode assumir dois valores: **fechada** ou
**aberta**. Combinando ent�o, os tipos de tarefas com os seus estados, temos as
seguintes possiblidades:

1. Tarefas
2. Tarefas abertas 
3. Tarefas fechadas (j� conclu�das)
4. Tarefas planejadas 
5. Tarefas planejadas abertas
6. Tarefas planejadas fechadas
7. Tarefas n�o planejadas 
8. Tarefas n�o planejadas abertas
9. Tarefas n�o planejadas fechadas

*abertas*: n�o iniciadas ou em andamento, ainda requerem esfor�os
*fechadas*: j� conlu�das, n�o requerem mais nenhum esfor�o

O ritmo de como as tarefas v�o sendo fechadas vai depender de sua equipe e
apenas dela. Points permite que a velocidade seja especificada membro a membro
ou uma pontua��o para toda equipe. F�rias, calend�rio regular, faltas, tudo
isto pode ser especificado e ir� regular a velocidade da equipe dia a dia.

Todo o esfor�o no Points � medido em pontos. A informa��o em dias que � dada em
alguns gr�ficos nada mais � do que a rela��o entre os pontos e a velocidade da
equipe ou de um membro quando a informa��o � espec�fica de um membro da equipe.
Como Points trabalha com o conceito de buffer, existe alguns conceitos que
precisam ficar bem claros ao se trabalhar com Points.

Total de pontos **Estimados** ou **calculados**: total pontos estimados sempre
leva em considera��o os pontos reservados pelo buffer.

Total de pontos **Reais**: total de pontos real � apenas o somat�rio dos
pontos das tarefas, sem considerar o uso do buffer. 

Com isto temos tamb�m a **data final estimada** ou **calculada**, que baseada
no total de pontos estimados. Da mesma forma temos tamb�m a **data real** que �
baseada no total de pontos **Reais**. Al�m destas, Points permite registar uma
terceira data, que � a **data prometida**. Esta data � tratada como um deadline
para o projeto, e Points passa a avis�-lo caso a data calculada ultrapasse
a data prometida.

Tudo isto ainda pode ser visto por mais de uma �tica, ou seja, um mesmo projeto
em diferentes cen�rios (diferentes equipes, diferentes datas de in�cio, tamanho
de buffer diferente, etc).  Isto � implementado atrav�s de *views*. Cada
projeto deve ter no m�nimo uma *view*.  Isto permite acompanharmos um mesmo
projeto por diferentes perspectivas, guardando mudan�as de escopo, altera��es
do time e etc. 

Com tudo isto, Points oferece a voc� recursos para monitorar se voc� est�
fazendo mais esfor�o que devia em tarefas n�o planejadas ou se voc� est�
fechando as tarefas em um ritmo mais lento que o previsto. Agora sim, com
Points voc� tem todos os recursos para responder as perguntas: 

*What date this release is for?*

*Is your project on time or not?*


Compila��o e Execu��o
============================

# Gerando e executando o bin�rio

No diret�rio de desenvolvimento fazer

	$ cd src
	$ scons

Ser� gerado o m�dulo lua _points-module.lua_ e o bin�rio _points_. O bin�rio
_points_ ao executar precisa encontrar o m�dulo lua. Isto � feito atrav�s da
vari�vel de ambiente _PTSPATH_ que pode ser adicionada ao .bashrc. Exemplo:

	$ export PTSPATH=$HOME/points

# Rodando em modo de desenvolvimento

O bin�rio gerado � apenas uma cli que executa as fun��es do m�dulo lua. Durante
o desenvolvimento do c�digo lua o melhor � interfacear utilizando a cli do
pr�prio lua. Para isto fazer:

	$ lua -i src/loader.lua

O *loader.lua* ir� carregar todos os arquivos lua necess�rios para executar o
Points. A ordem de compila��o dos arquivos lua tamb�m � tirada deste arquivo,
ou seja, se voc� adicionar um outro arquivo ao programa � obrigat�rio que ele
seja carregado a tamb�m pelo *loader.lua*


Tutorial b�sico
============================

Ap�s rodar o Points, o comando de _help_ j� pode ser rodado. Basta digitar
'help'. As op��es de comandos e seus argumentos ser�o impressos na tela. Neste
tutorial, apenas os principais comandos ser�o mostrados. Neste tutorial,
iremos utilizar o database criado especificamente para o manual.

**Database** no Points � o conjunto de arquivos de um ou mais projetos. Um
database � composto de:

1. Um arquivo de especifica��o do database;
2. Um ou mais arquivos com a especifica��o das tarefas e esfor�o das tarefas (pontos);
3. Um arquivo identificando as tarefas planejadas e outro as n�o planejadas. Um
par de arquivos para cada projeto. 

O primeiro passo � carregar o database.

	>> load db-manual/spec.pts

Algums mensagens de warning ir�o surgir. Nos seus projetos, estes warnings
devem ser eliminados, mas neste caso, as mensagens s�o propositais. Vamos pular
a interpreta��o dos warnings e partir direto para os comandos b�sicos. Note que
agora a cli informa que um database est� carregado.

	loaded >>

Um arquivo de spec de um database pode ter mais de um projeto. No database do
manual tem apenas um projeto. Para cada projeto carregado do database �
impressa a mensagem:

	Loading project manual - Points's manual
	   Creating view start

O pr�ximo passo � selecionar o projeto e a vis�o do projeto que voc� quer
trabalhar. No caso do database do manual temos apenas uma op��o.

	loaded >> select manual start

A cli informa agora que um projeto/vis�o foi selecionada. Para cumprir o
fundamento que guia o desenvolvimento do Points (KISS), ele foi concebido com
poucos comandos, mas de forma que voc� tenha toda a informa��o �til, e n�o mais
do que isto, para estimar e monitorar o seu projeto. Os comandos s�o

1. summary
2. progress
3. todo
4. history

Os pr�ximos passos deste tutorial v�o mostrar como interpretar a sa�da de cada
um destes comandos. Para saber como criar um projeto do zero, veja a se��o
[Criandoo seu projeto do zero](#zero).

# summay

	selected >> summary
	                Today : 20-01-13
	                Start : 01-01-13
	                  End : 01-06-13
	     Unplanned Effort : 0.50

O comando summary mostra as informa��es b�sicas do projeto.

+ Today: data de hoje
+ Start: data de in�cio do projeto
+ End: deadline ou data prometida. Esta � a data limite para o projeto.
+ Unplanned Effort: percentual estimado para tarefas n�o planejadas (buffer). O
total de pontos estimado para o projeto ser�:

Tp = Pp + Up, onde Up = Unplanned Effort * Tp, ent�o
Tp = Pp + Unplanned Effort * Tp
Tp - Unplanned Effort * Tp = Pp
Tp = Pp / (1 - Unplanned Effort)

Pp � sempre conhecido, � o total de pontos das tarefas planejadas.

Importante: o **End** n�o � data final calculada pelo Points, mas sim a data
que foi prometida a entrega. Points utiliza esta informa��o para avis�-lo caso
a data calculada seja maior do que a data prometida. Isto � um mau sinal para o
seu projeto.

# Comando progress

	selected >> progress
	                            today [28.26%] 13 
	                                    |
	             total |------------------------------------------------------------| [46.00 points]
	          01-01-13                             |                             |    06-03-13
	                                      closed [45.65%] 21                     |
	                                                                     all [95.65%] 44 
	                              open [52.27%] 23 |---------------------------- |
	                     Closed Perf. Index (CPI) 1.62  All Perf. Index (API) 3.38
	
	                            today [28.26%] 6 
	                                    |
	           planned |------------------------------------------------------------| [23.00 points]
	          01-01-13  |                                                           | 06-03-13
	            closed [0.00%] 0                                                    |
	                                                                        all [100.00%] 23 
	  open [100.00%] 23 |---------------------------------------------------------- |
	                     Closed Perf. Index (CPI) 0.00  All Perf. Index (API) 3.54
	
	                            today [28.26%] 6 
	                                    |
	         unplanned |------------------------------------------------------------| [23.00 points]
	          01-01-13                                                        |       06-03-13
	                                                                 closed [91.30%] 21 
	                                                                   all [91.30%] 21 
	                                                           open [0.00%] 0 |
                     Closed Perf. Index (CPI) 3.23  All Perf. Index (API) 3.23

A sa�da do comando **progress** � uma foto do estado atual do pojeto. O mesmo
gr�fico � impresso para os tr�s tipos de tarefas: planejadas, n�o planejadas e
total (planejadas e n�o planejadas). Vamos descrever todoas as informa��es para
cada um deles.


**total**

	01-01-13 : data inicial do projeto (veja a sa�da do comando summary) 
	
	06-03-13 : data final calculada para o projeto. Importante: esta n�o
			   necessariamente precisa ser a mesma data especificada no
			   **deadline** do arquivo spec.pts. Esta � a data calculada para o
			   projeto, baseada na velocidade da equipe e no tamanho do buffer
			   alocado. No momento do planejamento do projeto ou da vers�o de
			   software, esta data deve ser usada como refer�ncia para a data
			   prometida. A data prometida pode ser maior ou igual a data
			   calculada. Points ir� avis�-lo caso a data prometida (deadline) seja
			   menor que a data calculada para o pojeto.
	
	[46.00 points] : total de pontos estimado do projeto (Tp = Pp + Up), onde Up =
	                 Unplanned Effort * Tp (veja summary).
	
	today [28.26%] 13 : velocidade esperada com que a equipe feche as tarefas.
	               13 : expectativa de pontos fechados
		  [28.26%]    : percentual de andamento do projeto (13/46), onde 46 � o
		                total de pontos estimado do projeto.
	
	closed [45.65%] 21 : tarefas fechadas at� o momento. Este ponteiro deve estar
						 alinhado com o ponteiro **today**. Se este ponteiro
						 estiver atr�s do ponteiro today, a equipe est� fechando
						 tarefas mais lentamente do que esperado. Se estiver a
						 frente, est� fechando mais rapidamente que o esperado.
	                21 : pontos fechados
		   [45.65%]    : percentual de pontos fechados com rela��o ao total
		                 estimado (21/46).
	
	all [95.65%] 44 : total de tarefas real (total de pontos de tarefas conhecidas
					  at� o momento). Isto � diferente do total de pontos estimados
					  do projeto, pois este �ltimo � o somat�rio dos pontos
					  planejados mais o buffer. **all** neste caso � o total dos
					  pontos de todas as tarefas reais do projeto conhecidas at� o
					  momento.
				 44 : total de pontos real
		[95.65%]    : percentual dos pontos reais sobre o total do projeto. Este
					  dado pode ser usado para visualizar o quanto do buffer ainda
					  pode ser consumido, pois quanto mais pr�ximo dos 100%, menos
					  buffer estar� dispon�vel. 
	
	open [52.27%] 23 : tarefas ainda abertas que demandam esfor�o da equipe.
	              23 : pontos abertos.
		 [52.27%]    : percentual de pontos abertos com rela��o ao total real (all,
		               23/44).
	
	Closed Perf. Index (CPI) : Este � um �ndice que traduz em n�meros a performance
							   do time de desenvolvimento (rela��o entre o ponteiro
							   **closed** e o ponteiro **today**). Se o time
							   estiver fechando tarefas mais r�pido do que
							   estimado, o �ndice ser� maior que 1, caso contr�rio,
							   menor que 1.

**planned**

	01-01-13 : data inicial do projeto (veja a sa�da do comando summary) 
	
	06-03-13 : data final calculada para o projeto. Veja a se��o acima (**total**)
	           para mais informa��es.
	
	[23.00 points] : pontos planejados do projeto (50% do total, Unplanned Effort =
	                 0.5).
	
	today [28.26%] 6 : velocidade esperada com que a equipe feche as tarefas planejadas.
	               6 : expectativa de pontos planejados fechados
		  [28.26%]   : percentual de andamento do projeto (6/23), onde 23 s�o os
		               pontos planejados do projeto.
	
	closed [0.00%] 0 : tarefas planejadas fechadas at� o momento. Este ponteiro
					   deve estar alinhado com o ponteiro **today**. Se este
					   ponteiro estiver atr�s do ponteiro today, a equipe est�
					   fechando tarefas mais lentamente do que esperado.  Se
					   estiver a frente, est� fechando mais rapidamente que o
					   esperado.
	               0 : pontos fechados de tarefas planejadas
		   [0.00%]   : percentual de pontos fechados de tarefas planejadas com
		               rela��o aos pontos planejados (0/23).
	
	all [100.00%] 23 : total de tarefas planejadas. 
				  23 : total pontos planejados.
		[100.00%]    : este ser� sempre 100%, pois todas no momento do
					   planejamento, todas as tarefas planejadas j� devem ser
					   conhecidas.
	
	open [100.00%] 23 : tarefas planejadas ainda abertas que demandam esfor�o da equipe.
	               23 : pontos planjeados abertos.
		 [100.00%]    : percentual de pontos planejados abertos com rela��o ao
		                total de pontos planejados 
	
	Closed Perf. Index (CPI) : Este � um �ndice que traduz em n�meros a performance
							   da equipe de desenvolvimento (rela��o entre o ponteiro
							   **closed** e o ponteiro **today**). Se o time estiver
							   fechando tarefas planejadas mais r�pido do que
							   estimado, o �ndice ser� maior que 1, caso contr�rio,
							   menor que 1.


**unplanned**

	01-01-13 : data inicial do projeto (veja a sa�da do comando summary) 
	
	today [28.26%] 6 : velocidade esperada com que o buffer seja consumido pelas
					   tarefas n�o planejadas. Este ponteiro pode ser usado
					   tamb�m refer�ncia de velocidade para fechamento das tarefas
					   n�o planejadas, contudo, a velocidade de fechamento de
					   tarefas n�o planejadas em muitos projetos � irelevante. A
					   velocidade pode ser acompanhada pelo gr�fico do **total**.
				   6 : expectativa de pontos consumidos do buffer por tarefas n�o
				       planejadas.
		  [28.26%]   : percentual do consumo do buffer esperado at� o momento.
	
	closed [91.30%] 21 : tarefas nao planejadas fechadas at� o momento.
	                21 : pontos fechados de tarefas n�o planejadas
		   [91.30%]    : percentual de pontos fechados de tarefas n�o planejadas com
		                 rela��o ao total de pontos n�o planejados estimados (0/23).
	
	all [91.30%] 21 : total de tarefas n�o planejadas reais (aquelas conhecidas
					  at� o momento). Este ponteiro mostra o quanto do buffer j�
					  foi consumido at� o momento. Este ponteiro deve estar
					  alinhado com o ponteiro **today**. Se estiver a frente, o
					  buffer est� sendo consumido mais rapidamente do que estimado,
					  caso contr�rio, mais lentamente.
				 21 : total pontos n�o planejados.
		[91.30%]    : percentual do buffer consumido at� o momento.
	
	open [0.00%] 0 : tarefas n�o planejadas ainda abertas que demandam esfor�o da equipe.
	             0 : pontos n�o planjeados abertos.
		 [0.00%]   : percentual de pontos n�o planejados abertos com rela��o ao
				     total de pontos n�o planejados real (**all**).
	
	Closed Perf. Index (CPI) : Este � um �ndice que traduz em n�meros a performance
							   da equipe de desenvolvimento (rela��o entre o ponteiro
							   **closed** e o ponteiro **today**). Se o time estiver
							   fechando tarefas n�o planejadas mais r�pido do que
							   estimado, o �ndice ser� maior que 1, caso contr�rio,
							   menor que 1.
	
	All Perf. Index (CPI) : Este � um �ndice que traduz em n�meros a velocidade de
							ocupa��o do buffer por tarefas n�o planejadas (rela��o
							entre o ponteiro **all** e o ponteiro **today**. Se o
							buffer estiver sendo ocupado mais rapidamente do que o
							esperado, este indice ser� maior que 1, caso contr�rio,
							menor que 1.

# Comando todo

	selected >> todo
	SEVERITY
	                 bug     : ++++++++++++++++++++++++++++++++++++ (91.30%)
	             feature     : +++ (8.70%)
	
	PRIORITY
	    0 [      Unspecified] : [20-01-13] ++++++++++++++++++++++++++++++++++++ 21.00 days (91.30%) [18-02-13]
	    1 [       Bug urgent] : [19-02-13] +++ 2.00 days (8.70%) [19-02-13]
	
	MEMBER LOAD
	            leonardo     : ++++++++++++++++++++++++++++++++++++++++ 23.00 days [20-02-13]

O comando todo deve ser usado para visualizar o que ainda deve ser feito. Este
comando n�o utiliza nenhuma informa��o de buffer ou estimativa, ele apenas
imprime informa��es das tarefas conhecidas at� o momento. O sa�da impressa �
dividida em tr�s se��es: SEVERITY, PRIORITY e MEMBER LOAD. 

Points tamb�m classifica as tarefas de acordo com sua severidade. A se��o
SEVERITY mostra o percentual de esfor�o para cada uma delas.

	SEVERITY
               bug     : ++++++++++++++++++++++++++++++++++++ (91.30%)
	
	bug      : severidade da tarefa
	(91.30%) : percentual de esfor�o a ser investido nesta severidade de tarefa (total de
			   pontos de tarefas da severidade / total de pontos real do projeto).
			   Lembrando que o total de pontos real � o total de pontos das tarefas
			   conhecidas at� o momento.

A se��o PRIORITY mostra o percentual de esfor�o a ser investido em cada
prioridade de tarefa. Esta se��o pode ser usada para eleger as pr�ximas tarefas
do sprint. O gr�fico tamb�m informa a data de in�cio e fim para cada uma das
prioridades considerando que todo o esfor�o da equipe seja investido ao mesmo
tempo em tarefas de maior prioridade.

	PRIORITY
	    0 [      Unspecified] : [20-01-13] ++++++++++++++++++++++++++++++++++++ 21.00 days (91.30%) [18-02-13]

	0                   : indicador da prioridade
	[      Unspecified] : nome dado a prioridade. Ver se��o [Criando o seu projeto
	                      do zero](#zero) para mais informa
	[20-01-13]          : data de in�cio do esfor�o na prioridade. Para a maior
						  prioridade, a data sempre ser� igual a data **today**.
						  Note que a data de in�cio ou fim s� faz sentido se todo o
						  esfor�o da equipe for investido em tarefas de uma mesma
						  prioridade. Na pr�tica, isto � pouco prov�vel, mas esta
						  data ajuda a visualizar quando cada gropo de tarefa
						  estar� finalizado.
	21.00 days          : quantidade de dias de esfor�o da equipe nas tarefas de
						  uma mesma prioridade. Novamente esta informa��o s� faz
						  sentido se todo o esfor�o da equipe for investido em
						  tarefas de uma mesma prioridade.
	(91.30%)            : percentual de esfor�o de tarefas desta prioridade com
						  rela��o ao total real (total de pontos de tarefas desta
						  prioridade / total de pontos real).
	[18-02-13]          : data final de esfor�o na prioridade. Note que a data
						  final da �ltima prioridade nem sempre ser� igual a data
						  calculada do projeto, pois o comando **todo** n�o
						  considera a utiliza��o do buffer. Esta data ser� igual
						  apenas quando o buffer estiver com ocupa��o igual a 100%.

A se��o MEMBER LOAD mostra a carga alocada para cada membro da equipe. N�o
adianta o projeto estar _on time_ se a carga de tarefas n�o estiver balanceada
entre os membros da equipe. Este gr�fico permite visualizar a ocupa��o de cada
membro e a data final de trabalho de cada membro.

	MEMBER LOAD
	            leonardo     : ++++++++++++++++++++++++++++++++++++++++ 23.00 days [20-02-13]

	leonardo   : nome do membro da equipe
	23.00 days : dias de esfor�o do membro para as tarefas alocadas para o membro da equipe.
	[20-02-13] : data final de trabalho do membro.


# Comando history

O comando _history_ pode ser usado para imprimir informa��es das tarefas
fechadas e tamb�m informa��es de como o buffer foi consumido ao longo do tempo. 

	>> history closed

A sa�da do comando _history closed_ mostra informa��es sobre todas tarefas do
projeto. A sa�da impressa � dividida em tr�s se��es: SEVERITY, MEMBER
PERFORMANCE e BURNUP.

Points tamb�m classifica as tarefas de acordo com sua severidade. A se��o
SEVERITY mostra o percentual de esfor�o para cada uma delas.

	SEVERITY
                 bug     : ++++++++++++++++++++++++++++++++++++++++ (100.00%)

Para mais informa��es ver a se��o [Comando todo](#todo)

A se��o MEMBER PERFORMANCE mostra o informa��es de efor�o j� conclu�do. 

	MEMBER PERFORMANCE
	            leonardo     : +++++++++++++++++++++++++++++++++++++++++ -> (161.54%) 1.62 pts a day

	leonardo       : nome do membro da equipe
	(161.54%)      : percentual com rela��o ao esperado pelo membro. Quando n�o
					 informado no database, � atribuido ao membro da equipe a
					 velocidade de 1 ponto por dia.
	1.62 pts a day : n�mero de pontos fechados por dia.

	BURNUP
	            2.33
	        |5.25  1.62
	        |
	        |
	        |
	        |
	        |
	        |
	        |
	        |
	 21.00 -|  T  T  T
	        |  |  |  |
	        |  |  |  |
	        |  |  |  .  13.00
	        |  |  .  |
	        |  |  |  |
	        |  .  |  |
	        ------------
	           1  2  3
	           13 13 13

	21.00  : total de pontos fechados at� o momento (veja ponteiro **total/closed**
	         do comando progress).
	1
	13         : semana e ano (semana 1 do ano 2013)
	13.00      : expectativa de pontos fechados na �ltima semana
	.          : ponteiro de expectativa de pontos fechados por semana
	   2.33
	5.25  1.62 : indice de performance de fechamento das tarefas (CPI) semana a
	             semana. Veja comando progress, indicador CPI.

	>> history buffer

A sa�da do comando _history buffer_ como o _buffer_ foi consumido ao lonto do
tempo pela tarefas n�o planejadas. A sa�da impressa � dividida em duas se��es:
SEVERITY e BURNUP.

	SEVERITY
	                 bug     : ++++++++++++++++++++++++++++++++++++++++ (100.00%)

Para mais informa��es ver a se��o [Comando todo](#todo)


	BURNUP
	            4.67
	        |10.50 3.23
	        |
	 21.00 -|  T  T  T
	        |  |  |  |
	        |  |  |  |
	        |  |  |  |
	        |  |  |  |
	        |  |  |  |
	        |  |  |  |
	        |  |  |  |
	        |  |  |  |
	        |  |  |  |
	        |  |  |  .  6.50
	        |  |  .  |
	        |  |  |  |
	        |  .  |  |
	        ------------
	           1  2  3
	           13 13 13

	21.00  : total de consumo do buffer em pontos.
	1
	13         : semana e ano (semana 1 do ano 2013)
	6.50       : expectativa do total de pontos consumidos do buffer
	.          : ponteiro de expectativa de pontos de consumo do buffer semana a
	             semana
	   2.33
	5.25  1.62 : indice de performance de consumo do buffer (API) semana a
	             semana. Veja comando **progress**, indicador API.

Criando o seu projeto do zero
============================

Nesta se��o, iremos criar um database do zero e adicionar nele um projeto com
uma view. O primeiro passo � criar um diret�rio para o novo database.

	$ mkdir mydatabase
	$ cd mydatabase

O arquivo mais importante do database � o arquivo de especifica��o. Vamos
cri�-lo.

	$ gvim spec.pts

Adicione as seguintes linhas ao arquivo

	files = {
		tasks = {
			"tasks.pts",
			"effort.pts",
		}
	},

Estes s�o os arquivos com as tarefas do database. No nosso database, vamos
dividir as informa��es das tarefas em dois arquivos para mostrar uma capacidade
do Points de concatenar as informa��es. Vamos criar o arquivo _tasks.pts_ e
adicionar a primeira tarefa. O arquivo _effort.pts_ iremos criar ap�s rodar o
Points.

	$ gvim tasks.pts

Adicione as seguintes linhas ao arquivo

	["task1"] = {
		assigned = "leonardo",
		severity = "bug",
		priority = 0,
		desc = "Task 1",
		status = "OPEN",
		opendate = "01/01/2013",
		changeddate = "01/01/2013",
	},

Estes s�o os campos obrigat�rios de uma tarefa. Se algum destes campos n�o
existir, Points ir� avis�-lo no momento em que o database � carregado. Para
informa��es de como estes campos s�o usados no Points, ver a se��o [Comandos
b�sicos](#cmdbasico).

	projects = {
		myproject = { 
			name = "My first Points project",
			rule = function(t, id) return true end,
			views = {
				["start"] = {
					team = {
						leonardo = 1, 
					},
					start = "2013-01-01",
					deadline = "2013-06-01",
					planned   = {file = "planned.pts"},
					unplanned = {file = "unplanned.pts", rate = 0.5},
				},
			},
		},
	},

N�o por acaso a syntax de entrada � a mesma de um script lua. Toda a entrada do
Points � em lua. A tabela _projects_ deve conter todos os seus projetos, No
nosso exemplo, vamos utilizar apenas um (myproject). Vamos analisar campo por
campo.

**name (tipo string)** : nome do projeto. 

**rule (tipo function)** : regra que define quais tarefas v�o fazer parte do
projeto. Todas as tarefas contidas nos arquivos de _files.tasks_ ser�o passadas
como par�metro pra esta fun��o, onde t � a tarefa. No exmplo acima, estamos
aceitando que todas as tarefas pertencem ao projeto, mas poderia ser diferente.
Por exmplo, poderiamos aceitar apenas as tarefas que tem o _leonardo_ como
_assigned_.

	rule = function(t, id) return t.assigned == "leonardo" end,

Se a fun��o retonar **true** a tarefa ir� fazer parte do projeto se retornar
**false** n�o. Esta regra pode ser mais complexa, envolvendo mais de um campo
de tarefa por exemplo.

	rule = function(t, id) return t.assigned == "leonardo" and t.priority ~= 8 end,

Esta regra aceitar� todas as tarefas que estiverem atribuidas ao **leonardo** e
que tiverem prioridade diferente de 8.

A pr�xima tabela cont�m as _views_ do projeto. Pode ser mais de uma, mas para o
nosso exemplo vamos utilizar apenas uma.

**team (table)** : tabela que cont�m os pontos que cada elemento do time ir�
fechar por dia. Caso alguma tarefa esteja atribu�da � algum membro que n�o fa�a
parte do time, ser� esperado que ele feche 1 ponto por dia (default).

**deadline (date)** : data limite ou data da entrega do projeto (ver se��o
[Comandos b�sicos]).

**planned (table)** : tabela referente as tarefas planejadas. O campo **file (tipo string)**
aponta para o arquivo com informa��es de tarefas planejadas.

**unplanned (table)** : tabela referente as tarefas planejadas. O campo **file (tipo string)**
aponta para o arquivo com informa��es de tarefas n�o planejadas. O campo
**buffer (tipo integer)** indica o tamanho do buffer das tarefas n�o
planejadas.

Vamos apenas criar os arquivos de planned e unplanned, mas vamos deix�-los vazio.

	$ touch planned.pts
	$ touch unplanned.pts

Agora rode o Points e carregue o database criado.

	$ points
	> load mydatabase

Note que Points o avisou que a tarefa **task1** n�o est� nem no arquivo de
planned e nem no de unplanned. Para toda tarefa, � preciso que seja dito ao
Points se ela pertence ao conjunto de tarefas planejadas ou n�o planejadas. Se
pertencer ao conjunto de planejadas, seu esfor�o ser� usado para calcular a data
final do projeto. Se pertencer ao conjunto de n�o planejadas, esta ir� consumir
o buffer alocado para as tarefas n�o planejadas.

	Task task1 in unplanned file is worthless

Adicione a seguinte linha no arquivo **planned.pts**.

	["task1"] = {},

Rode novamente o Points. Note que agora ele est� avisando que a tarefa
**task1** n�o tem esfor�o.

	Task task1 has no effort

O recurso de especificar o esfor�o em outro arquivo � particularmente
interessante. Um dos motivos � podermos compartilhar a pontua��o das tarefas
entre projetos ou at� mesmo entre databases. Um outro recurso interessante � voc�
poder incluir a tarefa no Points, j� dizendo se esta � uma tarefa planejada ou
n�o planejada antes de pontuar a tarefa. Isto � particularmente interessante
quando precisa passar a tarefa por uma reuni�o de pontua�o. Vamos ent�o criar o
arquivo de esfor�o e adicionar a pontua��o desta tarefa.

	$ gvim effort.pts

Adicione ao arquivo...

	["task1"] = {effort = 21},

Rode o Points novamente. Veja que nenhum aviso foi mostrado desta vez. Veja a
se��o [Comandos b�sicos](#cmdbasico) para ver o estado do seu projeto.

Adicione novas tarefas ao arquivo **tasks.pts**. Algumas delas troque o estado
de **OPEN** para **CLOSED**. D� pontos e as adicione nos arquivos de planned e
unplanned. Veja como a inclus�o de cada tarefa impacta na data final do projeto
e no consumo do buffer. Em caso de d�vida, consulte os arquivos do database
**db-manual**.

Recursos do arquivo spec.pts
============================

# Vacations

Um recurso muito �til para tornar ainda mais precisa a informa��o de sua equipe
� a tabela de f�rias (vacations). Ela facilita a utiliza��o do programa
permitindo que voc� diga quando come�a e quando termina as f�rias dos membros
de sua equipe. Isto evita que voc� tenha que criar diferentes times ao longo do
tempo para especificar uma redu��o na velocidade de sua equipe. Abaixo um exemplo:

	vacations = {
		leonardo = {
			{"2012-10-15", "2012-10-30"},
		},
	}

# Today

Today permite a voc� parar o tempo de uma **view**. Isto, ele permite a voc�
dizer ao Points que dia � hoje. Este recurso � interessante quando voc� deseja
congelar o estado do projeto. Exemplo:

	today = "2013-01-20",

