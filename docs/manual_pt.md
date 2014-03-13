
Introdução
============================

Como coordenador de equipe, é parte do meu trabalho fechar o escopos das
entregas e estimar a data de entrega do software. Por meses, enfrentava uma
grande dificuldade em acertar a data de entrega e monitorar as novas demandas
que surgiam ao longo do desenvolvimento. Neste cenário nasceu o Points!

Points é um programa simples e objetivo, baseado no que alguns chamam de KISS,
'Keep It Short and Simple'. Como uma ferramenta de desenvolvimento ágil de
software, Points não tem a pretenção de ser o centro das atenções da equipe de
desenvolvimento. Ao contrário de algumas ferramentas desta área, não tem
features para interação entre os membros da equipe, como chat ou forum. Seu
único objetivo é controlar o prazo e escopo do projeto.

Alinhado com o seu propósito, Points não está sendo desenvolvido com o
propósito de ser *bonito*. Todo o esforço de desenvolvimento é voltado para
funcionalidade e praticidade, de forma a ajudá-lo a estimar e acompanhar a
evolução do seu projeto até o seu objetivo.


Conceitos Básicos
============================

O Scrum prega o desenvolvimento interativo, com entrega parciais, onde o
cliente pode acompanhar o desenvolvimento do software sprint a sprint. Contudo,
existem casos onde precisamos no início do projeto (ou de uma versão) estimar
uma data de entrega. 

A experiência mostrou que o uso de pontos ajuda a estimar uma data mais precisa
que o método com uso de cronograma, contudo isto apenas não basta para tratar
demandas não previstas no início do projeto (data em que a data de entrega é
prometida). Para resolver este problema Points combina o uso do conceito de
**buffer** com o uso de pontos do Scrum. O buffer é estimado como um percentual
de esforço de todo projeto e também é medido em pontos.

Tp = Pp + Up

Tp = Total de pontos do projeto
Pp = Soma dos pontos das tarefas planejadas 
Up = Soma dos pontos das tarefas não planejadas (tamanho do buffer)

Naturalmente, com o andamento do projeto o buffer será gradativamente consumido
por **tarefas não planejadas**. Tarefas não planejadas são tarefas que não são
conhecidas no momento em que a data de entrega é prometida, mas que
inevitavelmente irão aparecer ao longo do desenvolvimento. Points oferece uma
interface para controle de ocupação deste buffer de forma a evitar que tarefas
não planejadas acabem por prejudicar o andamento do projeto.

Para garantir a entrega, Points também oferece uma interface para visualizar a
velocidade do fechamento das tarefas. Neste caso, a ferramenta faz distinção do
*estado da tarefas*, onde esta pode assumir dois valores: **fechada** ou
**aberta**. Combinando então, os tipos de tarefas com os seus estados, temos as
seguintes possiblidades:

1. Tarefas
2. Tarefas abertas 
3. Tarefas fechadas (já concluídas)
4. Tarefas planejadas 
5. Tarefas planejadas abertas
6. Tarefas planejadas fechadas
7. Tarefas não planejadas 
8. Tarefas não planejadas abertas
9. Tarefas não planejadas fechadas

*abertas*: não iniciadas ou em andamento, ainda requerem esforços
*fechadas*: já conluídas, não requerem mais nenhum esforço

O ritmo de como as tarefas vão sendo fechadas vai depender de sua equipe e
apenas dela. Points permite que a velocidade seja especificada membro a membro
ou uma pontuação para toda equipe. Férias, calendário regular, faltas, tudo
isto pode ser especificado e irá regular a velocidade da equipe dia a dia.

Todo o esforço no Points é medido em pontos. A informação em dias que é dada em
alguns gráficos nada mais é do que a relação entre os pontos e a velocidade da
equipe ou de um membro quando a informação é específica de um membro da equipe.
Como Points trabalha com o conceito de buffer, existe alguns conceitos que
precisam ficar bem claros ao se trabalhar com Points.

