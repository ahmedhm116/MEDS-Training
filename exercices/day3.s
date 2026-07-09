.data
array: .word 1,2,3,4,5,6,7,8,9,10

.text
.globl main
main:
    li   s1, 10     #size
    la   s2, array  #address of first array element
    li   s3, 3      #target
    li   t1, 0      #low
    addi t2, s1, -1 #high

loop:
    bgt  t1, t2, end
    add  t3, t1, t2    
    srli t3, t3, 1     #mid
    slli t4, t3, 2
    add  t5, s2, t4
    lw   t6, 0(t5)
    bne  t6, s3, else  
    mv   a1, t3
    li   a0, 1
    ecall
    li   a0, 10
    ecall

else: 
    blt  s3, t6, else_if
    addi t1, t3, 1
    j    loop

else_if:
    addi t2, t3, -1
    j    loop

end:
    li a1, -1
    li   a0, 1
    ecall
    li   a0, 10
    ecal