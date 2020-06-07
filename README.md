# nginx

一个docker版的nginx镜像

## 拉取镜像
```
docker pull flxxyz/nginx:latest
```
### 支持流媒体(RTMP, HTTP-FLV, HLS)

```
docker pull flxxyz/nginx:nginx-http-flv-module
```

感谢 [winshining/nginx-http-flv-module](https://github.com/winshining/nginx-http-flv-module) 的

[使用其他版本Nginx](#其他版本Nginx)

## 编排例子
```
web:
    image: flxxyz/nginx:latest
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - 修改nginx.conf的路径:/etc/nginx/nginx.conf
      - 本地日志目录的路径:/var/log/nginx
      - 本地站点目录的路径:/usr/share/nginx/html
```

## 路径说明
前置路径 `/usr/share/nginx`

站点目录 `/usr/share/nginx/html`

配置目录 `/etc/nginx`

执行文件目录 `/usr/sbin/nginx`

日志目录 `/var/log/nginx`

模块目录 `/usr/lib/nginx/modules`

源码目录 `/usr/local/nginx-${NGINX_VERSION}`

## 其他版本Nginx
- [nginx-http-flv-module](https://hub.docker.com/repository/docker/flxxyz/nginx/tags?page=1&name=nginx-http-flv-module) ✔
- [1.19.0](https://github.com/edogDocker/nginx/blob/master/mainline/Dockerfile) ✔
- [1.18.0, latest](https://github.com/edogDocker/nginx/blob/master/stable/Dockerfile) ✔
- [1.17.10](https://github.com/edog-docker/nginx/blob/1.17.10/Dockerfile) ✔
- [1.16.1](https://github.com/edog-docker/nginx/blob/1.16.1/Dockerfile) ✔