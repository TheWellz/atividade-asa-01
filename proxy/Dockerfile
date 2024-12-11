FROM nginx:latest

COPY default.conf /etc/nginx/conf.d/
COPY 404.html /usr/share/nginx/html/

RUN mkdir -p /usr/share/nginx/wellton
COPY index.html /usr/share/nginx/wellton
