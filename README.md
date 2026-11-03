# dotfiles 🌲

Minhas configs de Linux. Tema **natureza** (paleta [Everforest](https://github.com/sainnhe/everforest): musgo, folha, terra), com i3 + rofi + kitty meio transparente + picom com cantos arredondados.

## Máquinas (perfis)

Coisas que só fazem sentido numa máquina têm o perfil **no nome do arquivo**:

| perfil | máquina |
|---|---|
| `debian-notebook` | notebook com Debian 13 + i3 |
| `popos-pc` | PC principal com Pop!_OS + NVIDIA *(ainda não adicionado)* |

Exemplos:
- `bash/bashrc.debian-notebook` é o `~/.bashrc` do notebook
- `bin/ligar-bluetooth.debian-notebook` vira `~/.local/bin/ligar-bluetooth`, que só existe no notebook

Para adicionar o PC, crie `bash/bashrc.popos-pc` (e os `bin/*.popos-pc` que precisar) e rode `./install.sh popos-pc`.

## Estrutura

```
bash/       bashrc por máquina
bin/        scripts pro ~/.local/bin (por máquina)
i3/         config do i3 + script do wallpaper
i3status/   barra com as cores do tema
picom/      compositor: cantos arredondados, sombra, fade
kitty/      terminal transparente (background_opacity 0.85)
rofi/       lançador de apps com tema natureza
vim/        vimrc
nvim/       LazyVim (tema everforest transparente)
starship/   prompt
wallpapers/ floresta.png + gerar-floresta.py (gerador do wallpaper)
```

## Instalar

```bash
sudo apt install picom rofi feh fonts-jetbrains-mono gcc make ripgrep fd-find unzip
# LazyVim pede Neovim >= 0.11.2; o do Debian 13 é 0.10.4, então uso o binário oficial em ~/.local:
cd ~/.local/opt && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
  && tar xzf nvim-linux-x86_64.tar.gz && ln -sf ~/.local/opt/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
# Nerd Font pros ícones (kitty usa "JetBrainsMono Nerd Font"):
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd && cd $_ \
  && curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
  && tar xJf JetBrainsMono.tar.xz && fc-cache -f
./install.sh                 # perfil padrão: debian-notebook
```

O `install.sh` cria symlinks da home para o repo, então editar `~/.config/...` é editar o repo. Antes disso ele **move o que já existia** para `~/.dotfiles-backup/<data>/`.

## Não gostei, quero voltar 😅

```bash
./restore.sh                 # devolve o backup mais recente e reinicia o i3
```

Ou, pelo git, as configs de antes do tema estão na tag `original-debian`:

```bash
git checkout original-debian -- i3/config   # volta só o i3, por exemplo
```

Para desligar só a transparência e os cantos arredondados: `pkill picom`.

## Atalhos novos

| atalho | o que faz |
|---|---|
| `Super+Enter` | kitty |
| `Super+d` | rofi (apps) |
| `Super+Tab` | rofi (trocar de janela) |

## Wallpaper

O `wallpaper.sh` usa a primeira imagem que achar em `~/Imagens/wallpapers/`. Se a pasta estiver vazia, usa a `floresta.png` do repo. Para gerar outra floresta, mude o `random.seed` em `gerar-floresta.py` e rode:

```bash
python3 wallpapers/gerar-floresta.py /tmp/f.svg && convert /tmp/f.svg wallpapers/floresta.png
```
