
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


