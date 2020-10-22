nop

addi $1, $0, 5  # r1 = 5
addi $2, $0, 3  # r2 = 3
add  $3, $1, $2 # r3 = 5 + 3 = 8

sub $4, $1, $2 	# r4 = r1 - r2 = 2
and $5, $0, $1 	# r5 = 0
and $6, $1, $2  # r6 = 1
or  $7, $0, $2	# r7 = 3

sll $8, $1, 2	# r8 = r1 * 4 = 20
sra $9, $3, 1	# r9 = 4

addi $10, $0, 345	# r10 = 345
addi $11, $0, 567	# r11 = 567
sw $10, 1($0)		# store 345 into address 1
sw $11, 2($0)		# store 567 into address 2
lw $12, 1($0)		# load 345 into r12
lw $13, 2($0)		# load 567 into r13


addi $1, $0, 65535      # r1 = 65535 = 0x0000FFFF
sll $2, $1, 16			# r2 = r1 << 16 = 0xFFFF0000
addi $3, $0, 8      #  8 = 0x00001000
sll $4, $3, 16			# << 16 = 0x10000000
addi $5, $2, $4	#ovf

sll $6, $1, 15	# 0x7FFF8000
addi $6, $6, 36727	# +0x7FFF
addi $7, $2, 65534	#+0xFFFE
sub $8, $7, $6    # 0xFFFFFFFE - 0x7FFFFFFF
