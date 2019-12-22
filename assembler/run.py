import sys
import re
import tqdm

oneOp = {}
branchOp = {}
twoOp = {}
noOp = {}
reg = {}


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


def load_codes():
    with open("./one_operand.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            oneOp[key] = val

    with open("./branch_operand.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            branchOp[key] = val

    with open("./two_operand.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            twoOp[key] = val

    with open("./no_operand.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            noOp[key] = val

    with open("./src_dst.txt") as f:
        for line in f:
            line = re.sub(' +', ' ', line)
            line = line.replace("\n", '')
            key, space, val = line.partition(' ')
            reg[key] = val


def check_syntax_error(instructionAddress, instruction, debugLines, instructionNum, instructions):
    org = r"(^\.[oO][rR][gG]\s{0,1}[0-9a-fA-F]+$)"
    hexaNum = r"(^\s{0,1}[0-9a-fA-F]+$)"
    operation = (instruction.split())[0].lower()
    newAddress = instructionAddress + 1

    if re.match(org, instruction, flags=0):
        newAddress = int((instruction.split())[1], 16)
    elif re.match(hexaNum, instruction, flags=0):
        code = bin(int(hexaNum, 16))[2:].zfill(16)
        if(len(code) == 0):
            debugLines.append((instruction, "hex", instructionAddress, code))
        else:
            raise ValueError('A syntx error', instruction)
    elif operation in oneOp:
        code = oneOp[operation]+reg[(instruction.split())[1].lower()]
        if(len(code) == 16):
            debugLines.append((instruction, "1op", instructionAddress, code))
        else:
            raise ValueError('A syntx error', instruction)
    elif operation in branchOp:
        to = (instruction.split())[1].lower()
        offest = -1
        addressNested = newAddress
        for i in range(instructionNum+1, len(instructions)):
            operationNested = (instructions[i][1].split())[0].lower()
            flag = re.match(
                hexaNum, instructions[i][1], flags=0) or operationNested in oneOp or operationNested in branchOp or operationNested in twoOp or operationNested in noOp
            if to+":" == instructions[i][1].replace(" ", "").lower():
                offest = addressNested - newAddress
                instructions.pop(i)  # address
                break
            elif(re.match(org, instructions[i][1], flags=0)):
                addressNested = int((instructions[i][1].split())[1], 16)
            elif(flag):
                addressNested += 1
        if(offest == -1):
            raise ValueError('A syntx error', instruction)
        code = branchOp[operation] + bin(offest+1)[2:].zfill(6)
        if(len(code) == 16):
            debugLines.append((instruction, "1op", instructionAddress, code))
        else:
            raise ValueError('A syntx error', instruction)
    elif operation in twoOp:
        arrayOp = (instruction.replace(',', ' ')).split()
        op, src, dst = [x.lower() for x in arrayOp]
        if(len(arrayOp) == 3):
            if (src in reg) and (dst in reg):
                code = twoOp[op]+reg[src]+reg[dst]
                if(len(code) == 16):
                    debugLines.append(
                        (instruction, "2op", instructionAddress, code))
                else:
                    raise ValueError('A syntx error', instruction)
            else:
                raise ValueError('A syntx error', instruction)
    elif operation in noOp:
        if(len(instruction.split()) < 2):
            code = noOp[operation]
            if(len(code) == 16):
                debugLines.append(
                    (instruction, "nop", instructionAddress, code))
            else:
                raise ValueError('A syntx error', instruction)
        else:
            raise ValueError('A syntx error', instruction)
    else:
        raise ValueError('A syntx error', instruction)
    return newAddress


def compile_code(lines, debug):
    instructions = []
    debug.writelines(
        "----------------------------- START CODE -----------------------------\n")
    # remove all white spaces and comments
    debugLines = []
    instructionAddress = 0
    for lineNum, line in enumerate(lines):
        instruction = line.partition('#')[0]
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
    debug.writelines(
        "----------------------------- START INSTUCTION INFORMATION LIST -----------------------------\n")
    debug.writelines(
        ["(instruction = %s) (instruction type = %s) (address in hex = 0x%x) (instruction code = %s)\n" % debugLine for debugLine in debugLines])
    debug.writelines(
        "----------------------------- END INSTUCTION INFORMATION LIST -------------------------------\n")
    # check if there is a syntax error
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
