.data
instr1:       .word 0x40838333
instr2:       .word 0x00F57493
instr3:       .word 0x00B62423
instr4:       .word 0x02E68063
instr5:       .word 0x000107B7
instr6:       .word 0x040000EF 
opcode:       .string " opcode: "
rd:           .string " rd: " 
funct3:       .string " funct3: "
rs1:          .string " rs1: "

.text
.globl main
main:
    li   s1, 0x6F
    li   s2, 0x37
    li   s3, 0x17
    la   a0, instr1
    call extract 
    la   a0, instr2
    call extract 
    la   a0, instr3
    call extract 
    la   a0, instr4
    call extract 
    la   a0, instr5
    call extract 
    la   a0, instr6
    call extract 
    li   a0, 10
    ecall

extract:
    lw   t0, 0(a0)
    andi t2, t0, 0x7F       #opcode
    li   a0, 4
    la   a1, opcode
    ecall
    li   a0, 34
    mv   a1, t2
    ecall
    srli t3, t0, 7
    andi t4, t3, 0x1F       #rd
    li   a0, 4
    la   a1, rd
    ecall
    li   a0, 34
    mv   a1, t4
    ecall
    beq  t2, s1, skip
    beq  t2, s2, skip
    beq  t2, s3, skip
    srli t3, t0, 12
    andi t5, t3, 0x7       #funct3
    li   a0, 4
    la   a1, funct3
    ecall
    li   a0, 34
    mv   a1, t5
    ecall
    srli t3, t0, 15
    andi t6, t3, 0x1F       #rs1
    li   a0, 4
    la   a1, rs1
    ecall
    li   a0, 34
    mv   a1, t6
    ecall
    li   a0, 11
    li   a1, 10
    ecall
    j    end

skip:
    li   a0, 11
    li   a1, 10
    ecall

end:
    ret