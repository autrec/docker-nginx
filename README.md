# Docker

## 启动nginx

将nginx.conf 放到conf目录下

docker run -itd --name=nginx -p 80:80 -p 443:443 --restart=always -v "$(pwd)/wwwroot":/var/wwwroot -v "$(pwd)/wwwlogs":/var/wwwlogs -v "$(pwd)/conf":/etc/nginx autres/nginx

## 单系统架构

docker build -t autres/nginx .

## 多系统构架

docker buildx build -t autres/nginx --platform=linux/amd64,linux/arm64,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 . --push