#!/bin/bash
# http_reqstat_module ：http://tengine.taobao.org/document_cn/http_reqstat_cn.html
# format error ：http://stackoverflow.com/questions/42708348/telegraf-exec-plugin-aws-ec2-ebs-volumen-info-metric-parsing-error-reason/42709771#42709771

cluster="Tengine-1"
server="10.71.19.153"
health=":80/status?format=csv"
curl -s --connect-timeout 1 -m 1 "http://$server$health" |awk -F ',' -v cluster=$cluster -v server=$server '{
	print "nginx_health,cluster="cluster",host="server",index="$1" upstream=""\""$2"\""",name=""\""$3"\""",status=""\""$4"\""",rise_counts="$5",fall_counts="$6",check_type=""\""$7"\""",check_port=""\""$8"\""\
}'