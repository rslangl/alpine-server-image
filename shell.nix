{ pkgs ? import ./nixpkgs.nix }:

  let tools = with pkgs; [
    docker
  ];

  in pkgs.mkShell {
    packages = tools;
    inputsFrom = with pkgs; tools;

    shellHook = ''
      if ! pgrep -x "dockerd" > /dev/null; then
        echo "Starting Docker daemon..."
        sudo dockerd &
        sleep 5
      fi
    '';
  }
