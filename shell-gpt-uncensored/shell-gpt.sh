#!/bin/bash
# Por que o Llama 2 é melhor que o ChatGPT (ENTENDA AGORA)
# https://www.youtube.com/watch?v=UJjCCTUYPrw
#
# https://ollama.ai/library

# Definindo o nome do serviço e do container
SERVICE="ollama"
CONTAINER_NAME="ollama"

# Subindo o serviço em modo detached
docker-compose up -d $SERVICE

# Aguardando o serviço ficar pronto
echo "Aguardando o serviço $SERVICE ficar pronto..."
while ! docker ps | grep -q $CONTAINER_NAME; do
  sleep 1
done
echo "$SERVICE está rodando."

# Executando o comando dentro do container
echo "Executando comando no container $CONTAINER_NAME..."
echo dica de prompt: conte uma piada ácida sobre elon musk -- llama2-uncensored

docker-compose exec ollama ollama run llama2-uncensored
