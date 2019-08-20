#!/usr/bin/python3

import sys

from rev.program import Program

#----------------------------------------

def main(file):
    ifile = open(file,"r")
    ofile = open(file+".c","w")
    print("Decompiling: "+file)
    p = Program(ifile,ofile)
    p.decompile()

#----------------------------------------

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./decomp.py <files>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
