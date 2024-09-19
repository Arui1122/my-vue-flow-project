# 構建階段
FROM node:18-alpine AS build-stage

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# 設置環境變量為生產環境
ENV NODE_ENV=production

# 構建應用程序
RUN npm run build

# 生產階段
FROM nginx:stable-alpine AS production-stage

# 將構建的文件復制到 Nginx 的 html 文件夾
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 複製自訂的 Nginx 配置
COPY nginx.conf.template /etc/nginx/conf.d/default.conf

# 暴露端口（可選）
EXPOSE 8080
