-- tema natureza, combinando com o i3/kitty/rofi
return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_transparent_background = 1 -- deixa a transparência do kitty aparecer
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "everforest" } },
}
