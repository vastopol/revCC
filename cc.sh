#!/bin/bash

F1=$(ls mips/*.asm)
F2=$(ls mips/minijava/*)
F3="$F1$F2"
LL="----------------------------------------"

for F in $F3
do
    echo
    ./decomp.py $F
    echo; echo $LL; echo
    cat $F.c
    echo $LL
done

rm mips/*.c
rm mips/minijava/*.c
