FROM alpine
#声明作者
LABEL maintainer="mo@autre.cn"
RUN apk update
RUN apk upgrade
#设置时区
RUN apk add --no-cache tzdata
ENV TZ Asia/Shanghai
#安装nginx
RUN apk --update add nginx
#开放端口
EXPOSE 80
EXPOSE 443
CMD ["nginx","-g","daemon off;"]
