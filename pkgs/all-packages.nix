{
  jakt = import ./jakt/compiler.nix;
  jakt-language-server = import ./jakt/lsp.nix;
  jakt-vim = import ./jakt/vim.nix;

  cabocha = import ./cabocha/default.nix;
  crfpp = import ./crfpp/default.nix;
}
