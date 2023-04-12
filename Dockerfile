FROM ubuntu:22.04 as base

RUN sudo snap install core; sudo snap refresh core
RUN sudo apt-get remove certbot
RUN sudo ln -s /snap/bin/certbot /usr/bin/certbot
RUN sudo certbot certonly --standalone --email ${email} -d {domain}

RUN sudo apt update
RUN sudo apt install nginx -y
RUN sudo apt install v2ray -y

CMD sudo systemctl start nginx && \
    sudo systemctl start v2ray
