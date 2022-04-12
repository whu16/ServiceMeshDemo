# Envoy routing acceleration with Hyperscan

## Envoy setup

Both of the following options are possible. It is recommended to build from the source code since the machine which builds the Docker image from the community does not have AVX512, so the image also does not have AVX512 optimization. From my perspective, we can use the image one for convenience.

1. Build from the source code

   ```sh
   # Install dependencies
   apt-get update & apt-get install -y wget git
   wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-$([ $(uname -m) = "aarch64" ] && echo "arm64" || echo "amd64")
   chmod +x /usr/local/bin/bazel
   
   apt-get install -y autoconf automake cmake curl libtool make ninja-build patch python3-pip unzip virtualenv

   # Build
   apt-get install -y git
   git clone https://github.com/envoyproxy/envoy
   cd envoy
   git checkout 2572ce6de1a582547a30b59b40f0c614c713f03a
   bazel build -c opt //contrib/exe:envoy-static

   # Run
   bazel-bin/contrib/exe/envoy-static --concurrency 1 -c <PATH_TO_CONF>
   ```

2. Pull from DockerHub

   ```sh
   # Run
   docker run --rm -p 80:80 -v host_configfile_path:container_configurefile_path envoyproxy/envoy-contrib-dev:2572ce6de1a582547a30b59b40f0c614c713f03a --concurrency 1 -c container_configurefile_path/configure_file
   ```


The provided configurations route requests from 0.0.0.0:80 to 127.0.0.1:8080 by default. If you want to listen on different port than 80, change the address in the 6th line, if you are running Envoy with Docker, change the port map command. If the upstream service is deployed in other address, or if you are running Envoy with Docker, change the address in the end two line.

```yaml
# Docker
# docker run --rm -p 80:80 # Change listen address if needed

static_resources:
  listeners:
  - address:
      socket_address:
        address: 0.0.0.0
        port_value: 80  # Change listen address if needed
# omitted
        - endpoint:
            address:
              socket_address:
                address: 127.0.0.1  # Change destination address if needed
                port_value: 8080    # Change destination address if needed
```

## Nginx setup

We need a web server listens to 0.0.0.0:8080, and Nginx will be fine. If the OS is ubuntu, Nginx can be setup with

```sh
# Install
apt-get update && apt-get install -y nginx

# Edit configuration
vi /etc/nginx/sites-enabled/default
# and check if it listens on 8080 like
#
# server {
#         listen 8080 default_server;
#         listen [::]:8080 default_server;
#

# Restart Nginx
systemctl restart nginx
```

You can also let Nginx listen on different port than 8080, but make sure the configuration of Envoy has also been changed.

## Fortio setup

```sh
# Install
curl -L https://github.com/fortio/fortio/releases/download/v1.25.0/fortio-linux_x64-1.25.0.tgz | tar -C / -xvzpf -

# Run
fortio load -allow-initial-errors -log-errors=false -c <CONN_COUNT> --qps 0 -t 60s http://127.0.0.1/
```
