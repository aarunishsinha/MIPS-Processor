# MIPS-Processor
COL216 - Computer Architecture

## TODO:
In this project, I have developed and tested a VHDL model for a simple processor implementing a subset of the MIPS instruction set.
- The program to be executed is loaded into memory at address ZERO.
- Created a Memory Module.
- Initialized machine code in Memory.
- Read one instruction from Memory at a time, executed it, and proceeded to reading the next instruction from Memory.
- Every instruction is 32 bits wide.
- Implemented the following instructions to begin with: add, sub, lw, sw, sll, srl. Use the MIPS instruction format.
- Implemented the following branch instructions using J-type instruction format: bne, beq, blez, bgtz, j.
- Implemented the instructions used for procedure calls: jal, jr.
- Implemented non-leaf procedures (procedures that can call other procedures) using stack.
- The stack is implemented in memory and grows downwards.
- I have assumed that a maximum of four arguments can be passed to a procedure.
- Stopped execution when I see an instruction with all ZEROes.

## Memory Generation:
In Vivado, go to the Project Manager window on the left side of the screen. Open IP catalog. You can also open IP Catalog through a drop down menu after clicking on Window in the main menu on the top of the screen. IP (Intellectual Property) refers to pre-designed modules available for use. The IP catalog lists various IPs category-wise. Select the category “Memories & Storage Elements” and sub-category “RAMs & ROMs”. Now choose “BlockRAM Memory Generator”. Specify width and depth of Memory. Initialize the BlockRAM with the machine code of instructions using the coe file. \
In Other Options tab:
- Tick Load Init file and set the path of the coe file. Create a coe file and use its file path in Load Init file.
- Tick "Fill Remaining memory locations" with "0" to initialize uninitialized memory locations with zero.

## Sample Input(In Assembly Language Code):
```
.data

.text
.globl main
main:
	li $t0, 3
	li $t1, 5
	li $t2, 2
	li $t3, 6
	jal sum1
	j sub1
	beq $t4, $t5, sleft
	bne $t6, $t1, sright
	blez $t6, sum2
	bgtz $t5, sub2
	beq $t4, $t6, add3

sum1 :
	add $t4, $t0, $t1
	add $t5, $t2, $t3
	jr $ra
sub1:
	sub $t6, $t2, $t0
	sub $t7, $t3, $t1
	jr $ra
sleft:
	sll $t0, $t0, 2
	jr $ra
sright:
	srl $t1, $t1, 1
	jr $ra
sum2:
	add $t6, $t6, $t4
	jr $ra
sub2:
	sub $t5, $t5, $t7
	jr $ra
add3:
	add $t4, $t4, $t6
	jr $ra

.end main
```

## Output:
A Basys3 FPGA board is used to display output and run the designed simple processor.
- Printed the lower 16 bits of the output register in the last instruction on the 7-segment display.
- Along with the result, displayed the number of cycles taken to execute the program on the 7-segment display.
Also used a switch to display one result at a time, i.e., the7-segment LED displays the register contents when the switch is 0, and the cyclecount otherwise.

## Simulation:
The model was simulated in Vivado for checking correctness. ```Test.png``` show an instance of simulation performed.
