.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -28 
    sw s0, 0(sp)  # file descriptor
    sw s1, 4(sp)  # pointer to matrix
    sw s2, 8(sp)  # rows 
    sw s3, 12(sp) # columns
    sw ra, 16(sp) # return address
    # sp + 20 is used for writing the nunber of columns and rows
    # End Prologue

    # store the arguments
    mv s1, a1
    mv s2, a2
    mv s3, a3 

    # Step 1, open the file for writing
    li a2, 1    # 1 denotes write purpose 
    mv a1, a0   # file name 
    jal ra, fopen
    # Error check
    li a1 93    # set the error code
    blt a0, x0, exit_write_matrix 
    # store the file descriptor
    mv s0, a0

    # Step 2, write the number of cols and rows to fd
    sw s2, 20(sp) # store the number of rows
    sw s3, 24(sp) # store the numebr of cols
    # set arguments for fwrite
    mv a1, s0 # a1 = fd
    addi a2, sp, 20 # a2 = &buffer
    li a3, 2  # number of elements to be written 
    li a4, 4  # bytes of each element
    jal ra, fwrite
    # Error check
    li a1, 94
    li t0, 2
    blt a0, t0, exit_write_matrix
    # NOTE: the data is not written to the file yet
    # until we call fclose or fflush

    # Step 3, write elements of matrix to fd
    mv a1, s0
    mv a2, s1
    mul a3, s2, s3 # total number of elements
    li a4, 4
    jal ra, fwrite
    # Error check
    li a1, 94
    mul t0, s2, s3 # get total number of elements
    blt a0, t0, exit_write_matrix

    # Step 4, closing the file, which automatically flushes the buffer
    mv a1, s0   # a1 = fd
    jal ra, fclose
    # Error check
    li a1, 95
    blt a0, x0, exit_write_matrix 

    # Epilogue
    lw s0, 0(sp)  # file descriptor
    lw s1, 4(sp)  # pointer to matrix
    lw s2, 8(sp)  # rows 
    lw s3, 12(sp) # columns
    lw ra, 16(sp) # return address
    addi sp, sp, 28

    ret

exit_write_matrix:
    jal ra, exit2