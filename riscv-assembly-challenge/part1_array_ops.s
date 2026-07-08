.data
array: .word 1,10,-4,33,6,-12,55,27,-33,40,-9,24

.text
.globl main
main:
    la a0, array    # address
    li a1, 12       # size
    call sum_array

#Function to sum all the elements of an array
sum_array:
    li t0, 0    #i 
    li t1, 0    #sum

for_sum:
    bge  t0, a1, end_sum    
    slli t2, t0, 2
    add  t3, a0, t2     
    lw   t4, 0(t3)
    add  t1, t1, t4
    addi t0, t0, 1
    j    for_sum  

end_sum:
    mv a0, t1
    ret

#Funtion to find the minimunm element of an array
find_min:
    li   t0, 0      #i
    slli t1, t0, 2
    add  t2, a0, t1
    lw   t3, 0(t2)  #value at the first index of the array

for_min:
    bge  t0, a1, end_min
    slli t1, t0, 2
    add  t2, a0, t1
    lw   t4, 0(t2)
    addi t0, t0, 1
    bge  t4, t3, skip_min
    mv   t3, t4

skip_min:
    j for_min    

end_min:
    mv a0, t3
    ret

#Function to find the maximum element of an array
find_max:
    li   t0, 0      #i
    slli t1, t0, 2
    add  t2, a0, t1
    lw   t3, 0(t2)  #value at the first index of the array

for_max:
    bge  t0, a1, end_max
    slli t1, t0, 2
    add  t2, a0, t1
    lw   t4, 0(t2)
    addi t0, t0, 1
    ble  t4, t3, skip_max
    mv   t3, t4

skip_max:
    j for_max

end_max:
    mv a0, t3
    ret

#Function to count the number negative elements in an array
count_negative:
    li t0, 0    #i
    li t1, 0    #count

for_count:
    bge  t0, a1, end_count
    slli t1, t0, 2
    add  t2, a0, t1
    lw   t4, 0(t2)
    addi t0, t0, 1
    bgez t4, skip_count
    addi t1, t1, 1

skip_count:
    j for_count

end_count:
    mv a0, t1
    ret