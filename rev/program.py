import re
import itertools

class Program():

    def __init__(self,in_file,out_file):
        self.in_file  = in_file
        self.out_file = out_file
        self.data = list()
        self.text = list()

    #----------------------------------------

    def decompile(self):
        # separate .text and .data
        self.setup()
        # initial data segment processing
        self.data_process(self.data)
        # code processing
        self.text_process()

    #----------------------------------------

    def setup(self):
        # strip empty space and comments
        code = []
        for line in self.in_file:
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

        self.data = data
        self.text = text

    #----------------------------------------

    # DATA: int, float, double, char*, ...
    def data_process(self,data):
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
                    self.out_file.write("char* " + name + " = " + val + ";\n")
                elif y[1] == ".word":
                    self.out_file.write("int " + name + " = " + val + ";\n")
                elif y[1] == ".float":
                    self.out_file.write("float " + name + " = " + val + ";\n")
                elif y[1] == ".double":
                    self.out_file.write("double " + name + " = " + val + ";\n")
                elif y[1] == ".space":
                    self.out_file.write("array[" + val.strip() + "] " + name +";\n") # probably a generic array

    #----------------------------------------

    # makes some assumptions about the format
    def text_process(self):
        syscall_flag = -1
        counter = 0  # updated on continues/loop ends (TBH not 100% sure though... seriously doubt this is properly tracking the data...)
        end_data = []
        funcall_args = [] # i dont even think thi is used yet ???
        fun_bounds = False #  updated only in a few places see: exit, exit2, ... (TBH not 100% sure though... seriously doubt this is properly tracking the data...)
        greg1 = re.compile('.globl*')
        greg2 = re.compile('.global*')
        tab = "    " # 4 spaces

        # special case
        # Mini Java compiler entry point wrapper around main
        if self.text[0] == "jal Main" and self.text[1] == "li $v0, 10" and self.text[2] == "syscall":
            self.out_file.write("void enter()\n{\n    main();\n    exit();\n}\n\n")
            asm = self.text[3:]
        else:
            asm = self.text

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
                    self.out_file.write( "function " + chup[0][:-1] + "()\n{\n")
                    fun_bounds = False
                elif chup[0][:-1] == "main" or chup[0][:-1] == "Main":
                    # print("AAA")
                    self.out_file.write("void main()\n{\n") # generic main function header
                else:
                    self.out_file.write(chup[0] + "\n")

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
                self.out_file.write(tab)
                self.out_file.write("exit();\n")
                self.out_file.write("}\n\n")
                fun_bounds = True
                continue
            elif chop[0] == "terminate":
                self.out_file.write(tab)
                self.out_file.write("exit2(" + chop[1] + ");\n")
                self.out_file.write("}\n\n")
                fun_bounds = True
                continue

            ## ----- SYSCALLs ----- ##

            # SYSCALLS
            #  1 - 17  SPIM
            # 30 - 59  MARS, (not used)	37-39, 45-49
            if chop[0] == "syscall":
                self.out_file.write(tab)
                if   syscall_flag == "1":
                    self.out_file.write("print_int(a0);\n")
                elif syscall_flag == "2":
                    self.out_file.write("print_float(f12);\n")
                elif syscall_flag == "3":
                    self.out_file.write("print_double(f12);\n")
                elif syscall_flag == "4":
                    self.out_file.write("print_string(a0);\n")
                elif syscall_flag == "5":
                    self.out_file.write("v0 = read_int();\n")
                elif syscall_flag == "6":
                    self.out_file.write("f0 = read_float();\n")
                elif syscall_flag == "7":
                    self.out_file.write("f0 = read_double();\n")
                elif syscall_flag == "8": # fgets
                    self.out_file.write("read_string(a0,a1);\n")
                elif syscall_flag == "9": # heapAlloc
                    self.out_file.write("v0 = sbrk(a0);\n")
                elif syscall_flag == "10": # exit  - end of function
                    self.out_file.write("exit();\n")
                    self.out_file.write("}\n\n")
                    fun_bounds = True
                elif syscall_flag == "11":
                    self.out_file.write("print_char(a0);\n")
                elif syscall_flag == "12":
                    self.out_file.write("v0 = read_char();\n")
                elif syscall_flag == "13":
                    self.out_file.write("v0 = open(a0,a1,a2);\n")
                elif syscall_flag == "14":
                    self.out_file.write("v0 = read(a0,a1,a2);\n")
                elif syscall_flag == "15":
                    self.out_file.write("v0 = write(a0,a1,a2);\n")
                elif syscall_flag == "16":
                    self.out_file.write("close(a0);\n")
                elif syscall_flag == "17": # exit2  - end of function
                    self.out_file.write("exit2(a0);\n")
                    self.out_file.write("}\n\n")
                    fun_bounds = True
                # MARS specific syscalls
                elif syscall_flag == "30":
                    self.out_file.write("time(a0,a1);\n") # a0,a1 probably passed by reference and written into ?
                elif syscall_flag == "31":
                    self.out_file.write("MIDI_out(a0,a1,a2);\n") # Generate tone and return immediately.
                elif syscall_flag == "32":
                    self.out_file.write("sleep(a0);\n") # Causes the MARS Java thread to sleep for (at least) the specified number of milliseconds.
                elif syscall_flag == "33":
                    self.out_file.write("MIDI_out_synchronous(a0,a1,a2);\n") # Generate tone and return upon tone completion.
                elif syscall_flag == "34":
                    self.out_file.write("print_int_in_ hex(a0);\n")
                elif syscall_flag == "35":
                    self.out_file.write("print_int_in_binary(a0);\n")
                elif syscall_flag == "36":
                    self.out_file.write("print_int_in_unsigned(a0);\n")
                elif syscall_flag == "40":
                    self.out_file.write("set_seed(a0,a1);\n")
                elif syscall_flag == "41": # $a0 contains the next pseudorandom
                    self.out_file.write("random_int(a0);\n")
                elif syscall_flag == "42": # $a0 contains the next pseudorandom
                    self.out_file.write("random_int_range(a0,a1);\n")
                elif syscall_flag == "43": # $f0 contains the next pseudorandom
                    self.out_file.write("random_float(a0);\n")
                elif syscall_flag == "44": # $f0 contains the next pseudorandom
                    self.out_file.write("random_double(a0);\n")
                elif syscall_flag == "50": # $a0 contains value of user-chosen option
                    self.out_file.write("ConfirmDialog(a0);\n")
                elif syscall_flag == "51":  # $a0 contains int read, $a1 contains status value
                    self.out_file.write("InputDialogInt(a0);\n")
                elif syscall_flag == "52": # $f0 contains float read, $a1 contains status value
                    self.out_file.write("InputDialogFloat(a0);\n")
                elif syscall_flag == "53": # $f0 contains double read, $a1 contains status value
                    self.out_file.write("InputDialogDouble(a0);\n")
                elif syscall_flag == "54": # $a1 contains status value
                    self.out_file.write("InputDialogString(a0,a1,a2);\n")
                elif syscall_flag == "55":
                    self.out_file.write("MessageDialog(a0,a1);\n")
                elif syscall_flag == "56":
                    self.out_file.write("MessageDialogInt(a0,a1);\n")
                elif syscall_flag == "57":
                    self.out_file.write("MessageDialogFloat(a0,f12);\n")
                elif syscall_flag == "58":
                    self.out_file.write("MessageDialogDouble(a0,f12);\n")
                elif syscall_flag == "59":
                    self.out_file.write("MessageDialogString(a0,a1);\n")
                # probably an error ???
                else:
                    self.out_file.write("syscall(); // unknown ?\n")
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
                    self.out_file.write(tab + "// return value ?\n")

            # SET LESS THAN
            if   chop[0] == "slt" or chop[0] == "sltu":
                self.out_file.write(tab + "if(" + chop[2][1:] + " < " + chop[3][1:] + ")\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 1;\n")
                self.out_file.write(tab + "else\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 0;\n")
                continue
            elif chop[0] == "slti" or chop[0] == "sltiu":
                self.out_file.write(tab + "if(" + chop[2][1:] + " < " + chop[3] + ")\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 1;\n")
                self.out_file.write(tab + "else\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 0;\n")
                continue
            # SET LESS THAN EQUAL
            elif chop[0] == "sle" or chop[0] == "sleu":
                self.out_file.write(tab + "if(" + chop[2][1:] + " <= " + chop[3][1:] + ")\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 1;\n")
                self.out_file.write(tab + "else\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 0;\n")
                continue
            # SET GREATER THAN
            elif chop[0] == "sgt" or chop[0] == "sgtu":
                self.out_file.write(tab + "if(" + chop[2][1:] + " > " + chop[3][1:] + ")\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 1;\n")
                self.out_file.write(tab + "else\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 0;\n")
                continue
            # SET GREATER THAN EQUAL
            elif chop[0] == "sge" or chop[0] == "sgeu":
                self.out_file.write(tab + "if(" + chop[2][1:] + " >= " + chop[3][1:] + ")\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 1;\n")
                self.out_file.write(tab + "else\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 0;\n")
                continue
            # SET EQUAL
            elif chop[0] == "seq":
                self.out_file.write(tab + "if(" + chop[2][1:] + " == " + chop[3][1:] + ")\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 1;\n")
                self.out_file.write(tab + "else\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 0;\n")
                continue
            # SET NOT EQUAL
            elif chop[0] == "sne":
                self.out_file.write(tab + "if(" + chop[2][1:] + " != " + chop[3][1:] + ")\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 1;\n")
                self.out_file.write(tab + "else\n")
                self.out_file.write(tab + tab + chop[1][1:] + " = 0;\n")
                continue

            ## ----- CONTROL FLOW ----- ##

            # RETURN  - end of function
            if chop[0] == "jr" and chop[1] == "$ra":
                self.out_file.write("}\n\n")
                fun_bounds = True
                counter += 1
                continue

            # JUMP
            if   chop[0] == "j":
                self.out_file.write(tab + "goto " + chop[1] + ";\n")
                continue
            elif chop[0] == "jr":
                self.out_file.write(tab + "goto *" + chop[1][1:] + "; // indirect jump\n") # should add the params in a loop
                continue
            elif chop[0] == "jal": # function call
                self.out_file.write(tab + chop[1] + "();\n") # should add the params in a loop
                continue
            elif chop[0] == "jalr": # indirect function call
                self.out_file.write(tab + "(*" + chop[1][1:] + ")(); // indirect function call\n") # should add the params in a loop
                continue

            # BRANCH
            # has one delay slot
            if chop[0] == "b":
                self.out_file.write(tab + "goto " + chop[1] + ";\n")
                continue
            elif chop[0] == "bal": # function call
                self.out_file.write(tab + chop[1] + "();\n") # should add the params in a loop
                continue
            elif chop[0] == "beq":
                self.out_file.write(tab + "if(" + chop[1][1:] + " == " + chop[2][1:] + ")\n")
                self.out_file.write(tab + tab + "goto " + chop[3] + ";\n")
                continue
            elif chop[0] == "beqz":
                self.out_file.write(tab + "if(" + chop[1][1:] + " == 0)\n")
                self.out_file.write(tab + tab + "goto " + chop[2] + ";\n")
                continue
            elif chop[0] == "bne":
                self.out_file.write(tab + "if(" + chop[1][1:] + " != " + chop[2][1:] + ")\n")
                self.out_file.write(tab + tab + "goto " + chop[3] + ";\n")
                continue
            elif chop[0] == "bnez":
                self.out_file.write(tab + "if(" + chop[1][1:] + " != 0)\n")
                self.out_file.write(tab + tab + "goto " + chop[2] + ";\n")
                continue
            elif chop[0] == "bgt":
                self.out_file.write(tab + "if(" + chop[1][1:] + " > " + chop[2][1:] + ")\n")
                self.out_file.write(tab + tab + "goto " + chop[3] + ";\n")
                continue
            elif chop[0] == "bgtz":
                self.out_file.write(tab + "if(" + chop[1][1:] + " > 0)\n")
                self.out_file.write(tab + tab + "goto " + chop[2] + ";\n")
                continue
            elif chop[0] == "bge":
                self.out_file.write(tab + "if(" + chop[1][1:] + " >= " + chop[2][1:] + ")\n")
                self.out_file.write(tab + tab + "goto " + chop[3] + ";\n")
                continue
            elif chop[0] == "bgez":
                self.out_file.write(tab + "if(" + chop[1][1:] + " >= 0)\n")
                self.out_file.write(tab + tab + "goto " + chop[2] + ";\n")
                continue
            elif chop[0] == "bgezla": # function call
                self.out_file.write(tab + "if(" + chop[1][1:] + " >= 0)\n")
                self.out_file.write(tab + tab + chop[2] + "();\n")
                continue
            elif chop[0] == "blt":
                self.out_file.write(tab + "if(" + chop[1][1:] + " < " + chop[2][1:] + ")\n")
                self.out_file.write(tab + tab + "goto " + chop[3] + ";\n")
                continue
            elif chop[0] == "bltz":
                self.out_file.write(tab + "if(" + chop[1][1:] + " < 0)\n")
                self.out_file.write(tab + tab + "goto " + chop[2] + ";\n")
                continue
            elif chop[0] == "ble":
                self.out_file.write(tab + "if(" + chop[1][1:] + " <= " + chop[2][1:] + ")\n")
                self.out_file.write(tab + tab + "goto " + chop[3] + ";\n")
                continue
            elif chop[0] == "blez":
                self.out_file.write(tab + "if(" + chop[1][1:] + " <= 0)\n")
                self.out_file.write(tab + tab + "goto " + chop[2] + ";\n")
                continue
            elif chop[0] == "blezla": # function call
                self.out_file.write(tab + "if(" + chop[1][1:] + " <= 0)\n")
                self.out_file.write(tab + tab + chop[2] + "();\n")
                continue

            ## ----- MEMORY ACCESS ----- ##

            # LOAD : immediate, address, byte, word
            # proably not 100% correct
            if chop[0] == "lw" or chop[0] == "li" or chop[0] == "la" or chop[0] == "lb":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2] + ";\n")
                counter += 1
                continue

            # STORE
            # proably not 100% correct
            if chop[0] == "sw" or chop[0] == "sb":
                self.out_file.write(tab + chop[2] + " = " + chop[1][1:] + ";\n")
                continue

            # MOVE
            if chop[0] == "move":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + ";\n")
                continue
            elif chop[0] == "mfhi":
                self.out_file.write(tab + chop[1][1:] + " = hi;\n")
                continue
            elif chop[0] == "mflo":
                self.out_file.write(tab + chop[1][1:] + " = lo;\n")
                continue

            ## ----- ARITHMETIC ----- ##

            # NEG
            if   chop[0] == "neg" or chop[0] == "negu":
                self.out_file.write(tab + chop[1][1:] + " = -" + chop[2][1:] + ";\n")
                continue

            # ADD
            if   chop[0] == "add" or chop[0] == "addu":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " + " + chop[3][1:] + ";\n")
                continue
            elif chop[0] == "addi" or chop[0] == "addiu":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " + " + chop[3] + ";\n")
                continue

            # SUB
            if   chop[0] == "sub":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " - " + chop[3][1:] + ";\n")
                continue
            elif chop[0] == "subu":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " - " + chop[3] + ";\n")
                continue

            # MUL (pseduo-op without overflow)
            if   chop[0] == "mul":
                if chop[3][0] == "$": # register
                    self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " * " + chop[3][1:] + ";\n")
                else: # immediate
                    self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " * " + chop[3] + ";\n")
                continue
            # MULT, DIV, DIVU
            # require using hi/lo special registers?

            # SHIFT
            if   chop[0] == "srl" or chop[0] == "sra": # logical/arithmetic
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " >> " + chop[3] + ";\n")
                continue
            elif chop[0] == "sll":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " << " + chop[3] + ";\n")
                continue
            elif chop[0] == "sllv": # variable shift
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " << " + chop[3][1:] + ";\n")
                continue

            ## ----- LOGIC ----- ##

            # AND
            if   chop[0] == "and":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " & " + chop[3][1:] + ";\n")
                continue
            elif chop[0] == "andi":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " & " + chop[3] + ";\n")
                continue

            # OR
            if   chop[0] == "or":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " | " + chop[3][1:] + ";\n")
                continue
            elif chop[0] == "ori":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " | " + chop[3] + ";\n")
                continue

            # XOR
            if   chop[0] == "xor":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " ^ " + chop[3][1:] + ";\n")
                continue
            elif chop[0] == "xori":
                self.out_file.write(tab + chop[1][1:] + " = " + chop[2][1:] + " ^ " + chop[3] + ";\n")
                continue

            # NOR
            if   chop[0] == "nor":
                self.out_file.write(tab + chop[1][1:] + " = ~(" + chop[2][1:] + " | " + chop[3][1:] + ");\n")
                continue

            # NOT
            if   chop[0] == "not":
                self.out_file.write(tab + chop[1][1:] + " = ~" + chop[2][1:] + ";\n")
                continue

            ## ----- MISC ----- ##

            # NOP
            if chop[0] == "nop":
                continue

            # etc...
            self.out_file.write(tab + t + "\n")
            counter += 1
        # end for loop

        # DATA PROCESSING
        if end_data:
            self.data_process(end_data)

    #----------------------------------------
