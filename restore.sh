#!/usr/bin/env bash
# Desfaz o install.sh: tira os symlinks do repo e devolve o backup.
# Uso: ./restore.sh            (usa o backup mais recente)
#      ./restore.sh <pasta>    (usa um backup específico de ~/.dotfiles-backup)
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
BACKUP="${1:-$(ls -d "$HOME"/.dotfiles-backup/*/ 2>/dev/null | sort | tail -n1)}"
BACKUP="${BACKUP%/}"
[ -d "$BACKUP" ] || { echo "nenhum backup encontrado em ~/.dotfiles-backup"; exit 1; }

echo "Restaurando de: $BACKUP"
# 1) remove todo symlink da home que aponte pra dentro do repo
find "$HOME" -maxdepth 4 -type l -lname "$REPO/*" -not -path "$REPO/*" -print0 |
  while IFS= read -r -d '' l; do rm "$l"; echo "  removido ${l/#$HOME/~}"; done

# 2) devolve os arquivos originais
( cd "$BACKUP" && find . -type f -o -type l ) | while read -r rel; do
  rel="${rel#./}"
  mkdir -p "$HOME/$(dirname "$rel")"
  cp -a "$BACKUP/$rel" "$HOME/$rel"
  echo "  voltou  ~/$rel"
done

pkill -x picom 2>/dev/null || true
if command -v i3-msg >/dev/null && i3-msg -t get_version >/dev/null 2>&1; then
  i3-msg restart >/dev/null && echo "i3 reiniciado"
fi
