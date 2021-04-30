#!/bin/bash
#wget https://pkgstore.datahub.io/core/geoip2-ipv4/geoip2-ipv4_csv/data/5ecd20f7df0f626a2270b71d4c725630/geoip2-ipv4_csv.csv
filename='geoip2-ipv4_csv.csv'
n=1
while read line; do
# reading each line
#echo "${line%%/*}"
#IP=${line%%/*}
#echo  "$line"
#wget -q -O - whoismyisp.org/ip/185.238.92.254 | grep -oP -m1 '(?<=isp">).*(?=</p)'
#echo $IP
#test="`wget -q -O - whoismyisp.org/ip/$IP | grep -oP -m1 '(?<=isp">).*(?=</p)' `"
#echo $IP,$test
#IP= echo $line | awk -F/ '{print $1}'
IPaddress=`awk -F/ '{print $1}' <<< $line`
Field0=`awk -F, '{print $1}' <<< $line`
Field1=`awk -F, '{print $2}' <<< $line`
Field2=`awk -F, '{print $3}' <<< $line`
Field3=`awk -F, '{print $4}' <<< $line`
Field4=`awk -F, '{print $5}' <<< $line`
Field5=`awk -F, '{print $6}' <<< $line`
Field6=`awk -F, '{print $7}' <<< $line`
Field7=`awk -F, '{print $8}' <<< $line`
echo $line
ISP="`wget -q -O - whoismyisp.org/ip/$IPaddress | grep -oP -m1 '(?<=isp">).*(?=</p)' `"
echo $Field0,$Field1,$Field2,$Field3,$Field4,$Field5,$Field6,$ISP >> db.txt
echo $Field0,$Field1,$Field2,$Field3,$Field4,$Field5,$Field6,$ISP
#echo $Filed7
done < $filename
