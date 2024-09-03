local colorschemes = {
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  -- { 'ellisonleao/gruvbox.nvim', priority = 1000 },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'sainnhe/sonokai' },
  { 'sainnhe/everforest' },
  { 'rebelot/kanagawa.nvim', name = 'kanagawa' },
  { 'folke/tokyonight.nvim', priority = 1000 },
  { 'EdenEast/nightfox.nvim' },
  { 'navarasu/onedark.nvim' },
  { 'shaunsingh/nord.nvim' },

  { 'sainnhe/edge' },
  { 'NLKNguyen/papercolor-theme' },
  { 'morhetz/gruvbox' },
  { 'nanotech/jellybeans.vim' },
}

local default_colorscheme = 'kanagawa-wave'

local function setup_colorscheme()
  local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. default_colorscheme)
  if not status_ok then
    vim.notify('Colorscheme ' .. default_colorscheme .. ' not found!', vim.log.levels.ERROR)
    return
  end
end

table.insert(colorschemes, {
  'nvim-lua/plenary.nvim',
  config = setup_colorscheme,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    setup_colorscheme()
  end,
})

return colorschemes
