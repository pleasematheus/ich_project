#!/bin/bash

# ==========================================
# ICH (Init Claude Headroom) — uv edition
# ==========================================

TARGET_DIR="."
DIR_EXPLICIT=false
BYPASS=false
RESUME=false
DRY_RUN=false

show_help() {
    cat <<'HELP'
Usage: ich [OPTIONS]

Options:
  -d, --dir <path>   Target project directory
  -b, --bypass       Skip Claude Code permission prompts
  -r, --resume       Resume last Claude Code session
  --dry-run          Show command without executing
  -h, --help         Show this help message
HELP
    exit 0
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--dir)
            if [[ -z "$2" || "$2" == -* ]]; then
                echo "❌ --dir requer um caminho como argumento"
                exit 1
            fi
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
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "❌ Parâmetro desconhecido: $1"
            echo "Use ich --help para ver as opções disponíveis."
            exit 1
            ;;
    esac
done

# Checar dependências
for cmd in claude uv; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "❌ Dependência não encontrada: $cmd"
        exit 2
    fi
done

# Navegar para o diretório do projeto
eval cd "$TARGET_DIR" 2>/dev/null || { echo "❌ Diretório não encontrado: $TARGET_DIR"; exit 3; }
TARGET_RESOLVED="$(pwd)"

# Definir raiz do projeto
if [[ "$DIR_EXPLICIT" == true ]]; then
    PROJECT_ROOT="$TARGET_RESOLVED"
else
    PROJECT_ROOT="$TARGET_RESOLVED"
    FOUND_MARKER=false
    while true; do
        if [[ -f "pyproject.toml" || -d ".git" ]]; then
            PROJECT_ROOT="$(pwd)"
            FOUND_MARKER=true
            break
        fi
        if [[ "$(pwd)" == "/" ]]; then
            break
        fi
        cd ..
    done
    if [[ "$FOUND_MARKER" == false ]]; then
        echo "⚠️ Nenhum marcador (.git/pyproject.toml) encontrado. Usando diretório atual: $TARGET_RESOLVED"
        PROJECT_ROOT="$TARGET_RESOLVED"
    fi
fi

cd "$PROJECT_ROOT" || exit 3
echo "📂 Raiz do projeto definida: $PROJECT_ROOT"

# Montar comando — uv run gerencia o venv automaticamente
CMD=(uv run headroom wrap claude)
if [[ "$BYPASS" == true ]]; then
    CMD+=(--dangerously-skip-permissions)
fi
if [[ "$RESUME" == true ]]; then
    CMD+=(--resume)
fi

# Executar
if [[ "$DRY_RUN" == true ]]; then
    echo "🔍 Dry-run: ${CMD[*]}"
    exit 0
fi

echo "🚀 Iniciando Headroom -> Claude (via uv)..."
"${CMD[@]}"
