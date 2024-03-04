# calculate accumulated sum of 10

li a0, 1 # i = 1
li s0, 0  # res = 0

li t0, 11 # t0 is used to compare with constant 11

# for (int i = 1; i < 11; ++i) res += i;
loop:
    bge a0, t0, 16 # if i >= 11
    add s0, s0, a0 # else res += i
    addi a0, a0, 1 # ++i
    jal x0, -12    # continue to loop
exit_loop:
    nop
