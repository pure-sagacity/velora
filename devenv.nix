{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    go
    gopls
    delve
    air
  ];

  languages.go = {
    enable = true;
    enableHardeningWorkaround = true;
    delve.enable = true;
    lsp.enable = true;
  };

  git-hooks.hooks = {
    shellcheck.enable = true;
    nixfmt.enable = true;
    gofmt.enable = true;
    golangci-lint.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
