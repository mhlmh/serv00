#!/bin/sh

# 设置捕获 SIGINT 信号（Ctrl+C）
trap 'printf "\n\033[31m脚本运行被动中止。若要重新测试，请再次执行此脚本。\033[0m\n"; exit 0' SIGINT

# 打印分隔线
printf "\n==============================\n"
printf "      \033[1;32mServ00 主机信息\033[0m\n"  # 绿
printf "==============================\n"

# 获取系统版本信息
printf "\n\033[1;34m[系统版本]\033[0m\n"  # 蓝
uname -a

# 获取CPU信息
printf "\n\033[1;34m[CPU 信息]\033[0m\n"  # 蓝
sysctl -n hw.model
printf "CPU 核心数：\033[1;33m%d\033[0m\n" $(sysctl -n hw.ncpu)  # 黄

# 获取内存信息
printf "\n\033[1;34m[内存信息]\033[0m\n"  # 蓝
printf "物理内存：\033[1;33m%.2f MB\033[0m\n" $(sysctl hw.physmem | awk '{print $2/1024/1024}')
printf "可用内存：\033[1;33m%.2f MB\033[0m\n" $(sysctl hw.usermem | awk '{print $2/1024/1024}')

# 获取磁盘使用情况
printf "\n\033[1;34m[磁盘使用情况]\033[0m\n"  # 蓝
df -h

# 获取网络接口信息
printf "\n\033[1;34m[网络接口信息]\033[0m\n"  # 蓝
ifconfig | grep -E "^[a-z]" | awk '{print $1}' | while read iface; do
    printf "接口: \033[1;35m%s\033[0m\n" $iface  # 紫
    ifconfig "$iface" | grep 'inet '
done
printf "\033[31m注意：Serv00 登录用户非 root 用户，此项可能提示权限不足。\033[0m\n"  # 红

# 检查系统负载
printf "\n\033[1;34m[系统负载]\033[0m\n"  # 蓝
uptime

# 显示当前登录用户
printf "\n\033[1;34m[当前登录用户]\033[0m\n"  # 蓝
whoami

# 简单测速功能（Ping 测试）
printf "\n\033[1;34m[PING 测试]\033[0m\n"  # 蓝
test_speed() {
    printf "\n测试节点：\033[1;36m%s\033[0m\n" "$2"  # 青
    ping -c 4 $1 | grep 'round-trip' | awk -F '/' '{print "    最小延迟: \033[1;33m" $4 " ms\033[0m\n    平均延迟: \033[1;33m" $5 " ms\033[0m\n    最大延迟: \033[1;33m" $6 " ms\033[0m"}'  # 黄
}

# 测试多个节点
test_speed 'www.speedtest.net' 'Speedtest.net 默认节点'
test_speed '184.105.186.233' 'Los Angeles, US'
test_speed '211.136.25.153' 'Beijing, CN'
test_speed '58.247.214.238' 'Shanghai, CN'
test_speed '113.108.209.1' 'Guangzhou, CN'
test_speed '45.113.68.1' 'Hong Kong, CN'
test_speed '202.166.120.231' 'Singapore, SG'
test_speed '103.244.121.10' 'Tokyo, JP'

# 打印结束标志
printf "\n==============================\n"
printf "         \033[1;32mserv00_bench\033[0m\n"  # 绿
printf "==============================\n"
printf "\033[31m测试完成！\033[0m\n"  # 红