# Formats of RISC-V ISA

The RISC-V ISA has a total of 47 instructions with 6 different formats. Each of the formats are distinguished on the basis of their opcodes. Each instruction type has a specific value of **opcode**, which indicates the task that should be performed. Some instruction types(e.g. I-Type) have two or three opcodes.
Further breakdown of the instruction is done on the basis of **func3t** (and **func7t** for R-Type) which tells what task is to performed from the format.Most formats have **imm**(immediate) values scattered across the whole 32 bit instruction. These values may be concrete values to be added or shifted by or based on the instruction type used to change the value of PC(program counter) or jump in memory.

### 1. R-TYPE

##### Basic Structure

| [31:25]funct7 | [24:20]rs2 | [19:15]rs1 | [14:12]funct3 | [11:7]rd | [6:0]opcode |
|---|---|---|---|---|---|

##### Example: sub x6, x7, x8

opcode = 0110011, funct3 = 000, funct7 = 0100000 
rd = x6 = 00110, rs1 = x7 = 00111, rs2 = x8 = 01000

**Binary**: 0100000 01000 00111 000 00110 0110011
**Hex**:    0x40838333

### 2. I-Type

##### Basic Structure

| [31:20]imm(11:0) | [19:15]rs1 | [14:12]funct3 | [11:7]rd | [6:0]opcode |
|---|---|---|---|---|

##### Example: andi x9, x10, 15

opcode = 0010011, funct3 = 111 
rd = x9 = 01001, rs1 = x10 = 01010, imm = 000000001111

**Binary**: 000000001111 01010 111 01001 0010011
**Hex**:    0x00F57493

### 3. S-Type

##### Basic Structure

| [31:25]imm(11:5) | [24:20]rs2 | [19:15]rs1 | [14:12]funct3 | [11:7]imm(4:0) | [6:0]opcode |
|---|---|---|---|---|---|

##### Example: sw x11, 8(x12)

opcode = 0100011, funct3 = 010 
rs1 = x12 = 01100, rs2 = x11 = 01011, imm = 8 = 000000001000
Split the immediate: imm[11:5] = 0000000, imm[4:0] = 01000

**Binary**: 0000000 01011 01100 010 01000 0100011
**Hex**:    0x00B62423

### 4. B-Type

##### Basic Structure

| [31:25]imm(12,10:5) | [24:20]rs2 | [19:15]rs1 | [14:12]funct3 | [11:7]imm(4:1,11) | [6:0]opcode |
|---|---|---|---|---|---|

##### Example: beq x13, x14, 16

opcode = 1100011, funct3 = 000
rs1 = x13 = 01101, rs2 = x14 = 01110, imm = 16 = 000000010000
split the immediate: imm[12|10:5] = 0000001, imm[4:1|11] = 00000

**Binary**: 0000001 01110 01101 000 00000 1100011
**Hex**:    0x02E68063

### 5. U-Type

##### Basic Structure

| [31:12]imm | [11:7]rd | [6:0]opcode |
|---|---|---|

##### Example: lui x15, 0x10

opcode = 0110111, rd = x15 = 01111, imm = 0x10 = 00000000000000010000

**Binary**: 00000000000000010000 01111 0110111
**Hex**:    0x000107B7

### 6. J-Type

##### Basic Structure

| [31:12]imm(20,10:1,11,19:12) | [11:7]rd | [6:0]opcode |
|---|---|---|

##### Example: jal x1, 32

opcode = 1101111, rd = x1 = 00001, imm = 00000000000000100000
split the immediate: imm[20] = 0, imm[10:1] = 0000100000, imm[11] = 0, imm[19:12] = 00000000

**Binary**: 0 0000100000 0 00000000 00001 1101111
**Hex**:    0x040000EF