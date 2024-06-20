
-- ~/.config/nvim/lua/custom/plugins.lua

return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server", "stylua",
        "html-lsp", "css-lsp", "prettier",
        "rust-analyzer" -- Add rust-analyzer for Rust language support
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "rust" -- Add rust parser for syntax highlighting
      },
    },
  },
  {
    "simrat39/rust-tools.nvim", -- Add rust-tools.nvim plugin for Rust development
    config = function()
      require("rust-tools").setup {
        server = {
          on_attach = function(_, bufnr)
            -- Add keymaps or other settings specific to Rust here
          end,
          settings = {
            ["rust-analyzer"] = {
              assist = {
                importGranularity = "module",
                importPrefix = "by_self",
              },
              cargo = {
                loadOutDirsFromCheck = true,
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },
  {
    "kyazdani42/nvim-web-devicons", -- Add nvim-web-devicons plugin for vscode-icons
  },
}

