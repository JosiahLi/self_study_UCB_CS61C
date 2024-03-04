- When `PCsel` is 0, then select `pc + 4`.
- When `Asel` and `Bsel` is 0, then select the contents in the register.
- When `MemRW` is 0, it represents `read`, otherwise `write`.
- `WBSel` might be  `00`, `01` or `10`, representing, respectively,  memory, ALU and `pc + 4`. Addition:`11`: immediate.
- `ImmSel` might be `001`, `010`, `011`, `100`, `101`, which are, respectively, `I` type, `S` type, `SB` type, `U` type and `UJ` type. Note `110` represents `CSR` type.

| Name  | BrEq | BrLt | PCsel | RegWEn | Immsel | BrUn | Asel | Bsel | ALUSel | MemRW | WBSel | CSRSel | CSRWen |
| ----- | ---- | ---- | ----- | ------ | ------ | ---- | ---- | ---- | ------ | ----- | ----- | ------ | ------ |
| addi  | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 0000   | 0     | 01    |        |        |
| slli  | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 0110   | 0     | 01    |        |        |
| srli  | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 0100   | 0     | 01    |        |        |
| srai  | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 0101   | 0     | 01    |        |        |
| andi  | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 0001   | 0     | 01    |        |        |
| ori   | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 0010   | 0     | 01    |        |        |
| xori  | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 0011   | 0     | 01    |        |        |
| slti  | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 0111   | 0     | 01    |        |        |
| sltiu | *    | *    | 0     | 1      | 001(I) | *    | 0    | 1    | 1000   | 0     | 01    |        |        |
| jalr  | *    | *    | 1     | 1      | 001(I) | *    | 0    | 1    | 0000   | 0     | 10    |        |        |

The format of the address used for indexing ROM is `inst[30] | inst[14:12] | inst[6:2] | Breq | BrLt`.

Note: `MemRW` can not be `*`, since `MemRw` is used for a multiplexor.



## I-Type

### addi

- `inst[30]`: *
- `inst[14:12]`: 000
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: *00000100 `BrEq and BrLt`: **. Thus, There are 8 combinations.

| 00000010000 0x10  |
| ----------------- |
| 00000010001 0x11  |
| 00000010010 0x12  |
| 00000010011 0x13  |
| 10000010000 0x410 |
| 10000010001 0x411 |
| 10000010010 0x412 |
| 10000010011 0x413 |

The content at the address is `010010010000001` or `0x2481`.

### slli

- `inst[30]`: 0
- `inst[14:12]`: 001
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: 000100100**. There are 4 combinations.

- 00010010000 0x90
- 00010010001 0x91
- 00010010010 0x92
- 00010010011 0x93

The content at these addresses is `010010010110001` or `0x24b1`.

### srli

- `inst[30]`: 0
- `inst[14:12]`: 101
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: 010100100**. There are 4 combinations.

- 01010010000 0x290
- 01010010001 0x291
- 01010010010 0x292
- 01010010011 0x293

The content at these addresses is `010010010100001` or `0x24A1`.

### srla

- `inst[30]`: 1
- `inst[14:12]`: 101
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: 110100100**. There are 4 combinations.

- 11010010000 0x690
- 11010010001 0x691
- 11010010010 0x692
- 11010010011 0x693

The content at these addresses is `010010010101001` or `0x24a9`.

### andi

- `inst[30]`: *
- `inst[14:12]`: 111
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: *11100100**. There are 8 combinations.

- 01110010000 0x390
- ...
- ...
- ...
- 11110010000 0x790
- ...
- ...
- ...

The content at these addresses is `010010010001001` or `0x2489`.

### ori

- `inst[30]`: *
- `inst[14:12]`: 110
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: *11000100**. There are 8 combinations.

- 01100010000 0x310
- ...
- ...
- ...
- 11100010000 0x710
- ...
- ...
- ...

The content at these addresses is `010010010010001` or `0x2491`.

### xori

