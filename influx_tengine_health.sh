#!/bin/bash
# http_reqstat_module ：http://tengine.taobao.org/document_cn/http_reqstat_cn.html
# format error ：http://stackoverflow.com/questions/42708348/telegraf-exec-plugin-aws-ec2-ebs-volumen-info-metric-parsing-error-reason/42709771#42709771

confdir="conf"
extdir=$(cd `dirname $0`;pwd)
basedir="$extdir/$confdir"
[ ! -d $basedir ] && mkdir $basedir
if [ $# -eq 1 ];then
	nginxlist="$basedir/$1"
else
	nginxlist="$basedir/nginx.list"
fi
health=":80/status?format=csv"

function getData()
{
	while read line;do
	{
		cluster=`echo $line |cut -f1 -d','`
		server=`echo $line |cut -f2 -d','`
		curl -s --connect-timeout 1 -m 1 "http://$server$health" |awk -F ',' -v cluster=$cluster -v server=$server '{
			print "nginx_health,cluster="cluster",host="server",index="$1",upstream="$2",name="$3",status="$4",check_type="$7",check_port="$8" rise_counts="$5",fall_counts="$6\
		}'
	} done <$nginxlist
	wait
}
getData
