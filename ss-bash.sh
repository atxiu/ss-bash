#!/bin/bash
start()
{
    port=$[63210+$(ls /etc/shadowsocks-libev/ -l |grep "^-"|wc -l)]
    pw=$(cat /dev/urandom | head -1 | md5sum | head -c 10)
    server=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
(
cat <<EOF
{
"server":"$server",
"server_port":$port,
"password":"$pw",
"timeout":300,
"method":"chacha20-ietf-poly1305"
}
EOF
)>/etc/shadowsocks-libev/$1.json
    systemctl start shadowsocks-libev-server@$1.service
    systemctl enable shadowsocks-libev-server@$1.service
    cat /etc/shadowsocks-libev/$1.json
    ss=ss://$(echo -n "chacha20-ietf-poly1305:$pw@$server:$port" | base64)
    echo $ss
    time=$(date -d "+$2 day" "+%M %H %d %m")
    if test -f /var/spool/cron/root; then
        echo "crontab initializationed"
    else 
(
cat <<EOF
0 0 0 0 0 echo "crontab initialization"
EOF
)>/var/spool/cron/root;
    fi
    if [ ! -n "$2" ];then
        echo "Unlimited"
    else
        sed -i "1i $time * /bin/bash ~/ss-bash.sh stop $1" /var/spool/cron/root
    fi
}
stop()
{
    systemctl stop shadowsocks-libev-server@$1.service
    systemctl disable shadowsocks-libev-server@$1.service
    rm -rf /etc/shadowsocks-libev/$1.json
    sed -i "/$1/d" /var/spool/cron/root
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
      start $2 $3
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
