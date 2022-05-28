
startingLines = [
]
opToOpCodeBranch = {
    "jz": "0000011",
    "jc": "0000111",
    "jn": "0001011",
    "jmp": "0001111",
    "call": "0010011",
    "ret": "0010111",
    "int": "0011011",
    "rti": "0011111"
}
opToOpCodeMemory = {
    "ldd": "0001001",
    "std": "0001101",
    "push": "0010001",
    "pop": "0010101",
    "ldm": "0011001",
}
opToOpCodeTwoOperand = {
    "mov": "0001100",
    "add": "0010000",
    "and": "0010100",
    "sub": "0011000",
    "iadd": "0011100",
}

opToOpCodeOneOperand = {
    "nop": "0000110",
    "hlt": "0000010",
    "in": "0000001",
    "out": "0000101",
    "setc": "0000000",
    "not": "0000100",
    "inc": "0001000",
}
registerAddress = {
    'R0': '000',
    'R1': '001',
    'R2': '010',
    'R3': '011',
    'R4': '100',
    'R5': '101',
    'R6': '110',
    'R7': '111'
}
rootDir = 'C:\\Users\\ahmed\\Desktop\\assemble\\'
fileName = 'TwoOperand'
# instructions in the end
instructions = []
instructionsOrder = []
currentMemoryIndex = None

with open(rootDir + fileName + '.asm', 'r') as f:
    lines = f.readlines()
    for line in lines:
        lineNoSpaces = ' '.join(line.split()).upper()
        if(lineNoSpaces.startswith('#') or lineNoSpaces == ''):
            continue
        lineNoComments = lineNoSpaces[0: lineNoSpaces.find(
            '#') - 1] if (lineNoSpaces.find('#') != -1) else lineNoSpaces
        # split line intro individual components
        # 'OUT R1' -> ['OUT' , 'R1']
        lineArray = lineNoComments.split(' ')
        # handles org instruction
        if(lineArray[0] == '.ORG'):
            currentMemoryIndex = int(lineArray[1], 16)
            continue
        if (lineArray[0] in opToOpCodeOneOperand.keys()):
            opCodeTemp = opToOpCodeOneOperand[lineArray[0]]
            if(len(lineArray) == 1):
                registerAddress1, registerAddress2, registerAddress3 = '000', '000', '000'
            else:
                # if not we get the address
                registerAddress1, registerAddress2 = registerAddress[lineArray[1]
                                                                     ], registerAddress[lineArray[1]]
                registerAddress3 = '000'
            # add instruction instruction list
            instructions.append(opCodeTemp + registerAddress1 +
                                registerAddress2 + registerAddress3 + '00'+'0000000000000000')
        elif (lineArray[0] in opToOpCodeTwoOperand.keys()):
            # getting opcode and alu opcode
            opCodeTemp = opToOpCodeTwoOperand[lineArray[0]]
            # getting the two operands from instruction
            # getting address of first register
            operationOperands = lineArray[1].split(',')
            registerAddress1 = registerAddress[operationOperands[0]]
            registerAddress2 = registerAddress[operationOperands[1]]
            # checks if the 2nd instruction has an immediate or not
            if (operationOperands[2] in registerAddress.keys()):
                registerAddress3 = registerAddress[operationOperands[2]]
                immediateTemp = None
                instructions.append(opCodeTemp + registerAddress1 +
                                    registerAddress2 + registerAddress3 + '00'+'0000000000000000')
            else:
                immediateTemp = operationOperands[2]
                registerAddress3 = '000'
                instructions.append(opCodeTemp + registerAddress1 + registerAddress2 +
                                    registerAddress3 + + '00'+bin(int('0x' + immediateTemp.lower(), 16)))
                instructionsOrder.append(currentMemoryIndex)
                currentMemoryIndex += 1
            # adds instruction 1 to instructions list
            # if (immediateTemp != None):
            #     instructions.append(bin(int('0x' + immediateTemp.lower(), 16)))
            #     instructionsOrder.append(currentMemoryIndex)
            #     currentMemoryIndex += 1

        elif (lineArray[0] in opToOpCodeMemory.keys()):
            # get alu op code and op code
            opCodeTemp = opToOpCodeMemory[lineArray[0]]

            operationOperands = lineArray[1].split(',')
            registerAddress1 = registerAddress[operationOperands[0]]
            if (lineArray[0] in ['POP', 'PUSH']):
                instructions.append(
                    opCodeTemp + registerAddress1 + '000' + '000' + '00'+'0000000000000000')
            elif (lineArray[0] in ['STD', 'LDD']):
                operandTwoComponents = operationOperands[1].split('(')
                immediateTemp = operandTwoComponents[0]
                registerAddress2 = registerAddress[operandTwoComponents[1][:-1]]
                # add instruction to instructions list
                instructions.append(opCodeTemp + registerAddress1 + registerAddress2 +
                                    "000" + '00'+bin(int('0x' + immediateTemp.lower(), 16)))

                # add instruction order and increment
                instructionsOrder.append(currentMemoryIndex)
                currentMemoryIndex += 1
            elif (lineArray[0] == 'LDM'):

                instructions.append(opCodeTemp + registerAddress1 + '000' +
                                    '000' + '00'+bin(int('0x' + immediateTemp.lower(), 16)))
                immediateTemp = operationOperands[1]
                # add immediate
                # add instruction order and increment
                instructionsOrder.append(currentMemoryIndex)
                currentMemoryIndex += 1
        elif (lineArray[0] in opToOpCodeBranch.keys()):
            opCodeTemp = opToOpCodeBranch[lineArray[0]]
            if (lineArray[0] == 'RET' or lineArray[0] == 'RTI'):
                instructions.append(opCodeTemp + '000000' +
                                    '000' + '00'+'0000000000000000')
            else:
                immediateTemp = lineArray[1]
                def getbinary(x, n): return format(x, 'b').zfill(n)

                instructions.append(
                    opCodeTemp + '000' + '000' + '000'+'00'+getbinary(int(immediateTemp), 16))

        else:
            # for the instruction after org
            instructions.append('00000' + '000' + '000' +
                                '000'+'00'+'0000000000000000')

        instructionsOrder.append(currentMemoryIndex)
        # increment memroy address to write into after instruction
        if(currentMemoryIndex != None):
            currentMemoryIndex += 1

instructionsHex = [hex(int(i, 2)).upper()[2:] for i in instructions]
with open(rootDir + fileName + '.do', 'w') as f:
    for line in startingLines:
        f.write(line)
        f.write('\n')
    # for ins in instructions:
    #     f.write(ins)
    #     f.write('\n')
    for (instruction, instructionOrder) in zip(instructionsHex, instructionsOrder):
        f.write('mem load -filltype value -filldata {} -fillradix hexadecimal /processor/Memory_component/ram({})'.format(instruction, instructionOrder))
        f.write('\n')
