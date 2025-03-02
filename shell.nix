{ pkgs ? import ./nixpkgs.nix }:

  let tools = with pkgs; [
    docker
  ];

  in pkgs.mkShell {
    packages = tools;
    inputsFrom = with pkgs; tools;

    shellHook = ''
      DOCKER_PID=""
      DOCKER_BUILD_RET=""
      DOCKER_RUN_RET=""

      trap 'echo "Cleanup in progres..."; sudo docker stop $(sudo docker ps -a -q); sudo docker rm -vf $(sudo docker ps -a -q); sudo docker rmi -f $(sudo docker images -aq); kill $DOCKER_PID; echo "Cleanup completed!"' EXIT

      if ! pgrep -x "dockerd" > /dev/null; then
        echo "Starting Docker daemon..."
        sudo nohup dockerd > /tmp/dockerd.log 2>&1 &
        DOCKER_PID=$!
        sleep 1
        echo "Done!"
      fi

      if kill -0 $DOCKER_PID 2>/dev/null; then
        echo "Building Docker image..."
        sudo docker build -t alpine:local .
        DOCKER_BUILD_RET=$?
        sleep 1
        echo "Done!"
      fi

      if $DOCKER_BUILD_RET -eq 0; then
        echo "Launching Docker container..."
        sudo docker run -d alpine:local
        echo "Done!"
      fi
    '';
  }
