#!/bin/bash
start()
{
    v=$[63210+$(ls /etc/shadowsocks-libev/ -l |grep "^-"|wc -l)]
    pw=$(cat /dev/urandom | head -1 | md5sum | head -c 10)
    server=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
    echo $server
(
cat <<EOF
{
"server":"$server",
"server_port":$v,
"password":"$pw",
"timeout":300,
"method":"chacha20-ietf-poly1305"
}
EOF
)>/etc/shadowsocks-libev/$1.json
    systemctl start shadowsocks-libev-server@$1.service
    systemctl enable shadowsocks-libev-server@$1.service
    cat /etc/shadowsocks-libev/$1.json
    ss=ss://$(python _base64.py -en chacha20-ietf-poly1305:$pw@ss.atxiu.cn:$v)
    echo $ss
}
stop()
{
    systemctl stop shadowsocks-libev-server@$1.service
    systemctl disable shadowsocks-libev-server@$1.service
    rm -rf /etc/shadowsocks-libev/$1.json
}
restart()
{
    systemctl restart shadowsocks-libev-server@$1.service
}
status()
{
    systemctl status shadowsocks-libev-server@$1.service
}
case "$1" in
    start)
      start $2
      ;;
    stop)
      stop $2
      ;;
    restart)
      restart $2
      ;;
    status)
      status $2
      ;;
    *)
      echo $"$0 {start|stop|restart|status}"
esac
