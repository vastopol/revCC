#!/usr/bin/python3

import sys
import re
import itertools

#========================================

# generic C main prototype
main_top = '''
void main(int argc, char** argv)
{
'''

# Mini Java compiler entry point wrapper around main
enter_main='''
void enter()
{
    main();
    exit();
}
'''

#========================================

def main(file):
    tab = "    " # 4 spaces
    in_file = open(file,"r")
    out_file = open(file+".c","w")
    print("Decompiling: "+file)

    # strip empty space and comments
    code = []
    for line in in_file:
        tmp = line.split("#")[0].strip()
        if tmp != "":
            code.append(tmp)
    # print(code)

    # index counters and regex
    tidx = -1   # .text
    didx = -1   # .data
    gidx = -1   # .globl/.global
    gtmp = 0
    greg1 = re.compile('.globl*')
    greg2 = re.compile('.global*')

    for s in code:
        if re.match(greg1,s) or re.match(greg2,s):
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

    # print("data\n")
    # [ print(x) for x in data ]
    # print("text\n")
    # [ print(x) for x in text ]
    # print()

    #----------------------------------------

    # DATA PROCESSING

    for w in data:
        x = w.split(" ")
        # print(x)
        y = []
        for a in x: # remove the empty spaces
            if a != '':
                y.append(a)
        # print(y)
        if y[0][-1] == ":" and len(y) > 1: # have to check if only label on line
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

    #----------------------------------------

    # CODE PROCESSING
    # makes some assumptions aboput the format

    syscall_flag = -1
    funcall_args = []
    fun_bounds = False

    counter = 0 # updated on continues/loop ends
    end_data = []

    if text[0] == "jal main" and text[1] == "li $v0, 10" and text[2] == "syscall":
        out_file.write(enter_main)
        asm = text[3:]
    else:
        asm = text

    # main function header
    out_file.write(main_top)

    for t in asm:

        # possible .data in the code section as a locals
        if t == ".data":
            end_data = asm[counter:]
            # print("END", counter, end_data)
            break

        # regex match and ignore global references tags
        if re.match(greg1,t) or re.match(greg2,t):
            counter += 1
            continue

        # split and collect out parts
        chip = t.split()
        # print(chip)
        chap = []
        [ chap.append(x.split(",")) for x in chip ]
        # print(chap)
        chup = []
        for a in chap:
            # print(a)
            for b in a:
                if b != '':
                    # print(b)
                    chup.append(b)
        # print(chup)

        # labels in the code section
        chop = []
        if chup[0][-1] == ":":
            if fun_bounds == True:
                out_file.write( "function " + chup[0][:-1] + "\n" + "{" + "\n")
                fun_bounds = False
            elif chup[0][:-1] == "main":
                # print("AAA")
                pass
            else:
                out_file.write(chup[0] + "\n")

            if len(chup) == 1: # label on line by itself
                # print("BBB")
                counter += 1
                continue
            else:
                # print("CCC")
                chop = chup[1:]
        else:
            chop = chup
        # print(chop)

        # syscall
        if chop[0] == "syscall":
            out_file.write(tab)
            if   syscall_flag == "1":
                out_file.write("print_int(a0);\n")
            elif syscall_flag == "2":
                out_file.write("print_float(f12);\n")
            elif syscall_flag == "3":
                out_file.write("print_double(f12);\n")
            elif syscall_flag == "4":
                out_file.write("print_string(a0);\n")
            elif syscall_flag == "5":
                out_file.write("v0 = read_int();\n")
            elif syscall_flag == "6":
                out_file.write("f0 = read_float();\n")
            elif syscall_flag == "7":
                out_file.write("f0 = read_double();\n")
            elif syscall_flag == "8": # fgets
                out_file.write("read_string(a0,a1);\n")
            elif syscall_flag == "9": # heapAlloc
                out_file.write("v0 = sbrk(a0);\n")
            elif syscall_flag == "10": # exit  - end of function
                out_file.write("exit();\n")
                out_file.write("}\n\n")
                fun_bounds = True
            elif syscall_flag == "11":
                out_file.write("print_char(a0);\n")
            elif syscall_flag == "12":
                out_file.write("v0 = read_char();\n")
            elif syscall_flag == "13":
                out_file.write("open();\n")
            elif syscall_flag == "14":
                out_file.write("read();\n")
            elif syscall_flag == "15":
                out_file.write("write();\n")
            elif syscall_flag == "16":
                out_file.write("close();\n")
            elif syscall_flag == "17": # exit2  - end of function
                out_file.write("exit2(a0);\n")
                out_file.write("}\n\n")
                fun_bounds = True
            else:
                out_file.write("syscall(); // unknown ?\n")
            syscall_flag = -1
            counter += 1
            continue

        # return  - end of function
        if chop[0] == "jr" and chop[1] == "$ra":
            out_file.write("}\n\n")
            fun_bounds = True
            counter += 1
            continue

        # setup for syscall/return
        if chop[1] == "$v0":
            if chop[0] == "li":
                syscall_flag = chop[2]
                counter += 1
                continue
            if chop[0] == "move":
                out_file.write(tab + "// return " + "value?" + ";\n")

        # loads : immediate, address, byte, word
        if chop[0] == "li" or chop[0] == "la" or chop[0] == "lb" or chop[0] == "lw":
            out_file.write(tab + chop[1][1:] + " = " + chop[2] + ";" + "\n")
            counter += 1
            continue

        # add
        if   chop[0] == "add" or chop[0] == "addu":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " + " + chop[3][1:] + ";" + "\n")
            continue
        elif chop[0] == "addi" or chop[0] == "addiu":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " + " + chop[3] + ";" + "\n")
            continue

        # subtract
        if   chop[0] == "sub" or chop[0] == "subu":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " - " + chop[3][1:] + ";" + "\n")
            continue

        # multiply (pseduo op)
        if   chop[0] == "mul": # without overflow
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " * " + chop[3][1:] + ";" + "\n")
            continue

        # mult, div, divu
        # require using hi/lo special registers

        # and
        if   chop[0] == "and":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " & " + chop[3][1:] + ";" + "\n")
            continue
        elif chop[0] == "andi":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " & " + chop[3] + ";" + "\n")
            continue

        # or
        if   chop[0] == "or":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " | " + chop[3][1:] + ";" + "\n")
            continue
        elif chop[0] == "ori":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " | " + chop[3] + ";" + "\n")
            continue

        # shifts
        if   chop[0] == "srl":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " >> " + chop[3] + ";" + "\n")
            continue
        elif chop[0] == "sll":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " << " + chop[3] + ";" + "\n")
            continue

        out_file.write(tab + t + "\n")
        counter += 1
    # end for loop

    #----------------------------------------

    # DATA PROCESSING
    # see if the was some other local data ain the file

    if end_data:
        for w in end_data:
            x = w.split(" ")
            # print(x)
            y = []
            for a in x: # remove the empty spaces
                if a != '':
                    y.append(a)
            # print(y)
            if y[0][-1] == ":" and len(y) > 1: # have to check if only label on line
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

#========================================

# command line handler
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./rev.py <file>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
