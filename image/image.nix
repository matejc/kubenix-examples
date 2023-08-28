{ dockerTools, nginx, writeTextDir }:
let
  nginxConf = writeTextDir "etc/nginx/nginx.conf" ''
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

  indexHtml = writeTextDir "var/lib/html/index.html" ''
    <html>
      <body>
        <h1>Hello from image demo!</h1>
      </body>
    </html>
  '';
in
dockerTools.buildLayeredImage {
  name = "nginx";
  contents = [ nginx nginxConf indexHtml ];
  extraCommands = ''
    mkdir -p etc
    mkdir -p var/log/nginx
    mkdir -p tmp
    chmod u+w etc
    chmod u+w var/log/nginx
    chmod u+w tmp
    echo "nginx:x:1000:1000::/:" > etc/passwd
    echo "nginx:x:1000:nginx" > etc/group
  '';
  config = {
    Cmd = [ "nginx" "-c" "/etc/nginx/nginx.conf" ];
    ExposedPorts = {
      "80/tcp" = { };
    };
  };
}
