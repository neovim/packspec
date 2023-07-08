// vim: set nomodeline

module.exports.expected = {
  name: 'lspconfig',
  description: 'Quickstart configurations for the Nvim-lsp client',
  randomClientDefinedField: 'foo',
  readme: 'readme content',
  engines: { nvim: '^0.10.0', vim: '^9.1.0' },
  repository: {
    type: 'git',
    url: 'git+https://github.com/neovim/nvim-lspconfig.git'
  },
  dependencies: {
    'https://github.com/neovim/neovim': '0.6.1',
    'https://github.com/lewis6991/gitsigns.nvim': '0.3'
  },
  version: '',
  bugs: { url: 'https://github.com/neovim/nvim-lspconfig/issues' },
  homepage: 'https://github.com/neovim/nvim-lspconfig#readme',
  _id: 'lspconfig@',
  license: 'Apache-2.0',
}
