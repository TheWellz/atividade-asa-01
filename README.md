Aqui eu explico o funcionamento dos parametros para usar meu script
que automatiza a manipulação e criação de imagens e containers no docker.

Mas antes, certifique-se de alterar a seguinte linha de codigo no arquivo "db.asa.br"

Linha 14:   www   IN   A   192.168.1.10

O IP "192.168.1.10" deve ser alterado para o IP da sua maquina, que esteja conectado ao cabo Ethernet ou a rede Wi-fi.

O script "service.sh" pode receber 3 argumentos:
Argumento $1: dns ou web (Serviços)
Argumento $2: create, remove, stop ou start (Ações)
Argumento $3: image ou container (esses argumentos auxiliam as ações: create e remove)

Exemplo de uso:

./service.sh dns create image       (cria a imagem do repositorio ubuntu-bind)
./service.sh dns create container   (cria o container bind9 com a imagem ubuntu-bind)

./service.sh dns remove image       (remove a imagem se não estiver sendo usada por um container)
./service.sh dns remove container   (remove o container se estiver parado)

./service.sh dns stop               (para o container)
./service.sh dns start              (inicia o container)

Se quiser usar os codigos acima no serviço web, altere o argumento $1 para "web"