.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    li t0, 0 # Check if # of elements is less than 1
    blt t0, a1, loop_start

    li a0, 78
    ret
    # Actually not need to call syscall
    #li a0, 17 # exit2
    #li a1, 78 # set exit code
    #ecall # exit(78)

loop_start:
    # Note: As of now, i = 0 
    lw t2, 0(a0) # get a[i]
    bge t2, x0, loop_continue # if a[i] >= 0
    sw x0, 0(a0) # else a[i] = 0
loop_continue:
    addi t0, t0, 1 # ++i 
    addi a0, a0, 4 # a = a + 1
    blt t0, a1, loop_start # if i < # of elements
loop_end:
    # Epilogue
	ret
