FROM alpine
#声明作者
LABEL maintainer="nginx docker Autre <mo@autre.cn>"
#升级内核及软件
RUN set -x \
    && apk update \
    && apk upgrade \
    ##设置时区
    && apk add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata
    ## 清除安装软件及缓存
    ##&& rm -rf /tmp/* /var/cache/apk/*
##安装nginx
RUN set -x \
    && addgroup -g 111 -S www \
    && adduser -S -D -u 111 -s /sbin/nologin -G www -g www www \
    && mkdir -p /var/lib/nginx/tmp/client_body /var/lib/nginx/tmp/fastcgi /var/lib/nginx/tmp/proxy /var/lib/nginx/tmp/scgi /var/lib/nginx/tmp/uwsgi \
    && chown -R www:www /var/lib/nginx/tmp \
    && apk add nginx \
    && rm -rf /tmp/* /var/cache/apk/*
##挂载目录
VOLUME ["/etc/nginx","/var/wwwroot","/var/wwwlogs"]
##conf目录： /etc/nginx
##进入命令目录 （不然会出现nginx: [emerg] open() "/var/run/nginx/nginx.pid" failed）
WORKDIR /run/nginx
#开放端口
EXPOSE 80 443
STOPSIGNAL SIGTERM
CMD ["nginx","-g","daemon off;"]
