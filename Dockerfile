FROM alpine
#声明作者
LABEL maintainer="nginx docker Autre <mo@autre.cn>"
#创建www用户和组，在nginx.conf中用到
RUN adduser -g 50000 -u 50000 -s /sbin/nologin -D -H www
#升级内核及软件
RUN apk update \
    && apk upgrade \
    ##设置时区
    && apk --update add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    ## 清除安装软件及缓存
    && rm -rf /tmp/* /var/cache/apk/*
##安装nginx
RUN apk --update add --no-cache nginx \
    && rm -rf /tmp/* /var/cache/apk/*
    ## 创建网站和日志目录
    ##&& mkdir -p /var/wwwroot /var/wwwlogs
##挂载目录
VOLUME ["/etc/nginx","/var/wwwroot","/var/wwwlogs"]
##conf目录： /etc/nginx
##进入命令目录 （不然会出现nginx: [emerg] open() "/var/run/nginx/nginx.pid" failed）
WORKDIR /run/nginx
#开放端口
EXPOSE 80 443
CMD ["nginx","-g","daemon off;"]
