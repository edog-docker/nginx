FROM alpine:3.10

ENV NGINX_VERSION=1.17.10

WORKDIR /usr/local

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --virtual .build-deps \
    gcc \
    autoconf \
    git \
    make \
    pcre-dev \
    zlib-dev \
    gd-dev \
    geoip-dev \
    linux-headers \
    libc-dev \
    libedit-dev \
    libxml2-dev \
    libxslt-dev \
    libressl-dev \
    fcgiwrap \
    spawn-fcgi \
    && wget -c "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
    && git clone --depth 1 https://github.com/aperezdc/ngx-fancyindex.git \
    && tar -zxf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && sed -i 's/\.openssl\///g' auto/lib/openssl/conf \
    && ./configure --prefix=/usr/share/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/var/run/nginx.pid \
    --user=nginx \
    --group=nginx \
    --with-compat \
    --with-pcre \
    --with-threads \
    --with-file-aio \
    --with-stream=dynamic \
    --with-stream_ssl_module \
    --with-stream_geoip_module=dynamic \
    --with-http_ssl_module \
    --with-http_flv_module \
    --with-http_v2_module \
    --with-http_slice_module \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-http_mp4_module \
    --with-http_image_filter_module \
    --with-http_addition_module \
    --with-http_random_index_module \
    --with-http_sub_module  \
    --with-http_dav_module \
    --with-http_auth_request_module \
    --with-http_gunzip_module \
    --with-http_xslt_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_geoip_module=dynamic \
    --with-openssl=/usr \
    --add-dynamic-module=../ngx-fancyindex \
    && make -j$(nproc) \
    && make install \
    && make clean \
    && mkdir /etc/nginx/conf.d \
    && apk del gcc \
    && rm -rf /etc/nginx/*.default \
    /usr/local/ngx-fancyindex \
    /var/cache/apk/*

COPY nginx.conf /etc/nginx/
COPY default.conf /etc/nginx/conf.d/

RUN addgroup -g 1018 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && chown -R nginx:nginx /var/log/nginx /usr/share/nginx/html \
    && nginx -t

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD spawn-fcgi -u nginx -g nginx -s /run/fcgi.sock -F /usr/bin/fcgiwrap \
    && nginx -g "daemon off;"
