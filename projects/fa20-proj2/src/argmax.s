.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -4
    sw s0, 0(sp)

    mv s0, a0 # store the address of the vector to s0
    li t0, 1 # i = 1 
    lw t2, 0(s0) # get a[0]
    li a0, 0 # set the return valule to 0
    # if n == 1 
    beq a1, t0, loop_end
    # the length of the vector is less than 1
    addi s0, s0, 4 # let s0 point to a[1]
    blt t0, a1, loop_start # n > 1
    # set the exit code
    li a1, 77
    jal exit2

loop_start:
    # As of now, the length is greater than 1
    # t0 is used for counting index
    lw t1, 0(s0) # get a[i]
    bge t2, t1, loop_continue
    mv t2, t1
    mv a0, t0 
loop_continue:
    addi t0, t0, 1 # ++i
    addi s0, s0, 4 # a = a + 1
    blt t0, a1, loop_start
loop_end:
    # Epilogue
    lw s0, 0(sp)
    addi sp, sp, 4 

    ret
