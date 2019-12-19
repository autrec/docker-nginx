# Docker

## 可以直接启动nginx
resul=`docker run -itd \
    --name=$APP_NAME \
    -p 80:80 \
    -p 443:443 \
    --restart=always \
    -v "$(pwd)/wwwroot":/var/wwwroot \
    -v "$(pwd)/wwwlogs":/var/wwwlogs \
    -v "$(pwd)/conf":/etc/nginx \
    autres/nginx`
