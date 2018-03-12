#!/bin/bash
yum install -y epel-release yum-plugin-copr wget net-tools
yum copr -y enable librehat/shadowsocks
yum install -y shadowsocks-libev

