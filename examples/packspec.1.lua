return {
  package = "lspconfig",
  version = "0.1.2",
  packspec = "0.1.0",
  source = "git://github.com/neovim/nvim-lspconfig.git",
  description = {
     summary = "Quickstart configurations for the Nvim-lsp client",
     detailed = [[
     	lspconfig is a set of configurations for language servers for use with Neovim's built-in language server client. Lspconfig handles configuring, launching, and attaching language servers.
     ]],
     homepage = "git://github.com/neovim/nvim-lspconfig/",
     license = "Apache-2.0"
  },
  dependencies = {
     neovim = {
        version = ">= 0.6.1",
        source = "git://github.com/neovim/neovim.git"
     },
     gitsigns = {
        version = "> 0.3",
        source = "git://github.com/lewis6991/gitsigns.nvim.git"
     }
  },
  external_dependencies = {
     git = {
        version = ">= 1.6.0",
     },
  }
}