- `inst[30]`: *
- `inst[14:12]`: 100
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: *10000100**. There are 8 combinations.

- 01000010000 0x210
- ...
- ...
- ...
- 11000010000 0x610
- ...
- ...
- ...

The content at these addresses is `010010010011001` or `0x2499`.

### slti

- `inst[30]`: *
- `inst[14:12]`: 010
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: *01000100**. There are 8 combinations.

- 00100010000 0x110
- ...
- ...
- ...
- 10100010000 0x510
- ...
- ...
- ...

The content at these addresses is `010010010111001` or `0x24b9`.

### sltiu

- `inst[30]`: *
- `inst[14:12]`: 011
- `inst[6:2]`: 00100
- Both `Breq` and `BrLt`: *

`address`: *01100100**. There are 8 combinations.

- 00110010000 0x190
- ...
- ...
- ...
- 10110010000 0x590
- ...
- ...
- ...

The content at these addresses is `010010011000001` or `0x24c1`.

### jalr

- `inst[30]`: *
- `inst[14:12]`: 000
- `inst[6:2]`: 11001
- Both `Breq` and `BrLt`: 0

`address`: 00001100100 or `0x64`.

`content`: 110010010000010 `0x6482`

## U type and UJ type

| Name  | BrEq | BrLt | PCsel | RegWEn | Immsel  | BrUn | Asel  | Bsel   | ALUSel    | MemRW | WBSel    |
| ----- | ---- | ---- | ----- | ------ | ------- | ---- | ----- | ------ | --------- | ----- | -------- |
| lui   | *    | *    | 0     | 1      | 100     | *    | *     | *      | **        | 0     | 11(imm)  |
| auipc | *    | *    | 0     | 1      | 100(U)  | *    | 1(PC) | 1(imm) | 0000(add) | 0     | 01(ALU)  |
| jal   | *    | *    | 1     | 1      | 101(UJ) | *    | 1(PC) | 1(imm) | 0000      | 0     | 10(PC+4) |



### lui

- `inst[30]`: *
- `inst[14:12]`: ***
- `inst[6:2]`: 01101
- Both `Breq` and `BrLt`: *

`address`: \*\*\*\*01101**. There are $2^{6}$ combinations. That is hard to set DOM. We note that `lui`, `auipc`, `jal` and `jalr` have the common bit `1` on `inst[2]`, and `funct3 ` of `jalr` is 000 and `inst[30]` of `jalr` is `*`. Thus,  we can set all `*`'s to 0 when `inst[2]` is 1.

That is, `address`: 00000110100 0x34

The content at these addresses is `011000000000011` or `0x3003`.

### auipc

- `inst[30]`: *
- `inst[14:12]`: ***
- `inst[6:2]`: 00101
- Both `Breq` and `BrLt`: *

`address`: 00000010100 or `0x14`.

`content`: 011000110000001 or `ox3181`

### jal

- `inst[30]`: *
- `inst[14:12]`: ***
- `inst[6:2]`: 11011
- Both `Breq` and `BrLt`: *

`address`: 00001101100 or `0x6c`.

`content`: 111010110000010 or `0x7582`

​               

## R type

| Name  | BrEq | BrLt | PCsel   | RegWEn | Immsel | BrUn | Asel | Bsel | ALUSel    | MemRW | WBSel   |
| ----- | ---- | ---- | ------- | ------ | ------ | ---- | ---- | ---- | --------- | ----- | ------- |
| add   | *    | *    | 0(PC+4) | 1      | ***    | *    | 0    | 0    | 0000(add) | 0     | 01(ALU) |
| sub   | *    | *    | 0       | 1      | ***    | *    | 0    | 0    | 1100(sub) | 0     | 01      |
| sll   | *    | *    | 0       | 1      | ***    | *    | 0    | 0    | 0110      | 0     | 01      |
| mul   |      |      |         |        |        |      |      |      | 1010      |       |         |
| mulhu |      |      |         |        |        |      |      |      | 1011      |       |         |
| slt   |      |      |         |        |        |      |      |      | 0111      | 0     | 01      |
| srl   |      |      |         |        |        |      |      |      | 0100      |       |         |
| sra   |      |      |         |        |        |      |      |      | 0101      |       |         |
|       |      |      |         |        |        |      |      |      |           |       |         |
|       |      |      |         |        |        |      |      |      |           |       |         |
|       |      |      |         |        |        |      |      |      |           |       |         |

