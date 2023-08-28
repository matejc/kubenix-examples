{ kubenix, config, pkgs, ... }:
{
  imports = with kubenix.modules; [ k8s docker ];

  kubenix.project = "image-demo";
  kubernetes.version = "1.26";

  kubernetes.namespace = "image-demo";
  kubernetes.resources.namespaces.image-demo = { };

  docker = {
    registry.url = "localhost";
    images.nginx.image = pkgs.callPackage ./image.nix { };
  };

  kubernetes.resources.pods.nginx.spec.containers = {
    main.image = config.docker.images.nginx.path;
  };
}