Total de pontos **Estimados** ou **calculados**: total pontos estimados sempre
leva em consideração os pontos reservados pelo buffer.

Total de pontos **Reais**: total de pontos real é apenas o somatório dos
pontos das tarefas, sem considerar o uso do buffer. 

Com isto temos também a **data final estimada** ou **calculada**, que baseada
no total de pontos estimados. Da mesma forma temos também a **data real** que é
baseada no total de pontos **Reais**. Além destas, Points permite registar uma
terceira data, que é a **data prometida**. Esta data é tratada como um deadline
para o projeto, e Points passa a avisá-lo caso a data calculada ultrapasse
a data prometida.

Tudo isto ainda pode ser visto por mais de uma ótica, ou seja, um mesmo projeto
em diferentes cenários (diferentes equipes, diferentes datas de início, tamanho
de buffer diferente, etc).  Isto é implementado através de *views*. Cada
projeto deve ter no mínimo uma *view*.  Isto permite acompanharmos um mesmo
projeto por diferentes perspectivas, guardando mudanças de escopo, alterações
do time e etc. 

Com tudo isto, Points oferece a você recursos para monitorar se você está
fazendo mais esforço que devia em tarefas não planejadas ou se você está
fechando as tarefas em um ritmo mais lento que o previsto. Agora sim, com
Points você tem todos os recursos para responder as perguntas: 

*What date this release is for?*

*Is your project on time or not?*


Compilação e Execução
============================

# Gerando e executando o binário

No diretório de desenvolvimento fazer

	$ cd src
	$ scons

Será gerado o módulo lua _points-module.lua_ e o binário _points_. O binário
_points_ ao executar precisa encontrar o módulo lua. Isto é feito através da
variável de ambiente _PTSPATH_ que pode ser adicionada ao .bashrc. Exemplo:

	$ export PTSPATH=$HOME/points

# Rodando em modo de desenvolvimento

O binário gerado é apenas uma cli que executa as funções do módulo lua. Durante
o desenvolvimento do código lua o melhor é interfacear utilizando a cli do
próprio lua. Para isto fazer:

	$ lua -i src/loader.lua

O *loader.lua* irá carregar todos os arquivos lua necessários para executar o
Points. A ordem de compilação dos arquivos lua também é tirada deste arquivo,
ou seja, se você adicionar um outro arquivo ao programa é obrigatório que ele
seja carregado a também pelo *loader.lua*


Tutorial básico
============================

Após rodar o Points, o comando de _help_ já pode ser rodado. Basta digitar
'help'. As opções de comandos e seus argumentos serão impressos na tela. Neste
tutorial, apenas os principais comandos serão mostrados. Neste tutorial,
iremos utilizar o database criado especificamente para o manual.

**Database** no Points é o conjunto de arquivos de um ou mais projetos. Um
database é composto de:

1. Um arquivo de especificação do database;
2. Um ou mais arquivos com a especificação das tarefas e esforço das tarefas (pontos);
3. Um arquivo identificando as tarefas planejadas e outro as não planejadas. Um
par de arquivos para cada projeto. 

O primeiro passo é carregar o database.

	>> load db-manual/spec.pts

Algums mensagens de warning irão surgir. Nos seus projetos, estes warnings
devem ser eliminados, mas neste caso, as mensagens são propositais. Vamos pular
a interpretação dos warnings e partir direto para os comandos básicos. Note que
agora a cli informa que um database está carregado.

	loaded >>

Um arquivo de spec de um database pode ter mais de um projeto. No database do
manual tem apenas um projeto. Para cada projeto carregado do database é
impressa a mensagem:

	Loading project manual - Points's manual
	   Creating view start

O próximo passo é selecionar o projeto e a visão do projeto que você quer
trabalhar. No caso do database do manual temos apenas uma opção.

	loaded >> select manual start

A cli informa agora que um projeto/visão foi selecionada. Para cumprir o
fundamento que guia o desenvolvimento do Points (KISS), ele foi concebido com
poucos comandos, mas de forma que você tenha toda a informação útil, e não mais
do que isto, para estimar e monitorar o seu projeto. Os comandos são

