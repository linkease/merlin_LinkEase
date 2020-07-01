#! /bin/sh

linkease_status=`ps | grep -w link-ease | grep -cv grep`
linkease_pid=`ps | grep -w link-ease | grep -v grep | awk '{print $1}'`
#TODO echo version
#linkease_info=`/koolshare/bin/link-ease -vv`
linkease_ver=0.2.80
if [ "$linkease_status" == "1" ];then
    echo 进程运行正常！版本：${linkease_ver} （PID：$linkease_pid） > /tmp/.linkease.log
else
    echo \<em\>【警告】：进程未运行！\<\/em\> 版本：${linkease_ver} > /tmp/.linkease.log
fi
echo XU6J03M6 >> /tmp/.linkease.log
sleep 3
rm -f /tmp/.linkease.log
