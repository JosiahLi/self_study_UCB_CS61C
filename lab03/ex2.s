.globl main

.data
source:
    .word   3
    .word   1
    .word   4
    .word   1
    .word   5
    .word   9
    .word   0
dest:
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0

.text
fun:
    addi t0, a0, 1 # t0 = source[k] + 1
    sub t1, x0, a0 # t1 = -source[k]
    mul a0, t0, t1 # return value = (source[k] + 1) * (-source[k])
    jr ra

main:
    # BEGIN PROLOGUE
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw ra, 16(sp)
    # END PROLOGUE
    addi t0, x0, 0 # k = 0
    addi s0, x0, 0 # sum = 0
    la s1, source # s1 = source
    la s2, dest # s2 = dest
loop:
    slli s3, t0, 2 # used to index
    add t1, s1, s3 # used for indexing into source
    lw t2, 0(t1) # t2 =  source[k]
    beq t2, x0, exit # exit when source[k] == 0
    add a0, x0, t2 # set source[k] as the first argument of next procedure call 
    addi sp, sp, -8 # allocate two words
    # since the values in t0 and t2 may be changed, we have to store them on stack
    sw t0, 0(sp) # store t0 on stack
    sw t2, 4(sp) # store source[k] on stack
    jal fun # call function fun
    lw t0, 0(sp) # restore
    lw t2, 4(sp)
    addi sp, sp, 8 # deallocated
    add t2, x0, a0 # t2 = return value
    add t3, s2, s3 # t3 is used for indexing into dest 
    sw t2, 0(t3) # dest[k] = return value
    add s0, s0, t2 # sum += return value
    addi t0, t0, 1 # k++;
    jal x0, loop # go to loop
exit:
    add a0, x0, s0 # set sum as the first argument
    # BEGIN EPILOGUE
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20
    # END EPILOGUE
    jr ra
