.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    # store a0
    mv t0, a0
    # check dimensions of m0
    li a0, 72
    bge x0, a1, matmul_end
    bge x0, a2, matmul_end 
    # check dimension of m1
    li a0, 73
    bge x0, a4, matmul_end
    bge x0, a5, matmul_end
    # check if the dimensions of m0 and m1 match
    li a0, 74
    bne a2, a4, matmul_end
    # retore a0
    mv a0, t0
    # Prologue
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp) 
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    # save arguments
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    # initialize count to i and j
    li s7, 0 # i = 0
    li s8, 0
    mv a2, s2 # set the length
    li a3, 1  # set the stride of row vector
    mv a4, s5 # set stride of the column vector

outer_loop_start:
    # set the address of the i-th row of m0 to a0
    mul t0, s2, s7 # get the position of the first element of the row vector 
    slli t0, t0, 2 # calculate byte offsets
    add a0, s0, t0 # calculate address
inner_loop_start:
    # set the address of the j-th column of m1 to a1
    slli t1, s8, 2
    add a1, s3, t1
    # save a0
    mv s9, a0
    # call dot 
    jal ra, dot
    # calculate the address of (i,j) position of the result matrix
    mul t2, s7, s5 # row position
    add t2, t2, s8 # add column position
    slli t2, t2, 2 # convert it to byte offsets
    add t2, t2, s6 # calculate address
    sw a0, 0(t2)   # store the return value of dot
inner_loop_end:
    # update j
    addi s8, s8, 1 # ++j
    # restore a0 and other arguments
    mv a0, s9
    mv a2, s2 # retore n for dot
    li a3, 1  # retore v0 stride
    mv a4, s5 # retore v1 stride

    bne s8, s5, inner_loop_start # if j != column # of m1
outer_loop_end:
    # update i
    addi s7, s7, 1 # ++i
    # initliaze j to 0
    li s8, 0
    bne s7, s1, outer_loop_start # if i != row # of m0
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp) 
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 44
    
matmul_end:
    ret
