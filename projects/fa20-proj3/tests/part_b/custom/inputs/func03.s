# calculate 10!
main:
    li a1, 10 
    jal ra, 8 # call fact
    jal x0, 60 
# Take one parameter x: fact(x)
fact:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)

    li a0, 1 # set return value to 0
    beq a1, x0, 20 
    # if x != 0 
    add s0, a1, x0 # store the argument
    addi a1, s0, -1 # set the argument of next recursion to x - 1
    jal ra, -28 
    mul a0, s0, a0 # return value = x * (x - 1)
fact_eixt:
    lw, ra, 0(sp)
    lw, s0, 4(sp)
    addi sp, sp, 8
    jalr x0, ra, 0
none:
    addi x0, x0, 0