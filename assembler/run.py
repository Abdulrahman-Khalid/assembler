# TO TRY CODE:
# python run.py (directory of files) (code file .asm file) (memory I want to write the code in file .mem) (debug file which has some visual data .txt)
# e.g: python run.py ./ test.asm  out.mem debug.txt
import sys
import re
oneOp = {}
branchOp = {}
twoOp = {}
noOp = {}
reg = {}
labels = {}
variables = {}  # have key => variable name, value => address of value of the variable


def over_write_memory(memoryTuples, outputMemFile):
    memoryStartIndex = 3
    memBitsNum = 16
    data = outputMemFile.readlines()
    outputMemFile.seek(0)
    lineLength = len(data[memoryStartIndex])
    for instructionAddress, opCode in memoryTuples:
        data[instructionAddress+memoryStartIndex] = data[instructionAddress +
                                                         memoryStartIndex][0:lineLength-(memBitsNum+1)]+opCode+'\n'
        print(data[instructionAddress+memoryStartIndex])
    outputMemFile.writelines(data)
    outputMemFile.truncate()

def generate_empty_memory(memFile):    
    init = 0
    to = 2**12
    bitsNum = 16
    with open(memFile, "a+") as f:
        if(init == 0):
            f.writelines("// Do not edit the following lines\n// instance=\n// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1\n")
        for i in range(init, to):
            f.writelines(hex(i)[2:].zfill(3)+": "+ "X"*bitsNum+"\n")


