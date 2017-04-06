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
reqstat=":80/us"

function getData()
{
	while read line;do
	{
		cluster=`echo $line |cut -f1 -d','`
		server=`echo $line |cut -f2 -d','`
		curl -s --connect-timeout 1 -m 1 "http://$server$reqstat" |awk -F ',' -v cluster=$cluster '{
			if($1==""){
				server="UNDEFINED"
			}else{
				server=$1
			}
			print "nginx_status,cluster="cluster",host="server",server="$2" bytes_in="$3",bytes_out="$4\
				",conn_total="$5",req_total="$6",http_2xx="$7",http_3xx="$8",http_4xx="$9\
				",http_5xx="$10",http_other_status="$11",rt="$12",ups_req="$13",ups_rt="$14\
				",ups_tries="$15",http_200="$16",http_206="$17",http_302="$18",http_304="$19\
				",http_403="$20",http_404="$21",http_416="$22",http_499="$23",http_500="$24\
				",http_502="$25",http_503="$26",http_504="$27",http_508="$28\
				",http_other_detail_status="$29",http_ups_4xx="$30",http_ups_5xx="$31\
		}'
	} done <$nginxlist
	wait
}
getData
