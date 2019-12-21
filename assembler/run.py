import sys


def assembler(lines, debug):
    instructions = []
    debug.writelines(
        "----------------------------- START CODE -----------------------------\n")
    # remove all white spaces and comments
    for line in lines:
        instruction = line.partition('#')[0]
        instruction = ' '.join(instruction.split())
        if (instruction != ''):
            instructions.append(instruction.lower())
            debug.writelines(instruction.lower()+'\n')
    debug.writelines(
        "----------------------------- END CODE -----------------------------\n")


def main():
    if (len(sys.argv) != 5):
        print("Wrong number of parameters")
        sys.exit()
    workingDir = sys.argv[1]
    inputFile = workingDir + sys.argv[2]
    outputFile = workingDir + sys.argv[3]
    debugFile = workingDir + sys.argv[4]
    print("Input File: {}, Output File: {}, Debug File: {}".format(
        inputFile, outputFile, debugFile))
    try:
        f = open(inputFile, 'r')
        lines = f.readlines()
        debug = open(debugFile, 'w')
        output = open(outputFile, "r+")
        assembler(lines, debug)
        print("FINISHED!")
        f.close()
        output.close()
        debug.close()
    except IOError:
        print("Could not open or read one of the files:")
        sys.exit()


main()
