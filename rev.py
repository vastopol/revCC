#!/usr/bin/python3

import sys
import re

# makes spme assumptions aboput the format

# m_top = '''
# int main(int argc, char** argv)
# {
# '''

# m_bot = '''
#     return 0;
# }
# '''

#----------------------------------------

def main(file):
    in_file = open(file,"r")
    out_file = open(file+".c","w")
    print("Compiling: "+file)

    # strip empty space and comments
    code = []
    for line in in_file:
        tmp = line.split("#")[0].strip()
        if tmp != "":
            code.append(tmp)

    # print(code)

    # index counters
    tidx = -1
    didx = -1
    gidx = -1

    gtmp = 0
    greg = re.compile('.globl*')
    for s in code:
        if re.match(greg,s):
            gidx = gtmp
            break
        gtmp += 1

    if ".text" in code:
        tidx = code.index(".text")
    #     print("text  : ",tidx)
    # if gidx >= 0:
    #     print("globl : ",gidx)
    if ".data" in code:
        didx = code.index(".data")
        # print("data  : ",didx)

    # split data and text sections
    data = []
    text = []
    if didx > tidx:
        text = code[:didx]
        data = code[didx:]
    else:
        data = code[:tidx]
        text = code[tidx:]

    # print()
    # [ print(x) for x in data ]
    # print()
    # [ print(x) for x in text ]

    for c in code:
        out_file.write(c+"\n")

#----------------------------------------

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./rev.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)

