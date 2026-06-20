# ICH (Init Claude Headroom)

> [Leia em Português](README.pt-br.md)

Shell wrapper that bootstraps [Claude Code](https://docs.anthropic.com/en/docs/claude-code) through [Headroom](https://github.com/chopratejas/headroom) — a proxy that reduces Claude Code token consumption — with automatic venv activation and project root detection.

## What it does

1. Resolves project root (looks for `.git` or `.venv` markers)
2. Activates Python venv (project-local or system-level `~/.venv`)
3. Launches Claude Code wrapped in Headroom proxy

## Installation

```bash
# Clone
git clone https://github.com/pleasematheus/ich_project.git

# Make executable and add to PATH
chmod +x ich_project/ich.sh
ln -s "$(pwd)/ich_project/ich.sh" ~/.local/bin/ich
```

### Dependencies

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [Headroom](https://github.com/chopratejas/headroom)

## Usage

```bash
# From inside a project directory
ich

# Point to a specific project
ich --dir ~/my-project

# Skip permission prompts
ich --bypass

# Resume last session
ich --resume

# Combine flags
ich -d ~/my-project -b -r
```

## Flags

| Flag | Short | Description |
|------|-------|-------------|
| `--dir <path>` | `-d` | Target project directory |
| `--bypass` | `-b` | Skip Claude Code permission prompts |
| `--resume` | `-r` | Resume last Claude Code session |

## Project root detection

- **With `--dir`**: uses the specified path directly
- **Without `--dir`**: walks up from current directory until it finds `.git`, `.venv`, or `venv`

## Venv activation priority

1. Project-local `.venv` (inside project root)
2. System-level `~/.venv`
3. No venv (continues without)
