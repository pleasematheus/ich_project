#!/bin/bash

# ==========================================
# ICH (Init Claude Headroom)
# Uso: ich --dir <caminho> --bypass --resume
# ==========================================

TARGET_DIR="."
DIR_EXPLICIT=false
BYPASS=false
RESUME=false

# 1. Parseamento das flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--dir)
            TARGET_DIR="$2"
            DIR_EXPLICIT=true
            shift 2
            ;;
        -b|--bypass)
            BYPASS=true
            shift
            ;;
        -r|--resume)
            RESUME=true
            shift
            ;;
        *)
            echo "❌ Parâmetro desconhecido: $1"
            echo "Uso: ich [--dir <caminho>] [--bypass] [--resume]"
            exit 1
            ;;
    esac
done

# 2. Navega para o diretório do projeto
cd "$TARGET_DIR" || { echo "❌ Diretório não encontrado: $TARGET_DIR"; exit 1; }
TARGET_RESOLVED="$(pwd)"

# 3. Define a raiz do projeto
# Se --dir foi passado, usa diretamente. Senão, sobe até achar .git/.venv.
if [[ "$DIR_EXPLICIT" == true ]]; then
    PROJECT_ROOT="$TARGET_RESOLVED"
else
    PROJECT_ROOT="$TARGET_RESOLVED"
    while true; do
        if [[ -d ".venv" || -d "venv" || -d ".git" ]]; then
            PROJECT_ROOT="$(pwd)"
            break
        fi
        if [[ "$(pwd)" == "/" ]]; then
            break
        fi
        cd ..
    done
fi

# 4. Garante que estamos na raiz do projeto
cd "$PROJECT_ROOT" || exit 1
echo "📂 Raiz do projeto definida: $PROJECT_ROOT"

# 5. Lógica de Ativação do Venv (Local ou Raiz do Sistema)
if [[ -d "$PROJECT_ROOT/.venv" ]]; then
    source "$PROJECT_ROOT/.venv/bin/activate"
    echo "✅ Venv local ativado: $PROJECT_ROOT/.venv"
elif [[ -d "$HOME/.venv" ]]; then
    source "$HOME/.venv/bin/activate"
    echo "✅ Venv do sistema ativado: $HOME/.venv"
else
    echo "ℹ️ Nenhum venv encontrado (nem local nem no sistema), continuando sem venv."
fi

# 6. Monta o comando base do Claude com as flags
CLAUDE_CMD="claude"
if [ "$BYPASS" = true ]; then
    CLAUDE_CMD="$CLAUDE_CMD --dangerously-skip-permissions"
fi

if [ "$RESUME" = true ]; then
    CLAUDE_CMD="$CLAUDE_CMD --resume"
fi

# 7. Executa o Headroom envolvendo o Claude
echo "🚀 Iniciando Headroom -> Claude..."
eval "headroom wrap $CLAUDE_CMD"
