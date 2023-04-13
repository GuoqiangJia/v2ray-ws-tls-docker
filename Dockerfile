FROM ubuntu:22.04

RUN sudo snap install core; sudo snap refresh core
RUN sudo apt-get remove certbot
RUN sudo ln -s /snap/bin/certbot /usr/bin/certbot
RUN sudo certbot certonly --standalone --non-interactive --agree-tos -m ${email} -d {domain}

RUN sudo apt update
RUN sudo apt install nginx -y
RUN sudo apt install v2ray -y
RUN sudo apt install cron -y

COPY ./config/nginx.tls.conf /etc/nginx/conf.d/
COPY ./config/config.json /etc/v2ray/
COPY ./config/certjob /etc/cron.d/certjob

RUN sed -i "s/\${your_domain}/$your_domain/g" /etc/nginx/conf.d/nginx.tls.conf && \
    sed -i "s/\${tls_port}/$tls_port/g" /etc/nginx/conf.d/nginx.tls.conf && \
    sed -i "s/\${fake_host}/$fake_host/g" /etc/nginx/conf.d/nginx.tls.conf

RUN sed -i "s/\${fake_host}/$fake_host/g" /etc/v2ray/config.json && \
    sed -i "s/\${uuid}/$uuid/g" /etc/v2ray/config.json

RUN chmod 0644 /etc/cron.d/certjob
RUN crontab /etc/cron.d/certjob

CMD sudo systemctl start v2ray && \
    sudo systemctl start nginx && \
    sudo cron
