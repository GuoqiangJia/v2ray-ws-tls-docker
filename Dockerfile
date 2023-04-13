FROM ubuntu:22.04

ARG YOUR_EMAIL
ARG YOUR_DOMAIN
ARG YOUR_TLS_PORT
ARG YOUR_FAKE_HOST
ARG YOUR_UUID

RUN sudo apt update

RUN sudo apt install snapd
RUN sudo snap install core
RUN sudo snap refresh core
RUN sudo apt-get remove certbot
RUN sudo ln -s /snap/bin/certbot /usr/bin/certbot
RUN sudo certbot certonly --standalone --non-interactive --agree-tos -m $YOUR_EMAIL -d $YOUR_DOMAIN

RUN sudo apt install nginx -y
RUN sudo apt install v2ray -y
RUN sudo apt install cron -y

COPY ./config/tls.conf /etc/nginx/conf.d/
COPY ./config/config.json /etc/v2ray/
COPY ./config/certjob /etc/cron.d/certjob

RUN sed -i "s/\${your_domain}/$YOUR_EMAIL/g" /etc/nginx/conf.d/tls.conf && \
    sed -i "s/\${tls_port}/$YOUR_TLS_PORT/g" /etc/nginx/conf.d/tls.conf && \
    sed -i "s/\${fake_host}/$YOUR_FAKE_HOST/g" /etc/nginx/conf.d/tls.conf

RUN sed -i "s/\${fake_host}/$YOUR_FAKE_HOST/g" /etc/v2ray/config.json && \
    sed -i "s/\${uuid}/$YOUR_UUID/g" /etc/v2ray/config.json

RUN chmod 0644 /etc/cron.d/certjob
RUN crontab /etc/cron.d/certjob

CMD sudo systemctl start v2ray && \
    sudo systemctl start nginx && \
    sudo cron