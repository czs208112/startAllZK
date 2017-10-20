#!/bin/bash

#############################

#根据自己集群情况要修改的变量
NODENAME_ARR=('node1' 'node2' 'node3')
EXEC_USER='hadoop'

#############################

LEADER_NODE=''

if [ $USER != ${EXEC_USER} ]; then
  echo "当前用户$USER不是执行用户${EXEC_USER}"
  exit 1
fi
echo '' >zk.log

checkLeader(){
  countZK=0
  for nodename in ${NODENAME_ARR[@]}
  do
    CHECK_LEADER_OUT=`ssh $nodename ". /etc/profile;zkServer.sh status"`
    if [[ $CHECK_LEADER_OUT =~ 'follower' ]]; then
      countZK=$[countZK+1]
    fi

    if [[  $CHECK_LEADER_OUT =~ 'leader' ]]; then
      LEADER_NODE=$nodename
      countZK=$[countZK+1]
    fi
  done

  echo -e "\n成功启动了${countZK}个节点" 
  echo "leader节点是: ${LEADER_NODE}"
}

if [ $# -eq 0 ]; then
  echo -e "请带参数执行脚本.如：\n    sh startAllZK.sh start \n    sh startAllZK.sh stop\n"
  exit 1
fi

if [ $1 == 'start' ] ;then
  for nodename in ${NODENAME_ARR[@]}
  do
    echo -n "${nodename}正在启动..."
    echo ${nodename} >> zk.log
    ssh $nodename ". /etc/profile;zkServer.sh start" >>zk.log 2>&1 
   # ssh $nodename 'zkServer.sh start' >>zk.log 2>&1
    if [ $? == 0 ];then
      echo "  ${nodename}启动成功"
    else 
      echo "  ${nodename}启动"
    fi
  done
  checkLeader
elif [ $1 == 'stop' ] ;then
  for nodename in ${NODENAME_ARR[@]} 
  do
    echo -n "${nodename}正在关闭..."
    echo ${nodename} >> zk.log
    ssh $nodename ". /etc/profile;zkServer.sh stop" >>zk.log 2>&1
    if [ $? == 0 ];then
      echo "  ${nodename}关闭成功"
    else  
      echo "  ${nodename}关闭失败"
    fi
  done
fi