def load_codes():
    with open("./imports/one_operand.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            oneOp[key] = val

    with open("./imports/branch_operand.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            branchOp[key] = val

    with open("./imports/two_operand.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            twoOp[key] = val

    with open("./imports/no_operand.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            noOp[key] = val

    with open("./imports/src_dst.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            reg[key] = val


def check_syntax_error(instructionAddress, instruction, debugLines, instructionNum, instructions):
    org = r"(^\.[oO][rR][gG]\s{0,1}[0-9a-fA-F]+$)"
    word = r"(^\.[wW][oO][rR][dD]\s{0,1}[0-9a-fA-F]+$)"
    hexaNum = r"(^\s{0,1}[0-9a-fA-F]+$)"
    label = r"(^[A-Za-z][a-z|A-Z|0-9]+:{1}$)"
    operation = (instruction.split())[0].lower()
    if re.match(label, instruction, flags=0):
        key = instruction[0:-1].lower()
        if key in labels:
            raise ValueError('Syntax Error: ', instruction)
        else:
            labels[key] = instructionAddress
            return instructionAddress
    newAddress = instructionAddress + 1
    if len(instruction.split()) == 3:
        first, second, third = instruction.split()
        if re.match(word, second+third, flags=0):
            code = bin(int(third, 16))[2:].zfill(16)
            if(len(code) == 16):
                variables[first.lower()] = instructionAddress
                debugLines.append(
                    (instruction, "hex", instructionAddress, code))
                return newAddress
            else:
                raise ValueError('Syntax Error: ', instruction)
    if re.match(org, instruction, flags=0):
        newAddress = int((instruction.split())[1], 16)
    elif re.match(hexaNum, instruction, flags=0):
        code = bin(int(instruction, 16))[2:].zfill(16)
        if(len(code) == 16):
            debugLines.append((instruction, "hex", instructionAddress, code))
        else:
            raise ValueError('Syntax Error: ', instruction)
    elif operation in oneOp:
        code = oneOp[operation]+reg[(instruction.split())[1].lower()]
        if(len(code) == 16):
            debugLines.append((instruction, "1op", instructionAddress, code))
        else:
            raise ValueError('Syntax Error: ', instruction)
    elif operation in branchOp:
        to = (instruction.split())[1].lower()
        offest = 0
        addressNested = newAddress
        if to in labels:
            offest = labels[to] - instructionAddress
        else:
            for i in range(instructionNum+1, len(instructions)):
                operationNested = (instructions[i][1].split())[0].lower()
                flag = re.match(
                    hexaNum, instructions[i][1], flags=0) or operationNested in oneOp or operationNested in branchOp or operationNested in twoOp or operationNested in noOp
                if to+":" == instructions[i][1].replace(" ", "").lower():
                    offest = addressNested - newAddress + 1
                    break
                elif(re.match(org, instructions[i][1], flags=0)):
                    addressNested = int((instructions[i][1].split())[1], 16)
                elif(flag):
                    addressNested += 1
        if(offest == 0):
            raise ValueError('Syntax Error: ', instruction)

        offestCode = bin(abs(offest))[2:].zfill(6)
        if(offest > 0):
            code = branchOp[operation] + offestCode
        else:
            code = branchOp[operation] + '1' + offestCode[1:]
        if(len(code) == 16):
            debugLines.append((instruction, "1op", instructionAddress, code))
        else:
            raise ValueError('Syntax Error: ', instruction)
    elif operation in twoOp:
        arrayOp = (instruction.replace(',', ' ')).split()
        op, src, dst = [x.lower() for x in arrayOp]
        if(src[0:2] == "@#"):
            key = src[2:].lower()
            if(key in variables):
                code = bin(variables[key])[2:].zfill(16)
                if(len(code) == 16):
                    debugLines.append(
                        (variables[key], "hex", newAddress, code))
                    src = "@(r7)+"
                    newAddress += 1
                else:
                    raise ValueError('Syntax Error: ', instruction)
            else:
                raise ValueError('Syntax Error: ', instruction)
        elif(src[0] == "#"):
            num = src[1:].lower()
            if re.match(hexaNum, num, flags=0):
                code = bin(int(num, 16))[2:].zfill(16)
                if(len(code) == 16):
                    debugLines.append(
                        (num, "hex", newAddress, code))
                    src = "(r7)+"
                    newAddress += 1
                else:
                    raise ValueError('Syntax Error: ', instruction)
            else:
                raise ValueError('Syntax Error: ', instruction)
        if(dst[0:2] == "@#"):
            key = dst[2:].lower()
            if(key in variables):
                code = bin(variables[key])[2:].zfill(16)
                if(len(code) == 16):
                    debugLines.append(
                        (variables[key], "hex", newAddress, code))
                    dst = "@(r7)+"
                    newAddress += 1
                else:
                    raise ValueError('Syntax Error: ', instruction)
            else:
                raise ValueError('Syntax Error: ', instruction)
        elif(dst[0] == "#"):
            num = dst[1:].lower()
            if re.match(hexaNum, num, flags=0):
                code = bin(int(num, 16))[2:].zfill(16)
                if(len(code) == 16):
                    debugLines.append(
                        (num, "hex", newAddress, code))
                    dst = "(r7)+"
                    newAddress += 1
                else:
                    raise ValueError('Syntax Error: ', instruction)
            else:
                raise ValueError('Syntax Error: ', instruction)
        if(len(arrayOp) == 3):
            if (src in reg) and (dst in reg):
                code = twoOp[op]+reg[src]+reg[dst]
                if(len(code) == 16):
                    debugLines.append(
                        (instruction, "2op", instructionAddress, code))
                else:
                    raise ValueError('Syntax Error: ', instruction)
            else:
                raise ValueError('Syntax Error: ', instruction)
    elif operation in noOp:
        if(len(instruction.split()) < 2):
            code = noOp[operation]
            if(len(code) == 16):
                debugLines.append(
                    (instruction, "nop", instructionAddress, code))
            else:
                raise ValueError('Syntax Error: ', instruction)
        else:
            raise ValueError('Syntax Error: ', instruction)
    else:
        raise ValueError('Syntax Error: ', instruction)
    return newAddress


def compile_code(lines, debug):
    instructions = []
    debug.writelines(
        "----------------------------- START CODE -----------------------------\n")
    # remove all white spaces and comments
    debugLines = []
    instructionAddress = 0
    for lineNum, line in enumerate(lines):
        instruction = line.partition('//')[0]
        instruction = ' '.join(instruction.split())
        if (instruction != ''):
            instructions.append((lineNum, instruction.lower()))
            debug.writelines(instruction.lower()+'\n')
    for instructionNum, instructionTuple in enumerate(instructions):
        try:
            instructionAddress = check_syntax_error(
                instructionAddress, instructionTuple[1], debugLines, instructionNum, instructions)
        except ValueError as err:
            print("\nERROR in line: {}, code instruction: {}\n".format(
                instructionTuple[0], instructionTuple[1]))
            sys.exit()

    debug.writelines(
        "----------------------------- END CODE -------------------------------\n")
    debugLines.sort(key=lambda tup: tup[2])
    debug.writelines(
        "----------------------------- START INSTUCTION INFORMATION LIST -----------------------------\n")
    for debugLine in debugLines:
        debug.writelines("(instruction = {}) (instruction type = {}) (address in hex = {}) (instruction code = {})\n".format(debugLine[0],debugLine[1],hex(debugLine[2])[2:].zfill(3),debugLine[3]))
    debug.writelines(
        "----------------------------- END INSTUCTION INFORMATION LIST -------------------------------\n")
    # check if there is a Syntax Error:
    # (address in decimal, instruction code)
    memoryTuples = [(x[-2], x[-1]) for x in debugLines]
    return memoryTuples


def main():
    if (len(sys.argv) != 5):
        print("Wrong number of parameters")
        sys.exit()
    workingDir = sys.argv[1]
    inputFile = workingDir + sys.argv[2]
    outputFile = workingDir + sys.argv[3]
    debugFile = workingDir + sys.argv[4]
    load_codes()
    print("Input File: {}, Output File: {}, Debug File: {}".format(
        inputFile, outputFile, debugFile))
    try:
        f = open(inputFile, 'r')
        lines = f.readlines()
        debug = open(debugFile, 'w')
        output = open(outputFile, "r+")
        memoryTuples = compile_code(lines, debug)
        over_write_memory(memoryTuples, output)
        print("FINISHED!")
        f.close()
        output.close()
        debug.close()
    except IOError:
        print("Could not open files")
        sys.exit()


main()
# generate_empty_memory("./original.mem")
