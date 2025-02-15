# 使用官方 Node.js 运行时作为父镜像
FROM node:18-alpine AS build-stage

# 设置工作目录
WORKDIR /app

# 将应用的源代码复制到容器中
COPY . .

# 安装 Yarn
RUN npm install -g yarn --force && yarn install --force && yarn build

# 使用Nginx作为基础镜像
FROM nginx:alpine as builder

# 删除默认的 Nginx 网站
RUN rm -rf /usr/share/nginx/html/*

# 将本地Nginx配置文件复制到容器中
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 将Vue.js应用的构建产物复制到Nginx的默认目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 暴露Nginx端口
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"]