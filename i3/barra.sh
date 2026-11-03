#!/usr/bin/env bash
# Embrulha o i3status pra colocar um botão de energia (⏻) no fim da barra.
# O i3status não sabe lidar com clique, então este script:
#   1) liga o click_events no protocolo da i3bar
#   2) escuta os cliques (chegam em JSON pela entrada padrão) e abre o menu
#   3) repassa cada linha do i3status adicionando o bloco do botão
BOTAO='{"name":"energia","full_text":"  ⏻  ","color":"#e67e80","separator":false,"separator_block_width":0}'

# cliques: a i3bar manda um objeto JSON por linha com o "name" do bloco clicado.
# O "<&0" é obrigatório: sem redirecionamento explícito, o bash liga o stdin de
# todo job em background (&) no /dev/null, e o loop morreria na hora com EOF.
while read -r clique; do
    case "$clique" in
        *'"name":"energia"'*) setsid -f "$HOME/.config/i3/energia.sh" >/dev/null 2>&1 ;;
    esac
done <&0 &

i3status | {
    read -r _cabecalho                       # {"version":1} do i3status
    echo '{"version":1,"click_events":true}'
    while read -r linha; do
        case "$linha" in
            *']') echo "${linha%]},$BOTAO]" ;; # array de blocos: põe o botão no fim
            *)    echo "$linha" ;;             # o "[" que abre o fluxo infinito
        esac
    done
}
