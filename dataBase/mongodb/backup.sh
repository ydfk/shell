#!/bin/sh

DBNAME=$1 #备份数据库名称
DBUSER=$2
DBPASSWORD=$3
BACKPATH=$4 #备份路径
DATE=`date +%Y%m%d%H%M%S` # 备份时间

if test -z $DBNAME
then 
  DBNAME="li_meow"
  echo "未输入要备份的数据库名称，默认使用 ${DBNAME}"
fi 

if test -z $BACKPATH
then 
  BACKPATH="/root/backup"
  echo "未输入要备份的路径，默认使用 ${BACKPATH}"
fi 

if [ ! -d "$BACKPATH" ]
then
  echo "备份路径${BACKPATH}不存在, 自动创建"
  mkdir -p $BACKPATH
fi

cd $BACKPATH
sudo mongodump --gzip -h 127.0.0.1:27017 -u "${DBUSER}" -p "${DBPASSWORD}"  --authenticationDatabase "admin" -d $DBNAME -o $BACKPATH

if [ ! -d "${BACKPATH}/${DBNAME}" ]
then
  echo "备份${DBNAME}失败"
else
  tar -zcvf ${DBNAME}${DATE}.tar.gz ${DBNAME}
  rm -Rf $DBNAME
  echo "${DBNAME}${DATE}备份完成"
fi