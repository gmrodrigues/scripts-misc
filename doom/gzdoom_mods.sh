#!/bin/bash

# Diretório onde os mods estão localizados
MOD_DIR="/home/glauberrodrigues/arquivos/game/doom/"

# Arquivo para salvar o histórico dos comandos
HISTORY_FILE="$HOME/.gzdoom_mod_history"

# Função para listar e selecionar os mods
select_mods() {
    echo "Mods disponíveis:"

    # Encontra todos os arquivos .wad e .pk3 no diretório especificado
    local files=($(find "$MOD_DIR" -type f \( -name "*.wad" -o -name "*.pk3" \)))

    if [ ${#files[@]} -eq 0 ]; then
        echo "Nenhum mod encontrado."
        exit 1
    fi

    for i in "${!files[@]}"; do
        echo "$((i+1))) ${files[i]}"
    done

    echo "Digite os números dos mods que deseja selecionar, separados por espaço:"
    read -a selections

    for i in "${selections[@]}"; do
        MODS_SELECTED+=("${files[$((i-1))]}")
    done
}

# Inicializa o array de mods selecionados
MODS_SELECTED=()

# Chama a função para selecionar os mods
select_mods

# Verifica se algum mod foi selecionado
if [ ${#MODS_SELECTED[@]} -eq 0 ]; then
    echo "Nenhum mod foi selecionado."
    exit 1
fi

# Constrói o comando gzdoom
GZDOOM_CMD="gzdoom"
for MOD in "${MODS_SELECTED[@]}"; do
    GZDOOM_CMD+=" -file $MOD"
done

# Executa o gzdoom com os mods selecionados
echo "Executando: $GZDOOM_CMD"
eval $GZDOOM_CMD

# Salva o comando no histórico
echo $GZDOOM_CMD >> $HISTORY_FILE

