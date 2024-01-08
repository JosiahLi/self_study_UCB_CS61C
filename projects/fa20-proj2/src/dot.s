.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    addi sp, sp, -8
    sw s1, 4(sp)
    sw s0, 0(sp)

    li t0, 0 # i = 0
    mv s0, a0 # store the address of v0
    mv s1, a1 # store the address of v1
    # if n <= 0    
    li a1, 75
    bge x0, a2, dot_exit
    # if one of their strides is less than 1
    li a1, 76
    bge x0, a3, dot_exit 
    bge x0, a4, dot_exit 

    li a0, 0 # res = 0
    slli t1, a3, 2 # get the offset for v0 
    slli t2, a4, 2 # get the offset for v1
loop_start:
    # get the first element of v0
    lw t3, 0(s0) # get v0[i]
    # get the first element of v1
    lw  t4, 0(s1) # get v1[i] 
    # multiply
    mul t3, t3, t4 # t3 = v0[i] * v1[i]
    add a0, a0, t3 # res += t3
    # update count and address
    addi t0, t0, 1 # ++i
    add s0, s0, t1 # v0 += stride * 4
    add s1, s1, t2 # v1 += stride * 4
    # if i < n
    blt t0, a2, loop_start

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8

    ret
dot_exit:
    jal exit2