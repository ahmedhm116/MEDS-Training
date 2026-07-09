.text
.globl main
main:
    li   a0, 10  
    call fibonacci
    mv   a1, a0
    li   a0, 1
    ecall
    li   a0, 10
    ecall
    
fibonacci:
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s1, 8(sp)
    sw   s0, 4(sp)
    mv   s0, a0
    li   t0, 1
    beqz a0, base_case_0
    beq  a0, t0, base_case_1
    addi a0, s0, -1
    call fibonacci
    mv   s1, a0
    addi a0, s0, -2
    call fibonacci
    add  a0, s1, a0
    j    fib_return

base_case_0:
    li a0, 0
    j fib_return

base_case_1:
    li, a0, 1

fib_return:
    lw   s0, 4(sp)
    lw   s1, 8(sp)
    lw   ra, 12(sp)
    addi sp, sp, 16
    ret