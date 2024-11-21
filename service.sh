#!/bin/bash

if [[ "$1" == "dns" || "$1" == "web" ]] && [[ "$2" == "create" || "$2" == "remove" || "$2" == "stop" || "$2" == "start" ]] || [[ "$3" == "image" || "$3" == "container" ]]; then

    IMAGEM_NOME=$([[ "$1" == "dns" ]] && echo "ubuntu-bind" || echo "nginx")
    CONTAINER_NOME=$([[ "$1" == "dns" ]] && echo "bind9" || echo "web-server")
    IMAGEM_ID=$(docker images -q $IMAGEM_NOME)
    CONTAINER_ID=$(docker ps -aq -f name=$CONTAINER_NOME)
    CONTAINER_STATE=$(docker ps -q -f name=$CONTAINER_NOME -f status=running)

    # Criar imagem
    if [[ "$2" == "create" && "$3" == "image" ]]; then
        if [[ -n $IMAGEM_ID ]]; then
            echo "Já existe uma imagem com o repositório: $IMAGEM_NOME"
        else
            docker build -t $IMAGEM_NOME $1/
        fi

    # Criar container
    elif [[ "$2" == "create" && "$3" == "container" ]]; then
        if [[ -n $IMAGEM_ID ]]; then
            if [[ -n $CONTAINER_ID ]]; then
                echo "Já existe um container com o nome: $CONTAINER_NOME"
            else
                if [[ "$1" == "dns" ]]; then
                    docker run -d -p 53:53/udp -p 53:53/tcp --name $CONTAINER_NOME $IMAGEM_NOME
                elif [[ "$1" == "web" ]]; then
                    docker run -d -p 80:80/tcp --name $CONTAINER_NOME $IMAGEM_NOME
                fi
            fi
        else
            echo "É necessário ter uma imagem $IMAGEM_NOME para criar o container."
        fi

    # Remover imagem
    elif [[ "$2" == "remove" && "$3" == "image" ]]; then
        if [[ -n $IMAGEM_ID ]]; then
            docker rmi $IMAGEM_ID
        else
            echo "A imagem $IMAGEM_NOME não existe."
        fi

    # Remover container
    elif [[ "$2" == "remove" && "$3" == "container" ]]; then
        if [[ -n $CONTAINER_ID ]]; then
	    if [[ -z $CONTAINER_STATE ]]; then
                docker rm $CONTAINER_ID
	    else
		echo "O container $CONTAINER_NOME precisa estar parado para ser removido."
	    fi
        else
            echo "O container $CONTAINER_NOME não existe."
        fi

    # Parar container
    elif [[ "$2" == "stop" ]]; then
        if [[ -n $CONTAINER_ID ]]; then
	    if [[ -n $CONTAINER_STATE ]]; then
                docker stop $CONTAINER_ID
	    else
	        echo "O container $CONTAINER_NOME já está parado."
	    fi
        else
            echo "O container $CONTAINER_NOME não existe."
        fi

    # Iniciar container
    elif [[ "$2" == "start" ]]; then
	if [[ -n $CONTAINER_ID ]];then
	    if [[ -z $CONTAINER_STATE ]]; then
	        docker start $CONTAINER_ID
	    else
	        echo "O container $CONTAINER_NOME já está rodando."
	    fi
        else
            echo "O container $CONTAINER_NOME não existe."
	fi
    fi

else
    echo "Sintaxe correta: ./service.sh <serviço> <ação> <image/container>"
    echo "Serviços disponíveis: dns, web"
    echo "Ações disponíveis: create, remove, stop, start"
    echo "(O terceiro argumento <image/container> só é usado"
    echo "se o segundo argumento for 'create' ou 'remove')"
fi
