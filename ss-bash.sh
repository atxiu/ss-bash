#!/bin/bash
start()
{
    v=$[63210+$(ls /etc/shadowsocks-libev/ -l |grep "^-"|wc -l)]
(
cat <<EOF
{
"server":"180.188.196.76",
"server_port":$v,
"password":"test$1",
"timeout":300,
"method":"chacha20-ietf-poly1305"
}
EOF
)>/etc/shadowsocks-libev/$1.json
    systemctl start shadowsocks-libev-server@$1.service
    systemctl enable shadowsocks-libev-server@$1.service
    cat /etc/shadowsocks-libev/$1.json
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