1. summary
2. progress
3. todo
4. history

Os próximos passos deste tutorial vão mostrar como interpretar a saída de cada
um destes comandos. Para saber como criar um projeto do zero, veja a seção
[Criandoo seu projeto do zero](#zero).

# summay

	selected >> summary
	                Today : 20-01-13
	                Start : 01-01-13
	                  End : 01-06-13
	     Unplanned Effort : 0.50

O comando summary mostra as informações básicas do projeto.

+ Today: data de hoje
+ Start: data de início do projeto
+ End: deadline ou data prometida. Esta é a data limite para o projeto.
+ Unplanned Effort: percentual estimado para tarefas não planejadas (buffer). O
total de pontos estimado para o projeto será:

Tp = Pp + Up, onde Up = Unplanned Effort * Tp, então
Tp = Pp + Unplanned Effort * Tp
Tp - Unplanned Effort * Tp = Pp
Tp = Pp / (1 - Unplanned Effort)

Pp é sempre conhecido, é o total de pontos das tarefas planejadas.

Importante: o **End** não é data final calculada pelo Points, mas sim a data
que foi prometida a entrega. Points utiliza esta informação para avisá-lo caso
a data calculada seja maior do que a data prometida. Isto é um mau sinal para o
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

A saída do comando **progress** é uma foto do estado atual do pojeto. O mesmo
gráfico é impresso para os três tipos de tarefas: planejadas, não planejadas e
total (planejadas e não planejadas). Vamos descrever todoas as informações para
cada um deles.


**total**

	01-01-13 : data inicial do projeto (veja a saída do comando summary) 
	
	06-03-13 : data final calculada para o projeto. Importante: esta não
			   necessariamente precisa ser a mesma data especificada no
			   **deadline** do arquivo spec.pts. Esta é a data calculada para o
			   projeto, baseada na velocidade da equipe e no tamanho do buffer
			   alocado. No momento do planejamento do projeto ou da versão de
			   software, esta data deve ser usada como referência para a data
			   prometida. A data prometida pode ser maior ou igual a data
			   calculada. Points irá avisá-lo caso a data prometida (deadline) seja
			   menor que a data calculada para o pojeto.
	
	[46.00 points] : total de pontos estimado do projeto (Tp = Pp + Up), onde Up =
	                 Unplanned Effort * Tp (veja summary).
	
	today [28.26%] 13 : velocidade esperada com que a equipe feche as tarefas.
	               13 : expectativa de pontos fechados
		  [28.26%]    : percentual de andamento do projeto (13/46), onde 46 é o
		                total de pontos estimado do projeto.
	
	closed [45.65%] 21 : tarefas fechadas até o momento. Este ponteiro deve estar
						 alinhado com o ponteiro **today**. Se este ponteiro
						 estiver atrás do ponteiro today, a equipe está fechando
						 tarefas mais lentamente do que esperado. Se estiver a
						 frente, está fechando mais rapidamente que o esperado.
	                21 : pontos fechados
		   [45.65%]    : percentual de pontos fechados com relação ao total
		                 estimado (21/46).
	
	all [95.65%] 44 : total de tarefas real (total de pontos de tarefas conhecidas
					  até o momento). Isto é diferente do total de pontos estimados
					  do projeto, pois este último é o somatório dos pontos
					  planejados mais o buffer. **all** neste caso é o total dos
					  pontos de todas as tarefas reais do projeto conhecidas até o
					  momento.
				 44 : total de pontos real
		[95.65%]    : percentual dos pontos reais sobre o total do projeto. Este
					  dado pode ser usado para visualizar o quanto do buffer ainda
					  pode ser consumido, pois quanto mais próximo dos 100%, menos
					  buffer estará disponível. 
	
	open [52.27%] 23 : tarefas ainda abertas que demandam esforço da equipe.
	              23 : pontos abertos.
		 [52.27%]    : percentual de pontos abertos com relação ao total real (all,
		               23/44).
	
	Closed Perf. Index (CPI) : Este é um índice que traduz em números a performance
							   do time de desenvolvimento (relação entre o ponteiro
							   **closed** e o ponteiro **today**). Se o time
							   estiver fechando tarefas mais rápido do que
							   estimado, o índice será maior que 1, caso contrário,
							   menor que 1.

**planned**

	01-01-13 : data inicial do projeto (veja a saída do comando summary) 
	
	06-03-13 : data final calculada para o projeto. Veja a seção acima (**total**)
	           para mais informações.
	
	[23.00 points] : pontos planejados do projeto (50% do total, Unplanned Effort =
	                 0.5).
	
	today [28.26%] 6 : velocidade esperada com que a equipe feche as tarefas planejadas.
	               6 : expectativa de pontos planejados fechados
		  [28.26%]   : percentual de andamento do projeto (6/23), onde 23 são os
		               pontos planejados do projeto.
	
	closed [0.00%] 0 : tarefas planejadas fechadas até o momento. Este ponteiro
					   deve estar alinhado com o ponteiro **today**. Se este
					   ponteiro estiver atrás do ponteiro today, a equipe está
					   fechando tarefas mais lentamente do que esperado.  Se
					   estiver a frente, está fechando mais rapidamente que o
					   esperado.
	               0 : pontos fechados de tarefas planejadas
		   [0.00%]   : percentual de pontos fechados de tarefas planejadas com
		               relação aos pontos planejados (0/23).
	
	all [100.00%] 23 : total de tarefas planejadas. 
				  23 : total pontos planejados.
		[100.00%]    : este será sempre 100%, pois todas no momento do
					   planejamento, todas as tarefas planejadas já devem ser
					   conhecidas.
	
	open [100.00%] 23 : tarefas planejadas ainda abertas que demandam esforço da equipe.
	               23 : pontos planjeados abertos.
		 [100.00%]    : percentual de pontos planejados abertos com relação ao
		                total de pontos planejados 
	
	Closed Perf. Index (CPI) : Este é um índice que traduz em números a performance
							   da equipe de desenvolvimento (relação entre o ponteiro
							   **closed** e o ponteiro **today**). Se o time estiver
							   fechando tarefas planejadas mais rápido do que
							   estimado, o índice será maior que 1, caso contrário,
							   menor que 1.


**unplanned**

	01-01-13 : data inicial do projeto (veja a saída do comando summary) 
	
	today [28.26%] 6 : velocidade esperada com que o buffer seja consumido pelas
					   tarefas não planejadas. Este ponteiro pode ser usado
					   também referência de velocidade para fechamento das tarefas
					   não planejadas, contudo, a velocidade de fechamento de
					   tarefas não planejadas em muitos projetos é irelevante. A
					   velocidade pode ser acompanhada pelo gráfico do **total**.
				   6 : expectativa de pontos consumidos do buffer por tarefas não
				       planejadas.
		  [28.26%]   : percentual do consumo do buffer esperado até o momento.
	
	closed [91.30%] 21 : tarefas nao planejadas fechadas até o momento.
	                21 : pontos fechados de tarefas não planejadas
		   [91.30%]    : percentual de pontos fechados de tarefas não planejadas com
		                 relação ao total de pontos não planejados estimados (0/23).
	
	all [91.30%] 21 : total de tarefas não planejadas reais (aquelas conhecidas
					  até o momento). Este ponteiro mostra o quanto do buffer já
					  foi consumido até o momento. Este ponteiro deve estar
					  alinhado com o ponteiro **today**. Se estiver a frente, o
					  buffer está sendo consumido mais rapidamente do que estimado,
					  caso contrário, mais lentamente.
				 21 : total pontos não planejados.
		[91.30%]    : percentual do buffer consumido até o momento.
	
	open [0.00%] 0 : tarefas não planejadas ainda abertas que demandam esforço da equipe.
	             0 : pontos não planjeados abertos.
		 [0.00%]   : percentual de pontos não planejados abertos com relação ao
				     total de pontos não planejados real (**all**).
	
	Closed Perf. Index (CPI) : Este é um índice que traduz em números a performance
							   da equipe de desenvolvimento (relação entre o ponteiro
							   **closed** e o ponteiro **today**). Se o time estiver
							   fechando tarefas não planejadas mais rápido do que
							   estimado, o índice será maior que 1, caso contrário,
							   menor que 1.
	
	All Perf. Index (CPI) : Este é um índice que traduz em números a velocidade de
							ocupação do buffer por tarefas não planejadas (relação
							entre o ponteiro **all** e o ponteiro **today**. Se o
							buffer estiver sendo ocupado mais rapidamente do que o
							esperado, este indice será maior que 1, caso contrário,
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
comando não utiliza nenhuma informação de buffer ou estimativa, ele apenas
imprime informações das tarefas conhecidas até o momento. O saída impressa é
dividida em três seções: SEVERITY, PRIORITY e MEMBER LOAD. 

Points também classifica as tarefas de acordo com sua severidade. A seção
SEVERITY mostra o percentual de esforço para cada uma delas.

	SEVERITY
               bug     : ++++++++++++++++++++++++++++++++++++ (91.30%)
	
	bug      : severidade da tarefa
	(91.30%) : percentual de esforço a ser investido nesta severidade de tarefa (total de
			   pontos de tarefas da severidade / total de pontos real do projeto).
			   Lembrando que o total de pontos real é o total de pontos das tarefas
			   conhecidas até o momento.

A seção PRIORITY mostra o percentual de esforço a ser investido em cada
prioridade de tarefa. Esta seção pode ser usada para eleger as próximas tarefas
do sprint. O gráfico também informa a data de início e fim para cada uma das
prioridades considerando que todo o esforço da equipe seja investido ao mesmo
tempo em tarefas de maior prioridade.

	PRIORITY
	    0 [      Unspecified] : [20-01-13] ++++++++++++++++++++++++++++++++++++ 21.00 days (91.30%) [18-02-13]

	0                   : indicador da prioridade
	[      Unspecified] : nome dado a prioridade. Ver seção [Criando o seu projeto
	                      do zero](#zero) para mais informa
	[20-01-13]          : data de início do esforço na prioridade. Para a maior
						  prioridade, a data sempre será igual a data **today**.
						  Note que a data de início ou fim só faz sentido se todo o
						  esforço da equipe for investido em tarefas de uma mesma
						  prioridade. Na prática, isto é pouco provável, mas esta
						  data ajuda a visualizar quando cada gropo de tarefa
						  estará finalizado.
	21.00 days          : quantidade de dias de esforço da equipe nas tarefas de
						  uma mesma prioridade. Novamente esta informação só faz
						  sentido se todo o esforço da equipe for investido em
						  tarefas de uma mesma prioridade.
	(91.30%)            : percentual de esforço de tarefas desta prioridade com
						  relação ao total real (total de pontos de tarefas desta
						  prioridade / total de pontos real).
	[18-02-13]          : data final de esforço na prioridade. Note que a data
						  final da última prioridade nem sempre será igual a data
						  calculada do projeto, pois o comando **todo** não
						  considera a utilização do buffer. Esta data será igual
						  apenas quando o buffer estiver com ocupação igual a 100%.

A seção MEMBER LOAD mostra a carga alocada para cada membro da equipe. Não
adianta o projeto estar _on time_ se a carga de tarefas não estiver balanceada
entre os membros da equipe. Este gráfico permite visualizar a ocupação de cada
membro e a data final de trabalho de cada membro.

	MEMBER LOAD
	            leonardo     : ++++++++++++++++++++++++++++++++++++++++ 23.00 days [20-02-13]

	leonardo   : nome do membro da equipe
	23.00 days : dias de esforço do membro para as tarefas alocadas para o membro da equipe.
	[20-02-13] : data final de trabalho do membro.


# Comando history

O comando _history_ pode ser usado para imprimir informações das tarefas
fechadas e também informações de como o buffer foi consumido ao longo do tempo. 

	>> history closed

A saída do comando _history closed_ mostra informações sobre todas tarefas do
projeto. A saída impressa é dividida em três seções: SEVERITY, MEMBER
PERFORMANCE e BURNUP.

Points também classifica as tarefas de acordo com sua severidade. A seção
SEVERITY mostra o percentual de esforço para cada uma delas.

	SEVERITY
                 bug     : ++++++++++++++++++++++++++++++++++++++++ (100.00%)

Para mais informações ver a seção [Comando todo](#todo)

A seção MEMBER PERFORMANCE mostra o informações de eforço já concluído. 

	MEMBER PERFORMANCE
	            leonardo     : +++++++++++++++++++++++++++++++++++++++++ -> (161.54%) 1.62 pts a day

	leonardo       : nome do membro da equipe
	(161.54%)      : percentual com relação ao esperado pelo membro. Quando não
					 informado no database, é atribuido ao membro da equipe a
					 velocidade de 1 ponto por dia.
	1.62 pts a day : número de pontos fechados por dia.

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

	21.00  : total de pontos fechados até o momento (veja ponteiro **total/closed**
	         do comando progress).
	1
	13         : semana e ano (semana 1 do ano 2013)
	13.00      : expectativa de pontos fechados na última semana
	.          : ponteiro de expectativa de pontos fechados por semana
	   2.33
	5.25  1.62 : indice de performance de fechamento das tarefas (CPI) semana a
	             semana. Veja comando progress, indicador CPI.

	>> history buffer

A saída do comando _history buffer_ como o _buffer_ foi consumido ao lonto do
tempo pela tarefas não planejadas. A saída impressa é dividida em duas seções:
SEVERITY e BURNUP.

	SEVERITY
	                 bug     : ++++++++++++++++++++++++++++++++++++++++ (100.00%)

Para mais informações ver a seção [Comando todo](#todo)


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

Nesta seção, iremos criar um database do zero e adicionar nele um projeto com
uma view. O primeiro passo é criar um diretório para o novo database.

	$ mkdir mydatabase
	$ cd mydatabase

O arquivo mais importante do database é o arquivo de especificação. Vamos
criá-lo.

	$ gvim spec.pts

Adicione as seguintes linhas ao arquivo

	files = {
		tasks = {
			"tasks.pts",
			"effort.pts",
		}
	},

Estes são os arquivos com as tarefas do database. No nosso database, vamos
dividir as informações das tarefas em dois arquivos para mostrar uma capacidade
do Points de concatenar as informações. Vamos criar o arquivo _tasks.pts_ e
adicionar a primeira tarefa. O arquivo _effort.pts_ iremos criar após rodar o
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

Estes são os campos obrigatórios de uma tarefa. Se algum destes campos não
existir, Points irá avisá-lo no momento em que o database é carregado. Para
informações de como estes campos são usados no Points, ver a seção [Comandos
básicos](#cmdbasico).

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

Não por acaso a syntax de entrada é a mesma de um script lua. Toda a entrada do
Points é em lua. A tabela _projects_ deve conter todos os seus projetos, No
nosso exemplo, vamos utilizar apenas um (myproject). Vamos analisar campo por
campo.

**name (tipo string)** : nome do projeto. 

**rule (tipo function)** : regra que define quais tarefas vão fazer parte do
projeto. Todas as tarefas contidas nos arquivos de _files.tasks_ serão passadas
como parâmetro pra esta função, onde t é a tarefa. No exmplo acima, estamos
aceitando que todas as tarefas pertencem ao projeto, mas poderia ser diferente.
Por exmplo, poderiamos aceitar apenas as tarefas que tem o _leonardo_ como
_assigned_.

	rule = function(t, id) return t.assigned == "leonardo" end,

Se a função retonar **true** a tarefa irá fazer parte do projeto se retornar
**false** não. Esta regra pode ser mais complexa, envolvendo mais de um campo
de tarefa por exemplo.

	rule = function(t, id) return t.assigned == "leonardo" and t.priority ~= 8 end,

Esta regra aceitará todas as tarefas que estiverem atribuidas ao **leonardo** e
que tiverem prioridade diferente de 8.

A próxima tabela contém as _views_ do projeto. Pode ser mais de uma, mas para o
nosso exemplo vamos utilizar apenas uma.

**team (table)** : tabela que contém os pontos que cada elemento do time irá
fechar por dia. Caso alguma tarefa esteja atribuída à algum membro que não faça
parte do time, será esperado que ele feche 1 ponto por dia (default).

**deadline (date)** : data limite ou data da entrega do projeto (ver seção
[Comandos básicos]).

**planned (table)** : tabela referente as tarefas planejadas. O campo **file (tipo string)**
aponta para o arquivo com informações de tarefas planejadas.

**unplanned (table)** : tabela referente as tarefas planejadas. O campo **file (tipo string)**
aponta para o arquivo com informações de tarefas não planejadas. O campo
**buffer (tipo integer)** indica o tamanho do buffer das tarefas não
planejadas.

Vamos apenas criar os arquivos de planned e unplanned, mas vamos deixá-los vazio.

	$ touch planned.pts
	$ touch unplanned.pts

Agora rode o Points e carregue o database criado.

	$ points
	> load mydatabase

Note que Points o avisou que a tarefa **task1** não está nem no arquivo de
planned e nem no de unplanned. Para toda tarefa, é preciso que seja dito ao
Points se ela pertence ao conjunto de tarefas planejadas ou não planejadas. Se
pertencer ao conjunto de planejadas, seu esforço será usado para calcular a data
final do projeto. Se pertencer ao conjunto de não planejadas, esta irá consumir
o buffer alocado para as tarefas não planejadas.

	Task task1 in unplanned file is worthless

Adicione a seguinte linha no arquivo **planned.pts**.

	["task1"] = {},

Rode novamente o Points. Note que agora ele está avisando que a tarefa
**task1** não tem esforço.

	Task task1 has no effort

O recurso de especificar o esforço em outro arquivo é particularmente
interessante. Um dos motivos é podermos compartilhar a pontuação das tarefas
entre projetos ou até mesmo entre databases. Um outro recurso interessante é você
poder incluir a tarefa no Points, já dizendo se esta é uma tarefa planejada ou
não planejada antes de pontuar a tarefa. Isto é particularmente interessante
quando precisa passar a tarefa por uma reunião de pontuaão. Vamos então criar o
arquivo de esforço e adicionar a pontuação desta tarefa.

	$ gvim effort.pts

Adicione ao arquivo...

	["task1"] = {effort = 21},

Rode o Points novamente. Veja que nenhum aviso foi mostrado desta vez. Veja a
seção [Comandos básicos](#cmdbasico) para ver o estado do seu projeto.

Adicione novas tarefas ao arquivo **tasks.pts**. Algumas delas troque o estado
de **OPEN** para **CLOSED**. Dê pontos e as adicione nos arquivos de planned e
unplanned. Veja como a inclusão de cada tarefa impacta na data final do projeto
e no consumo do buffer. Em caso de dúvida, consulte os arquivos do database
**db-manual**.

Recursos do arquivo spec.pts
============================

# Vacations

Um recurso muito útil para tornar ainda mais precisa a informação de sua equipe
é a tabela de férias (vacations). Ela facilita a utilização do programa
permitindo que você diga quando começa e quando termina as férias dos membros
de sua equipe. Isto evita que você tenha que criar diferentes times ao longo do
tempo para especificar uma redução na velocidade de sua equipe. Abaixo um exemplo:

	vacations = {
		leonardo = {
			{"2012-10-15", "2012-10-30"},
		},
	}

# Today

Today permite a você parar o tempo de uma **view**. Isto, ele permite a você
dizer ao Points que dia é hoje. Este recurso é interessante quando você deseja
congelar o estado do projeto. Exemplo:

	today = "2013-01-20",

