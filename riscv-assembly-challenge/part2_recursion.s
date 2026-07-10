.data
array: .word  38, 27, 43, 9, 3, 82, 10
subarray1: .space   100
subarray2: .space   100

.text
.globl main
main:
    la   a0, array    #array
    li   s0, 7        #size
    li   a1, 0        #left
    addi a2, s0, -1   #right
    call merge_sort
    la   t0, array      
    li   t1, 0          #i

print_loop:
    bge  t1, s0, print_done
    slli t2, t1, 2       
    add  t3, t0, t2       
    lw   a1, 0(t3)        
    li   a0, 1
    ecall                    
    li   a0, 11
    li   a1, 32               
    ecall                      
    addi t1, t1, 1
    j    print_loop

print_done:
    li   a0, 10
    ecall

merge_sort:
    addi sp, sp, -48
    sw   ra, 44(sp)
    sw   s1, 40(sp)
    sw   s2, 36(sp)
    sw   s3, 32(sp)
    sw   s4, 28(sp)
    sw   s5, 24(sp)
    sw   s6, 20(sp)
    sw   s7, 16(sp)
    sw   s8, 12(sp)
    sw   s9, 8(sp)
    sw   s10, 4(sp)
    sw   s11, 0(sp)
    mv   s1, a0
    mv   s2, a1
    mv   s3, a2
    bge  s2, s3, exit

recurse:
    add  t0, s3, s2
    srli s4, t0, 1      #mid
    mv   a2, s4
    call merge_sort
    mv   a0, s1
    addi a1, s4, 1
    mv   a2, s3
    call merge_sort

merge:
    li   s5, 0          #i
    li   s6, 0          #j
    addi s7, s2, 0      #k
    sub  s8, s4, s2
    addi s8, s8, 1      #size of subarray1
    sub  s9, s3, s4     #size of subarray2
    la   s10, subarray1
    la   s11, subarray2 

for_n1:
    bge  s5, s8, end_n1
    add  t1, s2, s5
    slli t2, t1, 2
    add  t3, s1, t2
    lw   t4, 0(t3)
    slli t5, s5, 2
    add  t6, s10, t5
    sw   t4, 0(t6)
    addi s5, s5, 1
    j    for_n1

end_n1:
    li s5, 0

for_n2:
    bge  s6, s9, end_n2
    add  t1, s4, s6
    addi t1, t1, 1
    slli t2, t1, 2
    add  t3, s1, t2
    lw   t4, 0(t3)
    slli t5, s6, 2
    add  t6, s11, t5
    sw   t4, 0(t6)
    addi s6, s6, 1
    j    for_n2

end_n2:  
    li s6, 0

condition:
    blt s5, s8, while
    j   rem_index

while:
    bge  s6, s9, rem_index
    slli t1, s5, 2
    add  t2, s10, t1
    lw   t1, 0(t2)
    slli t3, s6, 2
    add  t4, s11, t3
    lw   t3, 0(t4)
    slli t5, s7, 2
    add  t6, s1, t5
    lw   t5, 0(t6)
    bgt  t1, t3, else
    mv   t5, t1
    sw   t5, 0(t6)
    addi s5, s5, 1
    addi s7, s7, 1
    j    condition

else:
    mv   t5, t3
    sw   t5, 0(t6)
    addi s6, s6, 1
    addi s7, s7, 1
    j    condition

rem_index:
    blt  s5, s8, left
    blt  s6, s9, right
    j    exit

left:
    slli t1, s5, 2         
    add  t2, s10, t1
    lw   t1, 0(t2)         
    slli t5, s7, 2      
    add  t6, s1, t5
    sw   t1, 0(t6)
    addi s5, s5, 1
    addi s7, s7, 1
    j    rem_index

right:
    slli t3, s6, 2        
    add  t4, s11, t3
    lw   t3, 0(t4)            
    slli t5, s7, 2         
    add  t6, s1, t5
    sw   t3, 0(t6)
    addi s6, s6, 1
    addi s7, s7, 1
    j    rem_index

exit:
    lw   ra, 44(sp)
    lw   s1, 40(sp)
    lw   s2, 36(sp)
    lw   s3, 32(sp)
    lw   s4, 28(sp)
    lw   s5, 24(sp)
    lw   s6, 20(sp)
    lw   s7, 16(sp)
    lw   s8, 12(sp)
    lw   s9, 8(sp)
    lw   s10, 4(sp)
    lw   s11, 0(sp)
    addi sp, sp, 48
    ret