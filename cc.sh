#!/bin/bash

rm mips/*.c

for F in mips/*
do
    ./rev.py $F
    echo
    cat $F.c
    echo
done

rm mips/*.c
