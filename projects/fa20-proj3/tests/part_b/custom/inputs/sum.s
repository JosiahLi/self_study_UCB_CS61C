main:
    li t0, 22
    li t1, 33
    jal ra, 16 
    jal ra, 24 

dalin:
    add s0, t1, t0
    jalr x0, ra, 0

erge:
    addi x0, x0, 0
