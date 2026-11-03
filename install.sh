#!/usr/bin/env bash
# Instala os dotfiles como symlinks apontando pro repo.
# Uso: ./install.sh [perfil]      (perfil padrão: debian-notebook)
# Tudo que já existir no lugar vai pra ~/.dotfiles-backup/<data>/ — dá pra voltar com ./restore.sh
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
PERFIL="${1:-debian-notebook}"
BACKUP="$HOME/.dotfiles-backup/$(date +%F_%H-%M-%S)"

# arquivo do repo  ->  destino na home
COMUNS=(
  "i3/config:.config/i3/config"
  "i3/wallpaper.sh:.config/i3/wallpaper.sh"
  "i3/barra.sh:.config/i3/barra.sh"
  "i3/energia.sh:.config/i3/energia.sh"
  "wallpapers/floresta.png:.config/i3/floresta.png"
  "i3status/config:.config/i3status/config"
  "picom/picom.conf:.config/picom/picom.conf"
  "kitty/kitty.conf:.config/kitty/kitty.conf"
  "kitty/current-theme.conf:.config/kitty/current-theme.conf"
  "rofi/config.rasi:.config/rofi/config.rasi"
  "rofi/natureza.rasi:.config/rofi/natureza.rasi"
  "vim/vimrc:.vimrc"
  "nvim:.config/nvim"
  "starship/starship.toml:.config/starship.toml"
)

# arquivos específicos da máquina: <nome>.<perfil>
ESPECIFICOS=( "bash/bashrc.$PERFIL:.bashrc" )
for f in "$REPO"/bin/*."$PERFIL"; do
  [ -e "$f" ] || continue
  nome="$(basename "$f" ".$PERFIL")"
  ESPECIFICOS+=( "bin/$(basename "$f"):.local/bin/$nome" )
done

[ -f "$REPO/bash/bashrc.$PERFIL" ] || { echo "perfil '$PERFIL' não tem bash/bashrc.$PERFIL"; exit 1; }

linkar() {
  local origem="$REPO/$1" destino="$HOME/$2"
  mkdir -p "$(dirname "$destino")"
  if [ -L "$destino" ] && [ "$(readlink "$destino")" = "$origem" ]; then
    echo "  já ok   ~/$2"; return
  fi
  if [ -e "$destino" ] || [ -L "$destino" ]; then
    mkdir -p "$BACKUP/$(dirname "$2")"
    mv "$destino" "$BACKUP/$2"
    echo "  backup  ~/$2"
  fi
  ln -s "$origem" "$destino"
  echo "  link    ~/$2 -> $1"
}

echo "Instalando perfil: $PERFIL"
for par in "${COMUNS[@]}" "${ESPECIFICOS[@]}"; do linkar "${par%%:*}" "${par#*:}"; done

[ -d "$BACKUP" ] && echo "Backup em: $BACKUP"
if command -v i3-msg >/dev/null && i3-msg -t get_version >/dev/null 2>&1; then
  i3 -C -c "$HOME/.config/i3/config" && i3-msg restart >/dev/null && echo "i3 reiniciado"
fi
