{ pkgs ? import ./nixpkgs.nix }:

  let tools = with pkgs; [
    docker
    ansible
    lxd-lts
  ];

  in pkgs.mkShell {
    packages = tools;
    inputsFrom = with pkgs; tools;

    shellHook = ''
      DOCKER_PID=""
      #LXD_PID=""
      CONTAINER_IP=""

      trap 'echo "Cleanup in progres..."; sudo docker stop $(sudo docker ps -a -q); sudo docker container rm -vf $(sudo docker ps -a -q); sudo docker rmi -f $(sudo docker images -aq); kill $DOCKER_PID; kill $LXD_PID; ssh-keygen -R $CONTAINER_IP; "HOME"/.ssh/ sed -i '2s/.*/CONTAINER/' inventory; echo "Cleanup completed!"' EXIT SIGTERM SIGINT

      ansible-galaxy collection install -r requirements.yml

      ssh-keygen -t rsa -b 4096 -f ssh/ssh -N "" -q

      #echo "Starting LXD daemon..."
      #sudo nohup lxd > /tmp/lxd.log 2>&1 &
      #LXD_PID=$!
      #sleep 1
      #echo "Done!"

      #echo "Starting Docker daemon..."
      #sudo nohup dockerd > /tmp/dockerd.log 2>&1 &
      #DOCKER_PID=$!
      #sleep 1
      #echo "Done!"

      #echo "Building Docker image..."
      #sudo docker build -t alpine:local .
      #sleep 1
      #echo "Done!"

      #echo "Launching Docker container..."
      #sudo docker run --name target -d --cgroupns=host --privileged -v /var/lib/lxd:/var/lib/lxd alpine:local
      #CONTAINER_IP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' target)
      #echo "Done!"

      #sed -i "s/CONTAINER/$CONTAINER_IP/" inventory
      '';
  }
