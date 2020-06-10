#!/bin/sh
source /koolshare/scripts/base.sh
MODULE=linkease
cd /tmp
killall linkease
rm -f /koolshare/bin/linkease.log
rm -f /koolshare/bin/_ffprobe_cache /koolshare/scripts/_ffprobe_cache
cp -rf /tmp/linkease/bin/* /koolshare/bin/
cp -rf /tmp/linkease/scripts/* /koolshare/scripts/
cp -rf /tmp/linkease/webs/* /koolshare/webs/
cp -rf /tmp/linkease/res/* /koolshare/res/

chmod a+x /koolshare/bin/linkease
chmod a+x /koolshare/scripts/linkease_config.sh
chmod a+x /koolshare/scripts/linkease_status.sh
chmod a+x /koolshare/scripts/uninstall_linkease.sh
ln -sf /koolshare/scripts/linkease_config.sh /koolshare/init.d/S99linkease.sh
dbus set softcenter_module_linkease_name=${MODULE}
dbus set softcenter_module_linkease_title="易有云2.0"
dbus set softcenter_module_linkease_description="易有云2.0 相册备份，双向同步，历史版本。"
dbus set softcenter_module_linkease_version=`dbus get linkease_version`
rm -rf /tmp/linkease* >/dev/null 2>&1
ee_en=`dbus get linkease_enable`
if [ "${ee_en}"x = "1"x ];then
    /koolshare/scripts/linkease_config.sh
fi
logger "[软件中心]: 完成 LinkEase 安装"
exit
