.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp) # file descriptor
    sw s4, 16(sp) # point to heap
    sw ra, 20(sp)
    # sp + 24 is used to store the matrix size
    # sp + 32 is used for error check

    # store arguments
    mv s0, a0 # file name
    mv s1, a1 # store the address of number of rows
    mv s2, a2 # store the address of number of columns
    
    # Step1, we open the file
    mv a1, s0 # set the first and 
    mv a2, x0 # second argument of fopen
    # call fopen
    jal fopen
    # check return value
    li a1, 90
    blt a0, x0, read_matrix_exit # error
    # store the file descriptor to s3 
    mv s3, a0

    # Step 2, we read 8 bytes to get the matrix size
    mv a1, s3
    addi a2, sp, 24 # get the address of the buffer allocated for matrix size 
    li a3, 8 # set the number of bytes to be read
    jal fread
    # Error check
    li a1, 91 
    blt a0, x0, read_matrix_exit # EOF
    li t0, 8
    blt a0, t0, read_matrix_exit  # the read bytes are less than expected

    # Step 3, allocate memory on heap
    lw t0, 24(sp) # get the number of rows
    lw t1, 28(sp) # get the number of columns
    mul a0, t0, t1 # set the arguments of malloc
    slli a0, a0, 2 # multiplied by 4
    jal malloc
    # Error check
    li a1, 88
    beq a0, x0, read_matrix_exit
    # store the returned pointer
    mv s4, a0

    # Step 4, read the elements of the matrix
    # set arguments for fread
    mv a1, s3
    mv a2, s4
    # get the matrix size
    lw t0, 24(sp) # get the number of rows
    lw t1, 28(sp) # get the number of columns
    mul a3, t0, t1 # set the size to be read
    slli a3, a3, 2 # multiplied by 4
    jal fread
    # Error check
    li a1, 91
    blt a0, x0, read_matrix_exit # EOF
    # get the matrix size
    lw t0, 24(sp) # get the number of rows
    lw t1, 28(sp) # get the number of columns
    mul t0, t0, t1 # total size
    slli t0, t0, 2 # multiplied by 4
    blt a0, t0, read_matrix_exit # the read bytes are less than expected
    # read the file again to enture that there is no rest of elements
    mv a1, s3
    addi a2, sp, 32 # set the address of buffer
    li a3, 1
    jal fread
    # Error check
    li a1, 91
    bge a0, x0, read_matrix_exit

    # Step 5, close the file 
    mv a1, s3  # a1 = fd
    jal fclose
    # Error check
    li a1, 92
    blt a0, x0, read_matrix_exit

    # Step 6, set the values being returned
    mv a0, s4
    mv a1, s1
    mv a2, s2
    lw t0, 24(sp) # number of rows
    lw t1, 28(sp) # number of columns
    sw t0, 0(a1)
    sw t1, 0(a2)

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp) # file descriptor
    lw s4, 16(sp) # point to heap
    lw ra, 20(sp)
    addi sp, sp, 36

    ret

read_matrix_exit:
    jal ra, exit2