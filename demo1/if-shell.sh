#! /bin/bash

#shell中如何对变量的值进行判断 从而返回其他的值

a=100
echo "${a:+Value of a is $a}"
