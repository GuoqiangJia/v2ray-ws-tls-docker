#!/bin/bash

# 检查脚本参数是否为空
if [ -z "$1" ]; then
  echo "请传入新的端口号作为参数"
  exit 1
fi

# 用 sed 命令替换 v2ray.conf 文件中的端口号
sed -i "s/listen [0-9]\+/listen $1/" /etc/nginx/conf.d/v2ray.conf

# 检查 sed 命令是否成功执行
if [ $? -eq 0 ]; then
  echo "端口号已更新为 $1"
else
  echo "端口号更新失败"
  exit 1
fi

# 重新加载 nginx 配置文件
nginx -s reload

# 检查 nginx 是否重新加载成功
if [ $? -eq 0 ]; then
  echo "nginx 配置文件已重新加载"
else
  echo "nginx 配置文件重新加载失败"
  exit 1
fi
