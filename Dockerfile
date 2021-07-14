FROM alpine as builder

LABEL maintainer="a little <little@autre.cn> https://coding.autre.cn"

ARG NGINX_VERSION=1.20.1

RUN set -x \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \
                make \
                openssl-dev \
                pcre-dev \
                zlib-dev \
                linux-headers \
                libxslt-dev \
                gd-dev \
                geoip-dev \
                perl-dev \
                libedit-dev \
                mercurial \
                bash \
                alpine-sdk \
                findutils \
    && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar -zxvf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && ./configure \
        --prefix=/usr/local/nginx \
        --user=www \
        --group=www \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/run/nginx/nginx.lock \
        --error-log-path=/var/wwwlogs/error.log \
        --http-log-path=/var/wwwlogs/access.log \
        --conf-path=/etc/nginx/nginx.conf \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-stream \
        --with-stream_ssl_preread_module\
    && make \
    && make install
    #&& apk del .build-deps

FROM alpine as production 

COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /var/run/nginx /var/run/nginx
COPY --from=builder /var/wwwlogs /var/wwwlogs
COPY --from=builder /etc/nginx /etc/nginx

RUN set -x \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache tzdata pcre-dev \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    && rm -rf /tmp/* /var/cache/apk/* \
    && ln -s /usr/local/nginx/sbin/nginx /usr/bin/ \
    && ln -sf /dev/stdout /var/wwwlogs/access.log \
    && ln -sf /dev/stderr /var/wwwlogs/error.log \    
    && addgroup -g 111 -S www \
    && adduser -S -D -u 111 -s /sbin/nologin -G www -g www www
    #&& chown -R www:www /etc/nginx && chown -R www:www /var/wwwlogs \
    
##挂载目录
VOLUME ["/etc/nginx","/var/wwwroot","/var/wwwlogs"]
##conf目录： /etc/nginx
WORKDIR /run/nginx
#开放端口
EXPOSE 80 443 22
STOPSIGNAL SIGTERM
CMD ["nginx","-g","daemon off;"]