010000000100001

### add

- `inst[30]`: 0
- `inst[14:12]`: 000
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 000001100**. There are 4 combinations. 

- 00000110000 0x30
- ...

The content at the address is 010000000000001 or `0x2001`.



### sll

- `inst[30]`: 0
- `inst[14:12]`: 001
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 000101100**. There are 4 combinations. 

- 00010110000 0xB0
- ...

The content at the address is 010000000110001 `0x2031`.

### sub

- `inst[30]`: 1
- `inst[14:12]`: 000
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 10000110000 0x430 ...

`content`: 010000001100001 `0x2061`

### mul

- `inst[30]`: 1
- `inst[14:12]`: 000
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 10000110000 0x430 ...

The address is the same as `add`, we need additional logic in control logic module.

### mulh

The address is the same as `sll`, just adding additional logic into control logic module.

### mulhu

- `inst[30]`: 0
- `inst[14:12]`: 011
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 00110110000 `0x1b0` ...

`content`: 010000001011001 `0x2059`

### slt

- `inst[30]`: 0
- `inst[14:12]`: 010
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 00100110000`0x130` ...

`content`: 010000000111001 `0x2039`

### xor

- `inst[30]`: 0
- `inst[14:12]`: 100
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 01000110000 `0x230` ...

`content`: 010000000011001 `0x2019`

### srl

- `inst[30]`: 0
- `inst[14:12]`: 101
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 01010110000 `0x2b0` ...

`content`: 010000000100001 `0x2021`

### sra

- `inst[30]`: 1
- `inst[14:12]`: 101
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 11010110000 `0x6b0` ...

`content`: 010000000101001 `0x2029`

### or

- `inst[30]`: 0
- `inst[14:12]`: 110
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 01100110000 `0x330` ...

`content`: 010000000010001 `0x2011`

### add

- `inst[30]`: 0
- `inst[14:12]`: 111
- `inst[6:2]`: 01100
- Both `Breq` and `BrLt`: *

`address`: 01110110000 `0x3b0` ...

`content`: 010000000000001 `0x2001`

## SB type

| Name       | BrEq | BrLt | PCsel   | RegWEn | Immsel  | BrUn | Asel | Bsel | ALUSel    | MemRW | WBSel |
| ---------- | ---- | ---- | ------- | ------ | ------- | ---- | ---- | ---- | --------- | ----- | ----- |
| beq(taken) | 1    | *    | 1       | 0      | 011(SB) | *    | 1    | 1    | 0000(add) | 0     | **    |
| beq(not)   | 0    | *    | 0(PC+4) | 0      | 011     | *    | 1    | 1    | 0000      | 0     | **    |
| bne(taken) | 0    | *    | 1       | 0      | 011     | *    | 1    | 1    | 0000      | 0     | **    |
| bne(not)   | 1    | *    | 0       | 0      | 011     | *    | 1    | 1    | 0000      | 0     | **    |
| blt(taken) | *    | 1    | 1       | 0      | 011     | 0    | 1    | 1    | 0000      | 0     | **    |
| blt(not)   | *    | 0    | 0(PC+4) | 0      | 011     | 0    | 1    | 1    | 0000      | 0     | **    |
| bge(taken) | *    | 0    | 1       | 0      | 011     | 0    | 1    | 1    | 0000      | 0     | **    |
| bge(not)   | *    | 1    | 0       | 0      | 011     | 0    | 1    | 1    | 0000      | 0     | **    |



