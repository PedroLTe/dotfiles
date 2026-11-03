#!/usr/bin/env bash
# Usa a primeira imagem que achar em ~/Imagens/wallpapers (bota tuas fotos de natureza lá!).
# Se não tiver nenhuma, usa o wallpaper gerado do repo. Sem feh, pinta o fundo de verde musgo.
dir="$HOME/Imagens/wallpapers"
img=$(find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) 2>/dev/null | sort | head -n1)
[ -z "$img" ] && img="$HOME/.config/i3/floresta.png"
if command -v feh >/dev/null && [ -f "$img" ]; then
    feh --no-fehbg --bg-fill "$img"
else
    xsetroot -solid '#2d353b'
fi
