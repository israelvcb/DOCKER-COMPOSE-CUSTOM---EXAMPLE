#!/bin/bash

# Função para imprimir mensagem colorida
print_color() {
    local color=$1
    local message=$2
    echo -e "\e[${color}m${message}\e[0m"
}

# Função para imprimir título estilizado
print_title() {
    local title=$1
    local title_color=$2
    print_color "$title_color" "\n╔════════════════════════ $title ═════════════════════════╗"
}

# Imprimindo o título estilizado
print_title "COMPOSE CUSTOM ISRAEL FRANÇA" "6;33;40"
print_color "32;1" "GITHUB: israelvcb - LINKEDIN: israel-frança"

# Convertendo o arquivo .env para o formato Unix
print_title "CONVERTENDO O ARQUIVO .ENV PARA O FORMATO UNIX" "6;33;40"
dos2unix .env

# Verificando se a conversão foi bem-sucedida
if [ $? -ne 0 ]; then
    print_color "31" "Erro ao converter o arquivo .env para o formato Unix."
fi
    print_color "32;1" "Arquivo convertido com sucesso !!"


# Carregando variáveis do arquivo .env
print_title "CARREGANDO VARIÁVEIS DO ARQUIVO .ENV" "6;33;40"
if [ -f .env ]; then
    source .env
    print_color "32;1" "Variáveis carregadas com sucesso !!"
else
    print_color "31" "Arquivo .env não encontrado."
fi

# Substituindo variáveis no modelo 'docker-compose.template.yml' e criando 'docker-compose.yml'
print_title "SUBSTITUINDO VARIÁVEIS NO MODELO 'DOCKER-COMPOSE.TEMPLATE.YML'" "6;33;40"
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
print_color "32;1" "Variáveis substituídas com sucesso !!"

# Executando o Docker Compose com o arquivo gerado
print_title "EXECUTANDO O DOCKER COMPOSE" "6;33;40"
# Redirecionando saída padrão e de erro para o terminal
docker compose up --build -d 2>&1

# Verificando se a execução do Docker Compose foi bem-sucedida
if [ $? -ne 0 ]; then
    print_color "31" "Erro ao executar o Docker Compose. Verifique o log para mais detalhes."
fi

# Aguardar a entrada do usuário antes de fechar o script
read -n1 -r -p "╚═══════════════════════ Pressione qualquer tecla para fechar... ═══════════════════════╝"
