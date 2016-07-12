#! /bin/bash

# shell 中的数据类型 基本上主要是数字和字符串
# 字符串的输出和操作

read name
echo "your name is $name"
echo "your name is "$name""
echo 'your name is $name'

#获取字符串的长度

echo ${#name}
