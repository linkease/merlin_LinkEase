#!/bin/sh
eval `dbus export linkease`
source /koolshare/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

BIN=/koolshare/bin/link-ease
PID_FILE=/var/run/linkease.pid

if [ "$(cat /proc/sys/vm/overcommit_memory)"x != "0"x ];then
    echo 0 > /proc/sys/vm/overcommit_memory
fi

fun_ntp_sync(){
    ntp_server=`nvram get ntp_server0`
    start_time="`date +%Y%m%d`"
    ntpclient -h ${ntp_server} -i3 -l -s > /dev/null 2>&1
    if [ "${start_time}"x = "`date +%Y%m%d`"x ]; then  
        ntpclient -h ntp1.aliyun.com -i3 -l -s > /dev/null 2>&1 
    fi
}
fun_linkease_start_stop(){
    if [ "${linkease_enable}"x = "1"x ];then
        killall link-ease
        start-stop-daemon -S -q -b -m -p ${PID_FILE} -x ${BIN}
    else
        killall link-ease
    fi
}

fun_linkease_iptables(){
    linkease_iptables_num=$(iptables -nL INPUT | grep -ci "INPUT_LinkEase")
    if [ "${linkease_enable}"x = "1"x ];then
        if [ "${linkease_iptables_num}"x = "0"x ];then
            iptables -I INPUT -j INPUT_LinkEase
        fi
        INPUT_LinkEase_num=$(iptables -nL INPUT_LinkEase | grep -ic "tcp dpt:8897")
        if [ "${INPUT_LinkEase_num}"x = "0"x ];then
            iptables -N INPUT_LinkEase
            iptables -t filter -I INPUT_LinkEase -p tcp --dport 8897 -j ACCEPT
        fi
    else
        while [[ "${linkease_iptables_num}" != 0 ]]  
        do
            iptables -D INPUT -j INPUT_LinkEase
            linkease_iptables_num=$(expr ${linkease_iptables_num} - 1)
        done
    fi
}

fun_linkease_nat_start(){
    if [ "${linkease_enable}"x = "1"x ];then
        echo_date 添加nat-start触发事件...
        dbus set __event__onnatstart_linkease="/koolshare/scripts/linkease_config.sh"
    else
        echo_date 删除nat-start触发...
        dbus remove __event__onnatstart_linkease
    fi
}

case ${ACTION} in
start)
    fun_ntp_sync
    fun_linkease_start_stop
    fun_linkease_iptables
    fun_linkease_nat_start
    ;;
*)
    fun_ntp_sync
    fun_linkease_start_stop
    fun_linkease_iptables
    fun_linkease_nat_start
    ;;
esac
