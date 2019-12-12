FROM alpine
#声明作者
LABEL maintainer="nginx docker Autre <mo@autre.cn>"
#升级内核及软件
RUN apk update
RUN apk upgrade
#设置时区
RUN apk add --no-cache tzdata
ENV TZ Asia/Shanghai
RUN mkdir -p /run/nginx/
RUN mkdir -p /var/wwwroot
RUN mkdir -p /var/wwwlogs
#安装nginx
RUN apk --update add nginx
#开放端口
EXPOSE 80 443
CMD ["nginx","-g","daemon off;"]
