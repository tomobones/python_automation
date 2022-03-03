#!/usr/bin/bash

ip=$1
sum=0
for i in 1 2 3 4; do
    sum=$(( $sum * 256 + $(echo $ip | cut -d '.' -f $i) ))
done
echo $sum
