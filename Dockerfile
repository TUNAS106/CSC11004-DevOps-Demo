# --- GIAI ĐOẠN 1: BUILD ---
# Dùng Node.js để cài thư viện và build code
FROM node:lts-alpine as build-stage

# Tạo thư mục làm việc trong container
WORKDIR /app

# Copy file package.json trước để cài thư viện (tận dụng cache của Docker)
COPY package*.json ./

# Cài đặt các thư viện (node_modules)
RUN npm install

# Copy toàn bộ code từ máy ngoài vào container
COPY . .

# Lệnh quan trọng nhất: Build Vue ra file tĩnh (thường nằm trong thư mục /dist)
RUN npm run build

# --- GIAI ĐOẠN 2: PRODUCTION ---
# Dùng Nginx để chạy web (rất nhẹ và nhanh)
FROM nginx:stable-alpine as production-stage

# Copy kết quả vừa build ở giai đoạn 1 sang thư mục của Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Web chạy cổng 80 trong container
EXPOSE 80

# Chạy Nginx
CMD ["nginx", "-g", "daemon off;"]
