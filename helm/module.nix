{ kubenix, pkgs, config, ... }:
with pkgs.lib;
let
  secretKey = "my very secret key";
in {
  imports = with kubenix.modules; [ helm k8s ];

  kubenix.project = "helm-demo";
  kubernetes.version = "1.26";

  kubernetes.namespace = "helm-demo";
  kubernetes.resources.namespaces.helm-demo = { };

  kubernetes.helm.releases.searxng = {
    chart = kubenix.lib.helm.fetch {
      chart = "searxng";
      repo = "https://charts.searxng.org";
      version = "1.0.0";
      sha256 = "sha256-ovrMVk+g6fYrgUgAyI/UV7ERjImodQxzotBfbwXlL38=";
    };
    values = {
      env.INSTANCE_NAME = "searxng";
      env.BASE_URL = "http://localhost";
      persistance.config.enabled = true;
      searxng.config = {
        server = {
          secret_key = secretKey;
          limiter = true;
        };
        redis.url = "redis://@searxng-redis:6379/0";
      };
      redis.enabled = true;
    };
  };

  kubernetes.resources.pods.searxng-redis-test-connection.spec.containers.wget = {
    command = mkForce [ "nc" ];
    args = mkForce [ "-z" "searxng-redis.${config.kubernetes.namespace}" "6379" ];
  };
}
