.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


    # Prologue
    addi sp, sp, -56
    sw ra, 0(sp)
    sw s0, 4(sp)    # output flag
    sw s1, 8(sp)    # argv
    sw s2, 12(sp)   # pointer to M0 
    sw s3, 16(sp)   # pointer to M1
    sw s4, 20(sp)   # pointer to input matrix
    sw s5, 24(sp)   # pointer to output0
    sw s6, 28(sp)   # pointer to output1
    # sp + 32: rows of M0
    # sp + 36: cols of M0
    # sp + 40: rows of M1
    # sp + 44: cols of M1
    # sp + 48: rows of input matrix
    # sp + 52: cols of input matrix
 	# =====================================
    # COMMAND CHECK
    # =====================================
    mv t1, a1
    li t0, 5
    li a1, 89
    bne a0, t0, exit_classify  
    # restore a1
    mv a1, t1
    # store arguments
    mv s0, a2
    mv s1, a1
	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw a0, 4(s1)    # get file name of M0
    addi a1, sp, 32 # get rows of M0
    addi a2, sp, 36 # get cols of M0  
    jal ra, read_matrix
    mv s2, a0       # save the pointer to row-major matrix

    # Load pretrained m1
    lw a0, 8(s1)    # get file name of M1
    addi a1, sp, 40
    addi a2, sp, 44 
    jal ra, read_matrix
    mv s3, a0
   
    # Load input matrix
    lw a0, 12(s1) # get the file name of input matrix 
    addi a1, sp, 48
    addi a2, sp, 52
    jal ra, read_matrix
    mv s4, a0 

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # allocate memory for output matrix of m0 * input
    lw t0, 32(sp)   # load rows of M0
    lw t1, 52(sp)   # load cols of input matrix
    mul a1, t0, t1  # calculate length of the output matrix
    slli a1, a1, 2  # calculate the byte offsets
    jal ra, malloc
    # ERROR check
    li a1 88
    beq a0, x0, exit_classify
    mv s5, a0       # s5 = output0
    # calcualte M0 * input 
    mv a0, s2       # a0 = M0
    mv a3, s4       # a3 = input
    mv a6, s5       # a5 = output0 
    lw a1, 32(sp)   # a1 = rows of M0
    lw a2, 36(sp)   # a2 = cols of M0
    lw a4, 48(sp)   # a4 = rows of input
    lw a5, 52(sp)   # a5 = cols of input
    jal ra, matmul

    # relu(M0 * input)
    lw t0, 32(sp)
    lw t1, 52(sp)
    mul a1, t0, t1 # set the length of output0 
    mv a0, s5      # a0 = output0
    jal ra, relu
    # NOTE: relu is performed on output0 in-place

    # allocate memory for output1
    lw a0, 40(sp)  # get rows of M1
    lw t0, 52(sp)  # get cols of input
    mul a0, a0, t0 # calculate length of output1 
    slli a0, a0, 2 # calculate byte offsets
    jal ra, malloc
    # Error check
    li a1, 88
    beq a0, x0, exit_classify
    mv s6, a0      # s6 = output1

    # M1 * relu(M0 * input)
    mv a0, s3
    mv a3, s5
    mv a6, s6
    lw a1, 40(sp)
    lw a2, 44(sp)
    lw a4, 32(sp) 
    lw a5, 52(sp)
    jal ra, matmul
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)   # a0 = output file name 
    mv a1, s6       # a1 = output1 
    lw a2, 40(sp)   # a2 = rows of M1
    lw a3, 52(sp)   # a3 = cols of input 
    jal ra, write_matrix 

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw a1, 40(sp)
    lw t0, 52(sp)
    mul a1, a1, t0 # calculate the length of output1 
    mv a0, s6
    jal ra, argmax

    bne s0, x0, end_classify
    # Print classification
    mv a1, a0      # print argmax 
    jal ra, print_int
    # Print newline afterwards for clarity
    li a1, '\n' 
    jal ra, print_char

end_classify:
    # free output0
    mv a0, s5     # a0 = output0   
    jal ra, free
    # free output1
    mv a0, s6
    jal ra, free
    # free input
    mv a0, s4
    jal ra, free
    # free M1
    mv a0, s3
    jal ra, free
    # free M0
    mv a0, s2
    jal ra, free

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)    # output flag
    lw s1, 8(sp)    # argv
    lw s2, 12(sp)   # pointer to M0 
    lw s3, 16(sp)   # pointer to M1
    lw s4, 20(sp)   # pointer to input matrix
    lw s5, 24(sp)   # pointer to output0
    lw s6, 28(sp)   # pointer to output1
    addi sp, sp, 56

    ret

exit_classify:
    jal ra, exit2
