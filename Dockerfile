# Dockerfile للواجهة الأمامية (Frontend)

# مرحلة البناء
FROM node:20-alpine as build

# إنشاء دليل العمل
WORKDIR /app

# نسخ ملفات package.json و package-lock.json
COPY package*.json ./

# تثبيت التبعيات
RUN npm install

# نسخ باقي ملفات المشروع
COPY . .

# بناء التطبيق
RUN npm run build

# مرحلة الإنتاج
FROM nginx:alpine

# نسخ ملفات البناء من المرحلة السابقة إلى مجلد Nginx
COPY --from=build /app/build /usr/share/nginx/html

# نسخ ملف تكوين Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# تعريض المنفذ 80
EXPOSE 80

# أمر بدء التشغيل
CMD ["nginx", "-g", "daemon off;"]
