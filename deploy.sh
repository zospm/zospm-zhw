#!/bin/sh
. zospmsetenv 

zospmdeploy "$1" zospm-zhwbin.bom
exit $? 
