FROM buildpack-deps:stable

LABEL maintainer="Igor Moura <hi@igor.mp>"

# Versions of Nginx to use
ENV NGINX_VERSION nginx-1.16.1

# Install dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates openssl libssl-dev ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Download and decompress Nginx
RUN mkdir -p /tmp/build/nginx && \
    cd /tmp/build/nginx && \
    wget -O ${NGINX_VERSION}.tar.gz https://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxf ${NGINX_VERSION}.tar.gz

# Download and decompress RTMP module
RUN mkdir -p /tmp/build/nginx-rtmp-module && \
    cd /tmp/build/nginx-rtmp-module && \
    git clone git://github.com/arut/nginx-rtmp-module.git && \
    cd nginx-rtmp-module

# Build and install Nginx
# The default puts everything under /usr/local/nginx, so it's needed to change
# it explicitly. Not just for order but to have it in the PATH
RUN cd /tmp/build/nginx/${NGINX_VERSION} && \
    ./configure \
    --sbin-path=/usr/local/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/var/run/nginx/nginx.pid \
    --lock-path=/var/lock/nginx/nginx.lock \
    --http-log-path=/var/log/nginx/access.log \
    --http-client-body-temp-path=/tmp/nginx-client-body \
    --with-cc-opt="-Wno-implicit-fallthrough" \
    --with-http_ssl_module \
    --with-threads \
    --with-file-aio \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_stub_status_module \
    --with-http_v2_module \
    --with-stream \
    --with-stream_ssl_module \
    --add-module=/tmp/build/nginx-rtmp-module/nginx-rtmp-module && \
    make -j $(getconf _NPROCESSORS_ONLN) && \
    make install && \
    mkdir /var/lock/nginx && \
    rm -rf /tmp/build

RUN mkdir -p /usr/local/nginx/logs && \
    touch /usr/local/nginx/logs/error.log

# Forward logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Set up config file
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 1935
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]