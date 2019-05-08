#!/bin/bash

rm mips/*.c

for F in mips/*
do
    ./rev.py $F
    echo
done

rm mips/*.c
