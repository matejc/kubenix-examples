{ kubenix, config, pkgs, ... }:
{
  imports = with kubenix.modules; [ k8s docker ];

  #kubernetes.project = "image-demo";
  kubernetes.version = "1.26";

  kubernetes.namespace = "image";
  kubernetes.resources.namespaces.image = { };

  docker = {
    registry.url = "localhost";
    images.example.image = pkgs.callPackage ./image.nix { };
  };

  kubernetes.resources.pods.example.spec.containers = {
    custom.image = config.docker.images.example.path;
  };
}
