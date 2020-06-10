#! /bin/sh

linkease_status=`ps | grep -w linkease | grep -cv grep`
linkease_pid=`ps | grep -w linkease | grep -v grep | awk '{print $1}'`
#TODO echo version
#linkease_info=`/koolshare/bin/linkease -vv`
linkease_ver=`echo ${linkease_info} | awk '{print $1}'`
linkease_rid=`echo ${linkease_info} | awk '{print $2}'`
if [ "$linkease_status" == "1" ];then
    echo 进程运行正常！版本：${linkease_ver} 路由器ID：${linkease_rid} （PID：$linkease_pid） > /tmp/.linkease.log
else
    echo \<em\>【警告】：进程未运行！\<\/em\> 版本：${linkease_ver} 路由器ID：${linkease_rid}  > /tmp/.linkease.log
fi
echo XU6J03M6 >> /tmp/.linkease.log
sleep 2
rm -rf /tmp/.linkease.log
