# ss-bash
  ss-bash auto install and manage .Only applies to CentOS 7 and Shadowsocks-libev
  
  ss-bash 自动安装和管理，仅适用于 CentOS 7 和 Shadowsocks-libev
  
  --用最简练的语言写脚本
  
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/atxiu/ss-bash/master/install.sh)"
sh -c "$(wget https://raw.githubusercontent.com/atxiu/ss-bash/master/ss-bash.sh)"
chmod u+x ss-bash.sh
./ss-bash.sh
ss-bash.sh {start|stop|restart|status}
./ss-bash.sh start test 30
./ss-bash.sh start 123
```
./ss-bash.sh start [name] [time day]

![Snipaste_2018-01-01_09-33-50](Snipaste_2018-01-01_09-33-50.png)
