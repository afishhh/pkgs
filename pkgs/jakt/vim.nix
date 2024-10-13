{ pkgs
, lib
, ...
}:

lib.f.mkPackage pkgs.vimUtils.buildVimPlugin {
  pname = "jakt.vim";
  version = "unstable-2024-10-13";

  patches = [ ./vim_patch_out_lsp.patch ];
  postPatch = ''
    cd editors/vim
  '';
  src = (import ./src.nix).jakt;

  meta = {
    description = "Jakt neovim plugin with LSP attach code patched out.";
    homepage = "https://github.com/SerenityOS/jakt";
    license = lib.licenses.bsd2;
    systems = lib.f.defaultSystems;
    type = lib.f.packageTypes.vimPlugin;
  };
}
