#!/bin/sh
set -e
echo "---------开始获取企业包签名名称-----------"
# 获取输入的企业包plist文件:例如 https://h5.baihuabao.cn/99fenqi/loan/qianyiyou/pinfo.plist
# plist_url=https://h5.baihuabao.cn/99fenqi/loan/qianyiyou/pinfo.plist
read -p "Enter your plist地址: " plist_url



if [ -z $plist_url ];then
  	echo "请在命令后面携带上plist文件地址"  
else 
	echo "---------开始下载plist文件-----------"	
	wget $plist_url
  
fi
# / 分割字符串

OLD_IFS="$IFS"
IFS="/"
path_arr=($plist_url)
IFS="$OLD_IFS"

last=`expr ${#path_arr[*]} - 1`
# 文件名
plist_name=${path_arr[last]}

plist_path="./${plist_name}"
# plist文件存在
if [ -e $plist_path ]; then
	#读取ipa地址 下载
	ipa=$(grep  '.ipa' $plist_path)
	echo  $ipa
	ipa=$(echo $ipa | sed 's/<string>//g')
	ipa=$(echo $ipa | sed 's/<\/string>//g')
	
	# 下载
	echo "---------开始下载${ipa}文件-----------"
	wget $ipa

else
	echo "plist文件中查找ipa失败"
fi


# 找到ipa文件
# / 分割字符串

OLD_IFS="$IFS"
IFS="/"
ipa_path_arr=($ipa)
IFS="$OLD_IFS"

last=`expr ${#ipa_path_arr[*]} - 1`
# 文件名
ipa_name=${ipa_path_arr[last]}

ipa_path="./${ipa_name}"


# 解压ipa包
# 解压临时文件夹
tmp_path=.ipa_tmp
unzip -oq $ipa_path -d $tmp_path

# 读取ipa包下文件内容 
# ./${tmp_path}/Payload/xxx.app/xxx.mobileprovision
app_name=$(ls ./${tmp_path}/Payload)
# echo $app_name
mobileprovision_file=./${tmp_path}/Payload/$app_name/*.mobileprovision

echo $mobileprovision_file

team_name_pre_line=$(cat $mobileprovision_file | grep -an TeamName)
# echo $team_name_pre_line
# :分隔 找到行号
OLD_IFS="$IFS"
IFS=":"
lines=($team_name_pre_line)
IFS="$OLD_IFS"

tema_name_line=`expr ${lines[0]} + 1`

# echo $tema_name_line
team_origin_string=$(sed -n "${tema_name_line},${tema_name_line}p" $mobileprovision_file)

# echo $team_origin_string
# 输出 team
team_name=$(echo $team_origin_string | sed 's/<string>//g')
team_name=$(echo $team_name | sed 's/<\/string>//g')

echo "---------企业开发Team Name-----------"
echo $team_name
# echo $team_name | pbcopy
# 删除 下载的文件
rm $plist_path # 删除plist文件
rm $ipa_path   # 删除ipa包文件
rm -rf $tmp_path     # 删除临时文件