| Name        | BrEq | BrLt | PCsel | RegWEn | Immsel  | BrUn | Asel | Bsel | ALUSel | MemRW | WBSel |
| ----------- | ---- | ---- | ----- | ------ | ------- | ---- | ---- | ---- | ------ | ----- | ----- |
| bltu(taken) | *    | 1    | 1     | 0      | 011(SB) | 1    | 1    | 1    | 0000   | 0     | **    |
| bltu(not)   | *    | 0    | 0     | 0      | 011     | 1    | 1    | 1    | 0000   | 0     | **    |
| bgeu(taken) | *    | 0    | 1     | 0      | 011     | 1    | 1    | 1    | 0000   | 0     | **    |
| bgeu(not)   | *    | 1    | 0     | 0      | 011     | 1    | 1    | 1    | 0000   | 0     | **    |

100111110000000 taken

000111110000000 not taken

### beq

taken

- `inst[30]`: *
- `inst[14:12]`: 000
- `inst[6:2]`: 11000
- `Breq`: 1  `BrLt`: *

`address`:

- 00001100010 0x62
- 00001100011 0x63
- 10001100010 0x462
- 10001100011 0x463

`content`: 100110110000000 0x4d80

not taken

- `inst[30]`: *
- `inst[14:12]`: 000
- `inst[6:2]`: 11000
- `Breq`: 0  `BrLt`: *

`address`:

- 00001100000 0x60
- 00001100001 0x61
- 10001100000 0x460
- 10001100001 0x461

`content`: 100110110000000 0xd80

### bne

not taken

- `inst[30]`: *
- `inst[14:12]`: 001
- `inst[6:2]`: 11000
- `Breq`: 1  `BrLt`: *

`address`:

- 00011100010 0xe2
- 00011100011 0xe3
- 10011100010 0x4e2
- 10011100011 0x4e3

`content`: 100110110000000 0xd80

taken

- `inst[30]`: *
- `inst[14:12]`: 001
- `inst[6:2]`: 11000
- `Breq`: 0  `BrLt`: *

`address`:

- 00011100000 0xe0
- 00011100001 0xe1
- 10011100000 0x4e0
- 10011100001 0x4e1

`content`: 100110110000000 0x4d80

### blt

taken

- `inst[30]`: *
- `inst[14:12]`: 100
- `inst[6:2]`: 11000
- `Breq`: *  `BrLt`: 1

`address`: 

- 01001100001 0x261
- 01001100011 0x263
- 11001100001 0x661
- 11001100011 0x663

`content`: 100110110000000 0x4d80



not taken

- `inst[30]`: *
- `inst[14:12]`: 100
- `inst[6:2]`: 11000
- `Breq`: *  `BrLt`: 0

`address`: 

- 01001100000 0x260
- 01001100010 0x262
- 11001100000 0x660
- 11001100010 0x662

`content`: 000110110000000 0xd80

### bge

taken

- `inst[30]`: *
- `inst[14:12]`: 101
- `inst[6:2]`: 11000
- `Breq`: *  `BrLt`: 0

`address`: 

- 01011100000 0x2e0
- 01011100010 0x2e2
- 11011100000 0x6e0
- 11011100010 0x6e2

`content`: 100110110000000 0x4d80



not taken

- `inst[30]`: *
- `inst[14:12]`: 101
- `inst[6:2]`: 11000
- `Breq`: *  `BrLt`: 1

`address`: 

- 01011100001 0x2e1
- 01011100011 0x2e3
- 11011100001 0x6e1
- 11011100011 0x6e3

`content`: 000110110000000 0xd80



### bltu

taken

- `inst[30]`: *
- `inst[14:12]`: 110
- `inst[6:2]`: 11000
- `Breq`: *  `BrLt`: 1

`address`: 

- 01101100001 0x361
- 01101100011 0x363
- 11101100001 0x761
- 11101100011 0x763

`content`: 100111110000000 0x4f80



