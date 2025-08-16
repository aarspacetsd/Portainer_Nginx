FROM nginx:1.25-alpine

# Hapus file index.html default dari Nginx.
RUN rm /usr/share/nginx/html/index.html

# Salin semua file dari direktori Anda (termasuk index.html, css, js, gambar)
# ke dalam direktori web root di dalam kontainer.
COPY . /usr/share/nginx/html