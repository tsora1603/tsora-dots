return {
  "saeeedhany/parchment.nvim",
  priority = 1000,
  config = function()
    require("parchment").setup({})
    vim.cmd("colorscheme parchment-manuscript")
  end,
}
