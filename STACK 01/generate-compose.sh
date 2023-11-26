#!/bin/bash

# Convertendo o arquivo .env para o formato Unix
echo "Convertendo o arquivo .env para o formato Unix..."
dos2unix .env

# Verificando se a conversão foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro ao converter o arquivo .env para o formato Unix."
    exit 1
fi

# Carregando variáveis do arquivo .env
echo "Carregando variáveis do arquivo .env..."
if [ -f .env ]; then
    source .env
else
    echo "Arquivo .env não encontrado."
    exit 1
fi

# Substituindo variáveis no modelo 'docker-compose.template.yml' e criando 'docker-compose.yml'
echo "Substituindo variáveis no modelo 'docker-compose.template.yml'..."
sed -e "s/\${NETWORK_APLICATION_NAME_01}/$NETWORK_APLICATION_NAME_01/g" \
    -e "s/\${SERVICE_DB_NAME}/$SERVICE_DB_NAME/g" \
    -e "s/\${CONTAINER_DB_NAME}/$CONTAINER_DB_NAME/g" \
    -e "s/\${POSTGRES_DB}/$POSTGRES_DB/g" \
    -e "s/\${POSTGRES_USER}/$POSTGRES_USER/g" \
    -e "s/\${POSTGRES_PASSWORD}/$POSTGRES_PASSWORD/g" \
    -e "s/\${VOLUME_NAME_DIRECTORY}/$VOLUME_NAME_DIRECTORY/g" \
    -e "s/\${EXTERNAL_DB_PORT}/$EXTERNAL_DB_PORT/g" \
    -e "s/\${INTERNAL_DB_PORT}/$INTERNAL_DB_PORT/g" \
    docker-compose.template.yml > docker-compose.yml
echo "Variáveis substituídas com sucesso."

# Executando o Docker Compose com o arquivo gerado
echo "Executando o Docker Compose..."
docker compose up --build -d

# Aguardar a entrada do usuário antes de fechar o script

# Verificando se a execução do Docker Compose foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro ao executar o Docker Compose. Verifique o log para mais detalhes."
fi

read -n1 -r -p "Pressione qualquer tecla para fechar..."
