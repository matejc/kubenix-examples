{ kubenix, config, ... }:
{
  imports = [ kubenix.modules.k8s ];

  kubenix.project = "simple-demo";
  kubernetes.version = "1.26";
  kubernetes.enableHashedNames = true;

  kubernetes.namespace = "simple";
  kubernetes.resources.namespaces.simple = { };

  kubernetes.resources = {
    deployments.nginx.spec = {
      replicas = 3;
      selector.matchLabels.app = "nginx";
      template = {
        metadata.labels.app = "nginx";
        spec = {
          securityContext.fsGroup = 1000;
          containers.nginx = {
            image = "nginx:1.25.1";
            imagePullPolicy = "IfNotPresent";
            volumeMounts = {
              "/etc/nginx".name = "config";
              "/var/lib/html".name = "static";
            };
          };
          volumes = {
            config.configMap.name = config.kubernetes.resources.configMaps.nginx-config.metadata.name;
            static.configMap.name = config.kubernetes.resources.configMaps.nginx-static.metadata.name;
          };
        };
      };
    };

    configMaps = {
      nginx-config.data."nginx.conf" = ''
        user nginx nginx;
        daemon off;
        error_log /dev/stdout info;
        pid /dev/null;
        events {}
        http {
          access_log /dev/stdout;
          server {
            listen 80;
            index index.html;
            location / {
              root /var/lib/html;
            }
          }
        }
      '';

      nginx-static.data."index.html" = ''
        <html>
          <body>
            <h1>Hello from simple demo!</h1>
          </body>
        </html>
      '';
    };

    services.nginx.spec = {
      selector.app = "nginx";
      ports = [
        {
          name = "http";
          port = 80;
        }
      ];
    };
  };
}
