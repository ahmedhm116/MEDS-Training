.data
array: .word 1,10,-4,33,6,-12,55,27,-33,40,-9,24

.text
.globl main
main:
    la a0, array    # address
    li a1, 12       # size
    call sum_array

sum_array:
    li s0, 0    # i 
    li s1, 0    # sum

for_sum:
    bge  s0, a1, end_sum
    slli t0, s0, 2
    add  t1, a0, t0
    lw   t2, 0(t1)
    add  s1, s1, t2
    addi s0, s0, 1
    j    for_sum  

end_sum:
    mv a0, t0
    ret