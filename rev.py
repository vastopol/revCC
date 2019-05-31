#!/usr/bin/python3

import sys
import re
import itertools

# main is so many if/else branches in a loop
# should probably be one massive case statement in a loop instead ...

#========================================

# global data section

# generic hybrid C/Java main function prototype
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

    # rm pseduo-op markers
    data = data[1:]
    text = text[1:]

    # print("data\n")
    # [ print(x) for x in data ]
    # print("text\n")
    # [ print(x) for x in text ]
    # print()

    #----------------------------------------

    # DATA PROCESSING
    data_process(data,out_file)

    #----------------------------------------

    # CODE PROCESSING
    # makes some assumptions aboput the format

    syscall_flag = -1
    counter = 0  # updated on continues/loop ends (TBH not 100% sure though... seriously doubt this is properly tracking the data...)
    end_data = []
    funcall_args = [] # i dont even think thi is used yet ???
    fun_bounds = False #  updated only in a few places see: exit, exit2, ... (TBH not 100% sure though... seriously doubt this is properly tracking the data...)

    # special case for mini java compiler
    if text[0] == "jal main" and text[1] == "li $v0, 10" and text[2] == "syscall":
        out_file.write(enter_main)
        asm = text[3:]
    else:
        asm = text

    # .text code body
    for t in asm:
        # possible .data in the code section (some compiler generated code)
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

        ## ----- LABELS ----- ##

        # LABELS in the code section
        chop = []
        if chup[0][-1] == ":":
            if fun_bounds == True:
                out_file.write( "function " + chup[0][:-1] + "\n{\n")
                fun_bounds = False
            elif chup[0][:-1] == "main":
                # print("AAA")
                out_file.write(main_top) # main function header
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

        ## ----- MACRO EXPANSION ----- ##

        # MACROS (common idioms)
        if chop[0] == "done":
            out_file.write(tab)
            out_file.write("exit();\n")
            out_file.write("}\n\n")
            fun_bounds = True
            continue
        elif chop[0] == "terminate":
            out_file.write(tab)
            out_file.write("exit2(" + chop[1] + ");\n")
            out_file.write("}\n\n")
            fun_bounds = True
            continue

        ## ----- SYSCALLs ----- ##

        # SYSCALLS
        #  1 - 17  SPIM
        # 30 - 59  MARS, (not used)	37-39, 45-49
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
                out_file.write("v0 = open(a0,a1,a2);\n")
            elif syscall_flag == "14":
                out_file.write("v0 = read(a0,a1,a2);\n")
            elif syscall_flag == "15":
                out_file.write("v0 = write(a0,a1,a2);\n")
            elif syscall_flag == "16":
                out_file.write("close(a0);\n")
            elif syscall_flag == "17": # exit2  - end of function
                out_file.write("exit2(a0);\n")
                out_file.write("}\n\n")
                fun_bounds = True
            # start MARS specific syscalls
            elif syscall_flag == "30":
                out_file.write("time(a0,a1);\n") # a0,a1 probably passed by reference and written into ?
            elif syscall_flag == "31":
                out_file.write("MIDI_out(a0,a1,a2);\n") # Generate tone and return immediately.
            elif syscall_flag == "32":
                out_file.write("sleep(a0);\n") # Causes the MARS Java thread to sleep for (at least) the specified number of milliseconds.
            elif syscall_flag == "33":
                out_file.write("MIDI_out_synchronous(a0,a1,a2);\n") # Generate tone and return upon tone completion.
            elif syscall_flag == "34":
                out_file.write("print_int_in_ hex(a0);\n")
            elif syscall_flag == "35":
                out_file.write("print_int_in_binary(a0);\n")
            elif syscall_flag == "36":
                out_file.write("print_int_in_unsigned(a0);\n")
            elif syscall_flag == "40":
                out_file.write("set_seed(a0,a1);\n")
            # probably an error ???
            else:
                out_file.write("syscall(); // unknown ?\n")
            syscall_flag = -1
            counter += 1
            continue

        ## ----- SETUP ----- ##

        # setup for syscall/return
        if chop[1] == "$v0":
            if chop[0] == "li":
                syscall_flag = chop[2]
                counter += 1
                continue
            if chop[0] == "move": # note possible return value in output
                out_file.write(tab + "// return value ?\n")

        # SET ON
        if   chop[0] == "slt":
            continue
            # ... fuck

        ## ----- CONTROL FLOW ----- ##

        # RETURN  - end of function
        if chop[0] == "jr" and chop[1] == "$ra":
            out_file.write("}\n\n")
            fun_bounds = True
            counter += 1
            continue

        # JUMP
        if   chop[0] == "j":
            out_file.write(tab + "goto " + chop[1] + ";\n")
            continue
        elif chop[0] == "jr":
            out_file.write(tab + "goto *" + chop[1][1:] + "; // indirect jump\n") # should add the params in a loop
            continue
        elif chop[0] == "jal": # function call
            out_file.write(tab + chop[1] + "();\n") # should add the params in a loop
            continue
        elif chop[0] == "jalr": # indirect function call
            out_file.write(tab + "(*" + chop[1][1:] + ")(); // indirect function call\n") # should add the params in a loop
            continue

        # BRANCH
        # has one delay slot
        if chop[0] == "b":
            out_file.write(tab + "goto " + chop[1] + ";\n")
            continue
        elif chop[0] == "bal": # function call
            out_file.write(tab + chop[1] + "();\n") # should add the params in a loop
            continue
        elif chop[0] == "beq":
            out_file.write(tab + "if(" + chop[1][1:] + " == " + chop[2][1:] + ")\n")
            out_file.write(tab + tab + "goto " + chop[3] + ";\n")
            continue
        elif chop[0] == "beqz":
            out_file.write(tab + "if(" + chop[1][1:] + " == 0)\n")
            out_file.write(tab + tab + "goto " + chop[2] + ";\n")
            continue
        elif chop[0] == "bne":
            out_file.write(tab + "if(" + chop[1][1:] + " != " + chop[2][1:] + ")\n")
            out_file.write(tab + tab + "goto " + chop[3] + ";\n")
            continue
        elif chop[0] == "bnez":
            out_file.write(tab + "if(" + chop[1][1:] + " != 0)\n")
            out_file.write(tab + tab + "goto " + chop[2] + ";\n")
            continue
        elif chop[0] == "bgt":
            out_file.write(tab + "if(" + chop[1][1:] + " > " + chop[2][1:] + ")\n")
            out_file.write(tab + tab + "goto " + chop[3] + ";\n")
            continue
        elif chop[0] == "bgtz":
            out_file.write(tab + "if(" + chop[1][1:] + " > 0)\n")
            out_file.write(tab + tab + "goto " + chop[2] + ";\n")
            continue
        elif chop[0] == "bge":
            out_file.write(tab + "if(" + chop[1][1:] + " >= " + chop[2][1:] + ")\n")
            out_file.write(tab + tab + "goto " + chop[3] + ";\n")
            continue
        elif chop[0] == "bgez":
            out_file.write(tab + "if(" + chop[1][1:] + " >= 0)\n")
            out_file.write(tab + tab + "goto " + chop[2] + ";\n")
            continue
        elif chop[0] == "bgezla": # function call
            out_file.write(tab + "if(" + chop[1][1:] + " >= 0)\n")
            out_file.write(tab + tab + chop[2] + "();\n")
            continue
        elif chop[0] == "blt":
            out_file.write(tab + "if(" + chop[1][1:] + " < " + chop[2][1:] + ")\n")
            out_file.write(tab + tab + "goto " + chop[3] + ";\n")
            continue
        elif chop[0] == "bltz":
            out_file.write(tab + "if(" + chop[1][1:] + " < 0)\n")
            out_file.write(tab + tab + "goto " + chop[2] + ";\n")
            continue
        elif chop[0] == "ble":
            out_file.write(tab + "if(" + chop[1][1:] + " <= " + chop[2][1:] + ")\n")
            out_file.write(tab + tab + "goto " + chop[3] + ";\n")
            continue
        elif chop[0] == "blez":
            out_file.write(tab + "if(" + chop[1][1:] + " <= 0)\n")
            out_file.write(tab + tab + "goto " + chop[2] + ";\n")
            continue
        elif chop[0] == "blezla": # function call
            out_file.write(tab + "if(" + chop[1][1:] + " <= 0)\n")
            out_file.write(tab + tab + chop[2] + "();\n")
            continue

        ## ----- MEMORY ACCESS ----- ##

        # LOAD : immediate, address, byte, word
        if chop[0] == "lw" or chop[0] == "li" or chop[0] == "la" or chop[0] == "lb":
            out_file.write(tab + chop[1][1:] + " = " + chop[2] + ";\n")
            counter += 1
            continue

        # STORE
        # proably nor 100% correct for function calls
        if chop[0] == "sw" or chop[0] == "sb":
            out_file.write(tab + chop[2] + " = " + chop[1][1:] + ";\n")
            continue

        # MOVE
        if chop[0] == "move":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + ";\n")
            continue
        elif chop[0] == "mfhi":
            out_file.write(tab + chop[1][1:] + " = hi;\n")
            continue
        elif chop[0] == "mflo":
            out_file.write(tab + chop[1][1:] + " = lo;\n")
            continue

        ## ----- ARITHMETIC ----- ##

        # NEG
        if   chop[0] == "neg" or chop[0] == "negu":
            out_file.write(tab + chop[1][1:] + " = -" + chop[2][1:] + ";\n")
            continue

        # ADD
        if   chop[0] == "add" or chop[0] == "addu":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " + " + chop[3][1:] + ";\n")
            continue
        elif chop[0] == "addi" or chop[0] == "addiu":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " + " + chop[3] + ";\n")
            continue

        # SUB
        if   chop[0] == "sub":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " - " + chop[3][1:] + ";\n")
            continue
        elif chop[0] == "subu":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " - " + chop[3] + ";\n")
            continue

        # MUL (pseduo op)
        if   chop[0] == "mul": # without overflow
            if chop[3][0] == "$": # register
                out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " * " + chop[3][1:] + ";\n")
            else: # immediate
                out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " * " + chop[3] + ";\n")
            continue
        # MULT, DIV, DIVU
        # require using hi/lo special registers?

        # SHIFT
        if   chop[0] == "srl":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " >> " + chop[3] + ";\n")
            continue
        elif chop[0] == "sll":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " << " + chop[3] + ";\n")
            continue

        ## ----- LOGIC ----- ##

        # AND
        if   chop[0] == "and":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " & " + chop[3][1:] + ";\n")
            continue
        elif chop[0] == "andi":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " & " + chop[3] + ";\n")
            continue

        # OR
        if   chop[0] == "or":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " | " + chop[3][1:] + ";\n")
            continue
        elif chop[0] == "ori":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " | " + chop[3] + ";\n")
            continue

        # XOR
        if   chop[0] == "xor":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " ^ " + chop[3][1:] + ";\n")
            continue
        elif chop[0] == "xori":
            out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " ^ " + chop[3] + ";\n")
            continue

        # NOR
        if   chop[0] == "nor":
            out_file.write(tab + chop[1][1:] + " = ~(" + chop[2][1:] + " | " + chop[3][1:] + ");\n")
            continue

        # NOT
        if   chop[0] == "not":
            out_file.write(tab + chop[1][1:] + " = ~" + chop[2][1:] + ";\n")
            continue

        # NOP
        if chop[0] == "nop":
            continue

        ## ----- MISC ----- ##

        # etc...
        out_file.write(tab + t + "\n")
        counter += 1
    # end for loop

    #----------------------------------------

    # DATA PROCESSING
    if end_data:
        data_process(end_data,out_file)

#========================================

# DATA: int, float, double, char*, ...
def data_process(data,out_file):
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
            val = ''.join( str(e)+" " for e in list( itertools.chain( y[2:] ) ) ) # adds an extra space before the semicolon
            if   y[1] == ".asciiz" or y[1] == "ascii":
                out_file.write("char* " + name + " = " + val + ";\n")
            elif y[1] == ".word":
                out_file.write("int " + name + " = " + val + ";\n")
            elif y[1] == ".float":
                out_file.write("float " + name + " = " + val + ";\n")
            elif y[1] == ".double":
                out_file.write("double " + name + " = " + val + ";\n")
            elif y[1] == ".space":
                out_file.write("array[" + val.strip() + "] " + name +";\n") # probably a generic array

#========================================

# handle command line && redirect to main
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Missing Arguments")
        print("Usage: $ ./rev.py <files>")
        sys.exit(1)
    files = sys.argv[1:]
    for file in files:
        main(file)