not taken

- `inst[30]`: *
- `inst[14:12]`: 110
- `inst[6:2]`: 11000
- `Breq`: *  `BrLt`: 0

`address`: 

- 01101100000 0x360
- 01101100010 0x362
- 11101100000 0x760
- 11101100010 0x762

`content`: 000111110000000 0xf80



### bgeu

taken

- `inst[30]`: *
- `inst[14:12]`: 111
- `inst[6:2]`: 11000
- `Breq`: *  `BrLt`: 0

`address`: 

- 01111100000 0x3e0
- 01111100010 0x3e2
- 11111100000 0x7e0
- 11111100010 0x7e2

`content`: 100111110000000 0x4f80



not taken

- `inst[30]`: *
- `inst[14:12]`: 111
- `inst[6:2]`: 11000
- `Breq`: *  `BrLt`: 1

`address`: 

- 01111100001 0x3e1
- 01111100011 0x3e3
- 11111100001 0x7e1
- 11111100011 0x7e3

`content`: 000111110000000 0xf80



## Memory I type

| Name | BrEq | BrLt | PCsel   | RegWEn | Immsel | BrUn | Asel | Bsel | ALUSel | MemRW | WBSel |
| ---- | ---- | ---- | ------- | ------ | ------ | ---- | ---- | ---- | ------ | ----- | ----- |
| lb   | *    | *    | 0(PC+4) | 1      | 001(I) | *    | 0    | 1    | 0000   | 0     | 00    |
| lh   |      |      |         |        |        |      |      |      |        |       |       |
| lw   |      |      |         |        |        |      |      |      |        |       |       |

010010010000000

### lb

- `inst[30]`: *
- `inst[14:12]`: 000
- `inst[6:2]`: 00000
- `Breq`: *  `BrLt`: *

`address`: 

- 00000000000 0x0 ...
- 10000000000 0x400 ...

`content`: 010010010000000 0x2480

### lh

- `inst[30]`: *
- `inst[14:12]`: 001
- `inst[6:2]`: 00000
- `Breq`: *  `BrLt`: *

`address`: 

- 00010000000 0x080 ...
- 10010000000 0x480 ...

`content`: 010010010000000 0x2480

### lw

- `inst[30]`: *
- `inst[14:12]`: 010
- `inst[6:2]`: 00000
- `Breq`: *  `BrLt`: *

`address`: 

- 00100000000 0x100 ...
- 10100000000 0x500 ...

`content`: 010010010000000 0x2480



## Memory S type

| Name | BrEq | BrLt | PCsel   | RegWEn | Immsel | BrUn | Asel | Bsel | ALUSel | MemRW | WBSel |
| ---- | ---- | ---- | ------- | ------ | ------ | ---- | ---- | ---- | ------ | ----- | ----- |
| sb   | *    | *    | 0(PC+4) | 0      | 010(S) | *    | 0    | 1    | 0000   | 1     | **    |
| sh   |      |      |         |        |        |      |      |      |        |       |       |
| sw   |      |      |         |        |        |      |      |      |        |       |       |

000100010000100

### sb

- `inst[30]`: *
- `inst[14:12]`: 000
- `inst[6:2]`: 01000
- `Breq`: *  `BrLt`: *

`address`: 

- 00000100000 0x20 ...
- 10000100000 0x420 ...

`content`: 010010010000000 0x884

### sh

- `inst[30]`: *
- `inst[14:12]`: 001
- `inst[6:2]`: 01000
- `Breq`: *  `BrLt`: *

`address`: 

- 00010100000 0xA0 ...
- 10010100000 0x4A0 ...

`content`: 010010010000000 0x884

### sw

- `inst[30]`: *
- `inst[14:12]`: 010
- `inst[6:2]`: 01000
- `Breq`: *  `BrLt`: *

`address`: 

- 00100100000 0x120 ...
- 10100100000 0x520 ...

`content`: 010010010000000 0x884
