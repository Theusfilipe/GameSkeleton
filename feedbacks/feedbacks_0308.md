- Save/Load é bom manter os logs para você capturar erros e garantir que 
tá salvando ou não
- Começar a usar parâmetros default em funções
- Save/Load faz sentido deixar num singleton/autoload, por que:
	- É útil de ser acessado globalmente
	- Faz sentido ter apenas uma instância obrigatoriamente
	- Precisa de persistência relativa ao estado do jogo
	- Sendo dessa categoria, ele é instanciado antes de tudo,
	inclusive da main scene do projeto (no caso, o master_node)
	- Permite um painel de imgui localizado controlando este autoload
- Não guarde informação de gameplay em UI
- A informação guardada no save é a MENOS COMPLEXA POSSÍVEL. Se puder ser int,
não deveria ser String. Se puder ser bool, não deve ser uma classe.
- Em um sistema de Save/Load, temos que tentar ao máximo separar o
CARREGAMENTO de informações da APLICAÇÃO das informações.
