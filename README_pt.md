
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


