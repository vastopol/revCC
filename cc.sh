#!/bin/bash

for F in mips/*.S
do

    echo
    ./rev.py $F
    echo
    echo "----------------------------------------"

    echo
    cat $F.c
    echo "----------------------------------------"

done

rm mips/*.c
