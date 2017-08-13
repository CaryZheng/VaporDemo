#!/bin/sh

echo "\033[31mgit pull origin master start\033[0m"
git pull origin master
echo "\033[31mgit pull origin master success\033[0m"

echo "\033[31mvapor update start\033[0m"
vapor update
echo "\033[31mvapor update finish\033[0m"

echo "\033[31mvapor build start\033[0m"
vapor build
echo "\033[31mvapor build finish\033[0m"

echo "\033[31mvapor build --release start\033[0m"
vapor build --release
echo "\033[31mvapor build --release success\033[0m"

echo "\033[31mvapor auto script finished\033[0m"
