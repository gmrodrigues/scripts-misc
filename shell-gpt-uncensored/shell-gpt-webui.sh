# Definindo o nome do serviço e do container
set -xe
SERVICE="ollama ollama-webui"
CONTAINER_NAME="ollama-webui"

# Subindo o serviço em modo detached
docker-compose up -d $SERVICE

# Aguardando o serviço ficar pronto
echo "Aguardando o serviço $SERVICE ficar pronto..."
while ! docker ps | grep -q $CONTAINER_NAME; do
  sleep 1
done
echo "$SERVICE está rodando."

#!/bin/bash
URL='http://localhost:2029'

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open $URL
elif [[ "$OSTYPE" == "darwin"* ]]; then
    open $URL
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
    start $URL
else
    echo "Sistema operacional não suportado!"
fi
