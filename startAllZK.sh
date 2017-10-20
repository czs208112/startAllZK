#!/bin/bash

NODENAME_ARR=('node1' 'node2' 'node3')

echo '' >zk.log

if [ $# -eq 0 ]; then
  echo -e "请带参数执行脚本.如：\n    sh startAllZK.sh start \n    sh startAllZK.sh stop\n"
  exit 1
fi

if [ $1 == 'start' ] ;then
  for nodename in ${NODENAME_ARR[@]}
  do
	echo -n "${nodename}正在启动..."
    echo ${nodename} >> zk.log
    ssh $nodename 'export BASH_ENV=/etc/profile;/opt/zookeeper/bin/zkServer.sh start' >>zk.log 2>&1    if [ $? == 0 ];then
      echo "  ${nodename}启动成功"
    else
      echo "  ${nodename}启动"
    fi
 #   sleep 2s
  done
elif [ $1 == 'stop' ] ;then
  for nodename in ${NODENAME_ARR[@]}
  do
    echo -n "${nodename}正在关闭..."
    echo ${nodename} >> zk.log
    ssh $nodename '/opt/zookeeper/bin/zkServer.sh stop' >>zk.log 2>&1
    if [ $? == 0 ];then
      echo "  ${nodename}关闭成功"
    else
      echo "  ${nodename}关闭失败"
    fi
  done
fi