FROM alpine
#声明作者
LABEL maintainer="mo@autre.cn"
RUN apk update
RUN apk upgrade
#设置时区
RUN apk add --no-cache tzdata
ENV TZ Asia/Shanghai
#安装lnmp nginx
RUN wget http://soft.vpser.net/lnmp/lnmp1.6.tar.gz -cO lnmp1.6.tar.gz && tar zxf lnmp1.6.tar.gz && cd lnmp1.6 && ./install.sh nginx
#开放端口
EXPOSE 80
EXPOSE 443
