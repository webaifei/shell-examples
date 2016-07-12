#! /bin/bash

#如何在shell中定义一个常量

PI=3.1415926

readonly $PI

#尝试修改变量PI
PI=20000
#使用$来引用变量
echo ${PI}
