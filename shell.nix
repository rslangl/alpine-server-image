{ pkgs ? import ./nixpkgs.nix }:

  let tools = with pkgs; [
    docker
  ];

  in pkgs.mkShell {
    packages = tools;
    inputsFrom = with pkgs; tools;
  }
