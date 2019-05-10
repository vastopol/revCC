#!/usr/bin/python3

import sys
import re
import itertools

#----------------------------------------

# makes spme assumptions aboput the format
# generic C main prototype
m_top = '''
int main(int argc, char** argv)
{
'''

m_bot = '''
    return 0;
}
'''

#----------------------------------------

def main(file):
    tab="    " # 4 spaces
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

    # rm pseduo-op maekers
    data = data[1:]
    text = text[1:]

    # print()
    # [ print(x) for x in data ]
    # print()
    # [ print(x) for x in text ]
    # print()

    # data processing
    for w in data:
        x = w.split(" ")
        # print(x)
        y = []
        for a in x: # remove the empty spaces
            if a != '':
                y.append(a)
        # print(y)
        if y[0][-1] == ":":
            name = y[0][:-1]
            val = ''.join( str(e)+" " for e in list( itertools.chain( y[2:] ) ) )
            if   y[1] == ".asciiz":
                out_file.write("char* " + name + " = " + val + ";\n")
            elif y[1] == ".word":
                out_file.write("int " + name + " = " + val + ";\n")
            elif y[1] == ".float":
                out_file.write("float " + name + " = " + val + ";\n")
            elif y[1] == ".double":
                out_file.write("double " + name + " = " + val + ";\n")

    syscall_flag = -1

    # code processing
    out_file.write(m_top)
    for t in text:
        chop = t.split()
        if t == "syscall":
            if   syscall_flag == 0:  # print int
                out_file.write("print_int()\n")
            elif syscall_flag == 4 # print string
                out_file.write("print_string()\n")
            elif syscall_flag == 10: # exit
                out_file.write("exit(0)\n")
            syscall_flag = -1
            continue
        if chop[0] == "li" and chop[1][1:-1] == "v0":
            syscall_flag = chop[2]
            continue
        if chop[0] == "li":
            out_file.write(tab + chop[1][1:-1] + " = " + chop[2] + ";" + "\n")
            continue

        out_file.write(tab + t + "\n")
    out_file.write(m_bot)

#----------------------------------------

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./rev.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)

