#!/bin/bash

# Verifique se o número correto de argumentos foi fornecido
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 [usuario] [mfa-secret] [openvpn-config]"
    exit 1
fi

# Atribua argumentos a variáveis
USUARIO="$1"
MFA_SECRET="$2"
CONFIGPATH="$3"

# Obter o direorio base de CONFIGPATH Mudar para o diretorio
# base para que o openvpn possa encontrar os arquivos de configuração
BASEDIR=$(dirname "$CONFIGPATH")
cd "$BASEDIR"


SENHA=$(oathtool -b --totp "$MFA_SECRET")
echo "token: $SENHA"

# Crie um arquivo temporário para conter o nome de usuário e a senha
CREDENCIAIS=$(mktemp)
echo "CREDENCIAIS: $CREDENCIAIS"

# Escreva o nome de usuário e a senha no arquivo temporário
echo "$USUARIO" > "$CREDENCIAIS"
echo "$SENHA" >> "$CREDENCIAIS"

# Chame o cliente OpenVPN com a opção de autenticação e forneça o arquivo de credenciais
openvpn --config "$CONFIGPATH" --auth-user-pass "$CREDENCIAIS"

# Remova o arquivo temporário após o uso
#rm "$CREDENCIAIS"
