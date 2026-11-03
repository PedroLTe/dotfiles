#!/usr/bin/env bash
# Menu de energia no rofi (tema natureza). Usado pelo botão ⏻ da barra e pelo Super+Shift+e.
opcoes="  bloquear\n  sair do i3\n  reiniciar\n  desligar"
escolha=$(printf "$opcoes" | rofi -dmenu -i -p "energia" \
    -theme-str 'window { width: 300px; } listview { lines: 4; } inputbar { children: [prompt]; }')

case "$escolha" in
    *bloquear)  loginctl lock-session ;;
    *sair*)     i3-msg exit ;;
    *reiniciar) systemctl reboot ;;
    *desligar)  systemctl poweroff ;;
esac
