# ICH (Init Claude Headroom)

Shell wrapper que inicializa o [Claude Code](https://docs.anthropic.com/en/docs/claude-code) através do [Headroom](https://github.com/chopratejas/headroom) — um proxy que reduz o consumo de tokens do Claude Code — com ativação automática de venv e detecção de raiz do projeto.

## O que faz

1. Resolve a raiz do projeto (procura por marcadores `.git` ou `.venv`)
2. Ativa o Python venv (local do projeto ou do sistema em `~/.venv`)
3. Inicia o Claude Code envolvido pelo proxy Headroom

## Instalação

```bash
# Clone
git clone https://github.com/pleasematheus/ich_project.git

# Torne executável e adicione ao PATH
chmod +x ich_project/ich.sh
ln -s "$(pwd)/ich_project/ich.sh" ~/.local/bin/ich
```

### Dependências

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [Headroom](https://github.com/chopratejas/headroom)

## Uso

```bash
# De dentro de um diretório de projeto
ich

# Apontar para um projeto específico
ich --dir ~/meu-projeto

# Pular prompts de permissão
ich --bypass

# Retomar última sessão
ich --resume

# Pular ativação do venv
ich --no-venv

# Visualizar comando sem executar
ich --dry-run

# Combinar flags
ich -d ~/meu-projeto -b -r

# Mostrar ajuda
ich --help
```

## Flags

| Flag | Curta | Descrição |
|------|-------|-----------|
| `--dir <caminho>` | `-d` | Diretório do projeto alvo |
| `--bypass` | `-b` | Pula prompts de permissão do Claude Code |
| `--resume` | `-r` | Retoma a última sessão do Claude Code |
| `--no-venv` | `-n` | Pula ativação do venv |
| `--dry-run` | | Mostra comando sem executar |
| `--help` | `-h` | Mostra mensagem de ajuda |

## Detecção da raiz do projeto

- **Com `--dir`**: usa o caminho especificado diretamente
- **Sem `--dir`**: sobe a partir do diretório atual até encontrar `.git`, `.venv` ou `venv`

## Prioridade de ativação do venv

1. `.venv` local do projeto (dentro da raiz do projeto)
2. `~/.venv` do sistema
3. Sem venv (continua sem)
