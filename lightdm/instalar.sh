#!/usr/bin/env bash
# Instala a tela de login natureza no lightdm-gtk-greeter.
# O lightdm não lê a home (permissão 700), então aqui é cópia, não symlink.
# Uso: sudo ./lightdm/instalar.sh            instala (faz backup do conf original)
#      sudo ./lightdm/instalar.sh voltar     devolve o conf original
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "rode com sudo"; exit 1; }

DIR="$(cd "$(dirname "$0")" && pwd)"
CONF=/etc/lightdm/lightdm-gtk-greeter.conf
ORIG="$CONF.original"

if [ "${1:-}" = "voltar" ]; then
    [ -f "$ORIG" ] || { echo "não achei $ORIG"; exit 1; }
    mv "$ORIG" "$CONF"
    rm -rf /usr/share/themes/Natureza /usr/share/backgrounds/natureza
    echo "login original de volta (vale no próximo logout)"
    exit 0
fi

[ -f "$ORIG" ] || cp -a "$CONF" "$ORIG"
install -Dm644 "$DIR/../wallpapers/floresta.png" /usr/share/backgrounds/natureza/floresta.png
install -Dm644 "$DIR/Natureza/gtk-3.0/gtk.css"   /usr/share/themes/Natureza/gtk-3.0/gtk.css
install -m644  "$DIR/lightdm-gtk-greeter.conf"   "$CONF"
echo "pronto! aparece no próximo logout (ou: sudo systemctl restart lightdm, que fecha a sessão)"
