return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
    config = function(_, opts)
      -- let LazyVim set the colorscheme first
      require("lazyvim").setup(opts)

      -- 👇 THEN override highlights
      local colors = require("tokyonight.colors").setup()

      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", {
        fg = colors.purple, -- or colors.purple, colors.cyan, etc.
        bold = true,
      })
    end,
  },
}
