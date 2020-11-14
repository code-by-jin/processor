# Processor Checkpoint 2 -- The Fully Functional Processor
### Team members: Wenxin Xu (wx65) and Jin Zhou (jz230)

Our testing is based on the Waveform. 

Our design is based on the reference of slide 14 in Lecture 8.

### Clock Design
As shown in the table below. Given the skeleton clock as clk, IMem and DMem will use clk as clock; PC and Register will divide the clk by four as their own clock.
| Component | Clock   |
| -------------  |:-------------:|
| PC           | ~clk/4 |
| IMem         | clk       |
| Register            | ~clk/4     |
| DMem            | clk  |

### Instruction Decode
With q_imem as input, decoding can be expressed as steps below:

1. Decode operation type: decide which instruction will be excuted.
2. `rt = q_imem[16:12]`, `rs = q_imem[21:17]`, `rd = q_imem[26:22]` and `Immed = q_imem[16:0]` are decoded for register and alu operations. 
3. `ALU_op = q_imem[6:2]` and `shamt  = q_imem[11:7]` are decoded if the operation type is decided as alu in step 1, otherwise they will be decoded as 0.

### Overflow Control
Here, we treat overflow as an exception. Overflow Label which indicate what operation causes overflow will be writtend into `$30`. Exceptions writing takes precedent in our design.

### PC design
We use muxes to select the next pc. A few options include `T`, `PC + 1` and `PC + N + 1`, details are in the `processor.v`. 
