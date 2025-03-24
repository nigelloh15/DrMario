################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Nigel Loh, 1009837713
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       1
# - Unit height in pixels:      1
# - Display width in pixels:    32
# - Display height in pixels:   32
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
############################################################################## 
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

# Colors
RED:
  .word 0xff0000
GREEN:
  .word 0x00ff00
BLUE:
  .word 0x0000ff 
WHITE:
  .word 0xffffff
BLACK:
  .word 0x000000

P_BLUE:
  .word 0x6EB5FF
P_PINK:
  .word 0xFF9CEE
P_PURP:
  .word 0xB28DFF

# Starting X of box
BOX_X:
  .word 3
  
# Starting Y of box
BOX_Y:
  .word 8

BOX_ADDRESS:
  .word 0x1000840C

PILL_POS1:
  .word 0x1000832C
  
PILL_POS2:
  .word 0x100083AC

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

# Move up in the stack
.macro push ()
  addi $sp, $sp, -4
.end_macro

# Move down in the stack
.macro pop ()
  addi $sp, $sp, 4
.end_macro

j main

# Functinon to check row
# - $a0 Memory address of starting pixel
# - $a1 Color of starting pixel
# - $v0 address of left
# - $v1 number of elements to delete

check_row:

  # Get arguments off stack
  lw $a0, 0($sp)
  pop()
  lw $a1, 0($sp)
  pop()
  
  # Left directin of pixel
  addi $t5, $zero, 1
  subi $t3, $a0, 4
  left_horizontal_loop:
    lw $t1, 0($t3)
    bne $a1, $t1, left_horizontal_loop_end

    addi $t5, $t5, 1
    subi $t3, $t3, 4
    j left_horizontal_loop
  left_horizontal_loop_end:

  # Right of pixel
  addi $t4, $a0, 4
  right_horizontal_loop:
    lw $t1, 0($t4)
    bne $a1, $t1, right_horizontal_loop_end

    addi $t5, $t5, 1
    addi $t4, $t4, 4
    j right_horizontal_loop
  right_horizontal_loop_end:

  add $t3, $t3, 4
  add $v0, $t3, $zero
  add $v1, $t5, $zero

  jr $ra
check_row_end:

# Function to delete row
# - $a0 Starting position 
# - $a1 amount to delete
delete_row:

    lw $a0, 0($sp)
    pop()
    lw $a1, 0($sp)
    pop()
  
    add $t1, $zero, $zero # Loop constant
    lw $t2, BLACK
    
    delete_row_loop: 
      beq $t1, $a1, delete_row_loop_end

      sw $t2, 0($a0)
      addi $a0, $a0, 4
      addi $t1, $t1, 1
      
      j delete_row_loop
    delete_row_loop_end:

    jr $ra
delete_row_end:

# Functino to check column for elimination
# - $a0 Memory address of starting pixel
# - $a1 Color of starting pixel
# - $v0 address of top
# - $v1 number of elements to delete
check_column:

  # Get arguments off stack
  lw $a0, 0($sp)
  pop()
  lw $a1, 0($sp)
  pop()
  
  # Top directin of pixel
  addi $t5, $zero, 1
  subi $t3, $a0, 128
  top_loop:
    lw $t1, 0($t3)
    bne $a1, $t1, top_loop_end

    addi $t5, $t5, 1
    subi $t3, $t3, 128
    j top_loop
  top_loop_end:

  # Bottom of pixel
  addi $t4, $a0, 128
  bottom_loop:
    lw $t1, 0($t4)
    bne $a1, $t1, bottom_loop_end

    addi $t5, $t5, 1
    addi $t4, $t4, 128
    j bottom_loop
  bottom_loop_end:

  add $t3, $t3, 128
  add $v0, $t3, $zero
  add $v1, $t5, $zero

  jr $ra
check_column_end:

# Function to delete column
# - $a0 Starting position 
# - $a1 amount to delete
delete_column:

    lw $a0, 0($sp)
    pop()
    lw $a1, 0($sp)
    pop()
  
    add $t1, $zero, $zero # Loop constant
    lw $t2, BLACK
    
    delete_column_loop: 
      beq $t1, $a1, delete_column_loop_end

      sw $t2, 0($a0)
      addi $a0, $a0, 128
      addi $t1, $t1, 1
      
      j delete_column_loop
    delete_column_loop_end:

    jr $ra
delete_column_end:

# Function to drop the blocks above
# - $a0 Starting position
# - $a1 Width of drop
drop:

  lw $a0, 0($sp)
  pop()
  lw $a1, 0($sp)
  pop()

  add $t4, $a0, $zero 
  add $t1, $zero, $zero # loop constant
  drop_loop:
    beq $t1, $a1, drop_loop_end

    # calculate how far down to go
    add $t5, $t4, $zero
    down_length_loop:
      lw $t3, BLACK 
      bne $t5, $t3, down_length_loop_end
      addi $t5, $t5, 128 
    down_length_loop_end:

    # If $t5 not moved, dont change anything
    beq $t5, $t4, copy_color_to_bottom_done
    # copy column into down location 
    subi $t4, $t4, 128
    copy_color_to_bottom:

      lw $t2, 0($t4)
      beq $t2, $a3, copy_color_to_bottom_done
      
      sw $t2, 0($t5)
      sw $t3, 0($t4)

      subi $t4, $t4, 128
      subi $t5, $t5, 128

      j copy_color_to_bottom
    copy_color_to_bottom_done:

    # Shift pointer right one
    addi $t1, $t1, 1
    sll $t5, $t1, 2
    add $t4, $a0, $t5
   
    j drop_loop
  drop_loop_end:

  jr $ra
drop_end:

# Function to check for line of 4 of the same color and delete
check_and_delete:

  # Check & Delete for Pixel 1 Row
  push()
  sw $ra, 0($sp)

  push()
  sw $s5, 0($sp)
  
  push()
  sw $s7, 0($sp)

  jal check_row

  # Saving information into stack for dropping
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)


  addi $t1, $zero, 4
  blt $v1, $t1, p1_no_more_delete_row

  p1_delete_a_row:
    
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  jal delete_row
  
  p1_no_more_delete_row:

  # Check & Delete for Pixel 1 Column

  push()
  sw $s5, 0($sp)
  
  push()
  sw $s7, 0($sp)

  jal check_column
  
  # Saving information into stack for dropping
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  addi $t1, $zero, 4
  blt $v1, $t1, p1_no_more_delete_column

  p1_delete_a_column:
    
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  jal delete_column

  p1_no_more_delete_column:
  
  # Check & Delete for Pixel 2 Row
  push()
  sw $s4, 0($sp)
  
  push()
  sw $s6, 0($sp)

  jal check_row
  
  # Saving information into stack for dropping
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  addi $t1, $zero, 4
  blt $v1, $t1, p2_no_more_delete_row

  p2_delete_a_row:
    
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  jal delete_row
  
  p2_no_more_delete_row:

  # Check & Delete for Pixel 2 Column

  push()
  sw $s4, 0($sp)
  
  push()
  sw $s6, 0($sp)

  jal check_column
  
  # Saving information into stack for dropping
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  addi $t1, $zero, 4
  blt $v1, $t1, p2_no_more_delete_column

  p2_delete_a_column:
    
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  jal delete_column

  p2_no_more_delete_column:

  drop_everything:

    pop()
    pop()
    pop()
    pop()
    pop()
    pop()
    pop()
    pop()

  drop_everything_end:
    
  lw $ra, 0($sp) 
  pop()

  jr $ra
check_and_delete_end:

# Function to get random color
# - $a0 range
get_random_color:
    # Load random number limit
    lw $a1, 0($sp)
    pop()

    li $v0, 42
    li $a0, 0

    syscall
    jr $ra
get_random_color_end:

# Function to draw viruses
draw_virus:
  # Load address of the box
  lw $t5, BOX_ADDRESS
  # Shift it two right
  addi $t5, $t5, 8

  # Get random x deviation
  li $v0, 42
  li $a0, 0
  li $a1, 11
  syscall

  # Add the x deviation
  sll $a0, $a0, 2
  add $t5, $t5, $a0

  # Shift down 
  addi $t5, $t5, 384
  
  # Get random y deviation
  li $v0, 42
  li $a0, 0
  li $a1, 12
  syscall

  # Multiply y shift by 128
  sll $a0, $a0, 7
  add $t5, $t5, $a0
  
  # Get random color
  push()
  sw $ra, 0($sp)
  
  li $a0, 3
  push()
  sw $a0, 0($sp)

  jal get_random_color

  lw $ra, 0($sp)
  pop()

  li $t3, 0
  beq $t3, $a0, v_blue
  li $t3, 1
  beq $t3, $a0, v_pink
  li $t3, 2
  beq $t3, $a0, v_purp
  v_blue:
    lw $a0, P_BLUE
    b v_col_done
  v_pink:
    lw $a0, P_PINK
    b v_col_done
  v_purp:
    lw $a0, P_PURP
    b v_col_done
  v_col_done:
    
  sw $a0, 0($t5)
  jr $ra
draw_viruses_end:

# Draw Capsule
draw_capsule:
  # Get starting position of both pixels for pills
  lw $s7, PILL_POS1
  lw $s6, PILL_POS2

  # Check if can load pill
  lw $t3, BLACK
  lw $t5, 0($s7)
  lw $t4, 0($s6)
  bgt $t5, $t3, quit
  bgt $t4, $t3, quit
  
  # Get Random Color of 3
  li $v0, 42
  li $a0, 0
  li $a1, 3
  syscall
  beq $a0, 0, p1_col_0
  beq $a0, 1, p1_col_1
  beq $a0, 2, p1_col_2
  
  p1_col_0:
    lw $s5, P_BLUE
    b p1_done_col
  p1_col_1:
    lw $s5, P_PINK
    b p1_done_col
  p1_col_2:
    lw $s5, P_PURP
    b p1_done_col
  p1_done_col:
  sw $s5, 0($s7)

  
  # Get Random Color of 3
  li $v0, 42
  li $a0, 0
  li $a1, 3
  syscall
  beq $a0, 0, p2_col_0
  beq $a0, 1, p2_col_1
  beq $a0, 2, p2_col_2
  
  p2_col_0:
    lw $s4, P_BLUE
    b p2_done_col
  p2_col_1:
    lw $s4, P_PINK
    b p2_done_col
  p2_col_2:
    lw $s4, P_PURP
    b p2_done_col
  p2_done_col:
  sw $s4, 0($s6)

  jr $ra
end_draw_capsule:

# Keyboard Input Function
keyboard_input:             # A key is pressed
    lw $a0, 4($t0)          # Load second word from keyboard
    beq $a0, 0x71, quit     # Check if the key q was pressed
    beq $a0, 0x77, key_w     # Check if the key w was pressed
    beq $a0, 0x61, key_a     # Check if the key a was pressed
    beq $a0, 0x73, key_s     # Check if the key s was pressed
    beq $a0, 0x64, key_d     # Check if the key d was pressed

    li $v0, 1               # ask system to print $a0
    syscall

    jr $ra
  
  # 1b. Check which key has been pressed
  key_w:
  
    # Check if P1 comes before B2
    bgt $s6, $s7, before_p2
    blt $s6, $s7, after_p2
    
    before_p2:
  
      # Check if its above P2
      addi $t5, $s7, 128
      beq $t5, $s6, above_p2
      b left_p2
  
        above_p2:
          
          # Checking for collision
          lw $t3, BLACK
          addi $t5, $s7, 132
          lw $t5, 0($t5)
    
          bgt $t5, $t3, pass_input
  
          # Move P1 Diagonally Right down 1
          addi $s7, $s7, 132
          
          # Checking for landed
          lw $t3, BLACK
          addi $t5, $s7, 128
          addi $t4, $s6, 128
          lw $t5, 0($t5)
          lw $t4, 0($t4)
      
          bgt $t5, $t3, landed
          bgt $t4, $t3, landed
          
          jr $ra
  
        left_p2:
  
          # Checking for collision
          lw $t3, BLACK
          addi $t5, $s6, 124
          lw $t5, 0($t5)
    
          bgt $t5, $t3, pass_input
  
          # Move P2 Diagonally down left 1
          addi $s6, $s6, 124

          # Checking for landed
          lw $t3, BLACK
          addi $t5, $s7, 128
          addi $t4, $s6, 128
          lw $t5, 0($t5)
          lw $t4, 0($t4)
      
          bgt $t5, $t3, landed
          bgt $t4, $t3, landed
          
          jr $ra
  
    after_p2:
  
      # Check if P1 is above P2
      subi $t5, $s7, 128
      beq $t5, $s6, below_p2
      b right_p2
  
        below_p2:
          
          # Checking for collision
          lw $t3, BLACK
          subi $t5, $s7, 132
          lw $t5, 0($t5)
    
          bgt $t5, $t3, pass_input
  
          # Move P1 diagonally up left 1
          subi $s7, $s7, 132

          # Checking for landed
          lw $t3, BLACK
          addi $t5, $s7, 128
          addi $t4, $s6, 128
          lw $t5, 0($t5)
          lw $t4, 0($t4)
      
          bgt $t5, $t3, landed
          bgt $t4, $t3, landed
          
          jr $ra
          
        right_p2:
  
          # Checking for collision
          lw $t3, BLACK
          subi $t5, $s6, 124
          lw $t5, 0($t5)
    
          bgt $t5, $t3, pass_input
          
          # Move p1 diagonally up right
          subi $s6, $s6, 124
          
          # Checking for landed
          lw $t3, BLACK
          addi $t5, $s7, 128
          addi $t4, $s6, 128
          lw $t5, 0($t5)
          lw $t4, 0($t4)
      
          bgt $t5, $t3, landed
          bgt $t4, $t3, landed
          
          jr $ra
          
    jr $ra
  
    key_a:
  
      # Checking for collision
      lw $t3, BLACK
      subi $t5, $s7, 4
      subi $t4, $s6, 4
      lw $t5, 0($t5)
      lw $t4, 0($t4)
  
      bgt $t5, $t3, pass_input
      bgt $t4, $t3, pass_input
      
      subi $s7, $s7, 4
      subi $s6, $s6, 4

      # Checking for landed
      lw $t3, BLACK
      addi $t5, $s7, 128
      addi $t4, $s6, 128
      lw $t5, 0($t5)
      lw $t4, 0($t4)
  
      bgt $t5, $t3, landed
      bgt $t4, $t3, landed
      
      jr $ra
      
    key_s:
       
      
      addi $s7, $s7, 128
      addi $s6, $s6, 128
      
      # Checking for collision
      lw $t3, BLACK
      addi $t5, $s7, 128
      addi $t4, $s6, 128
      lw $t5, 0($t5)
      lw $t4, 0($t4)
  
      bgt $t5, $t3, landed
      bgt $t4, $t3, landed
      
      jr $ra
      
    key_d:
  
      # Checking for collision
      lw $t3, BLACK
      addi $t5, $s7, 4
      addi $t4, $s6, 4
      lw $t5, 0($t5)
      lw $t4, 0($t4)
  
      bgt $t5, $t3, pass_input
      bgt $t4, $t3, pass_input
      
      addi $s7, $s7, 4
      addi $s6, $s6, 4

      # Checking for landed
      lw $t3, BLACK
      addi $t5, $s7, 128
      addi $t4, $s6, 128
      lw $t5, 0($t5)
      lw $t4, 0($t4)
  
      bgt $t5, $t3, landed
      bgt $t4, $t3, landed
      
      jr $ra
end_keyboard_input:

# Function to draw a rectangle
# - $a0 Width of the Rectangle
# - $a1 Height of the Rectangle
# - $a2 Address of Rectangle
# - $a3 Color of Rectangle
draw_rectangle:
  lw $a0, 0($sp)
  pop()
  lw $a1, 0($sp)
  pop()
  lw $a2, 0($sp)
  pop()
  lw $a3, 0($sp)
  pop()

  # Initiate loop variable for the height
  add $t5, $zero, $zero

  # Loop to go through every height of the rectangle
  height_loop:
    
    # Break if reach end of height
    beq $t5, $a1 height_loop_end

    # Initiate loop variable for width
    add $t6, $zero, $zero  

    # Loop to go through the horizontal width of rectangle
    draw_line_loop:
      # Break if reach end of width
      beq $t6, $a0 draw_line_loop_end
      sw $a3, 0($a2) # Paint the block
      addi $a2, $a2, 4 # Move to next space
      addi $t6, $t6, 1 # Add 1 to loop variable
      j draw_line_loop # jump to loop top
    draw_line_loop_end:

    # Translating X pos to memory position
    addi $t7, $zero, 4 # Getting register with 4 in it
    mult $t7, $a0 # Multiplying width by 4
    mflo $t7 # Getting value and putting it into temp register
    
    sub $a2, $a2, $t7  # Move back to starting X pos
    addi $a2, $a2, 128 # Move down 1 line
    addi $t5, $t5, 1 # Add 1 to loop variable
    j height_loop
  height_loop_end:

  jr $ra
draw_rectangle_end:

# Function that will turn an x pos to address
# - $a0 x pos
# - $v0 memeory address
x_pos_to_address:
  lw $a0, 0($sp)
  pop()
  sll $v0, $a0, 2
  jr $ra
x_pos_to_address_end:
  
# Function that will turn an y pos to an address
# - $a0 y pos
# - $v0 memeory address
y_pos_to_address:
  lw $a0, 0($sp)
  pop()
  sll $v0, $a0, 7
  jr $ra
y_pos_to_address_end:

quit:
  li $v0, 10
  syscall
quit_end:

# Run the game.
main:
  
    # Initialize starting location of bitmap
    lw $t0, ADDR_DSPL

    # Creating white color into $t4
    lw $t4, WHITE # Load white into t4
    push() # Push onto the stack
    sw $t4, 0($sp) 
    
    # Creating parameters for draw rectangle function
    lw $t4, BOX_X
    push()
    sw $t4, 0($sp) # First paramater of x_pos_to_address to BOX_X
    jal x_pos_to_address # Run x_pos_to_address
    add $a2, $zero, $v0 # Set $a2 the return value

    lw $t4, BOX_Y
    push()
    sw $t4, 0($sp) # Set Frist parameter of y_pos_to_address to BOX_Y
    jal y_pos_to_address # Run y_pos_to_address
    add $a2, $a2, $v0 # Add return value to $a2

    add $a2, $t0, $a2 # Set 3rd paramater of draw_rectangle to address

    push()
    sw $a2, 0($sp)
    
    addi $a1, $zero, 22 # Set 2nd parameter to 22 for Height
    push()
    sw $a1, 0($sp)
    
    
    addi $a0, $zero, 17 # Set 1st parameter to 17 for Width
    push()
    sw $a0, 0($sp)
    
    jal draw_rectangle


    # Same thing, but drawing black box to create box outline
    # Creating black color into $t4
    lw $t4, BLACK
    push()
    sw $t4, 0($sp)

    # Creating parameters for draw rectangle function
    lw $a0, BOX_X # Get box position
    addi $a0, $a0, 1
    push()
    sw $a0, 0($sp)
    jal x_pos_to_address
    
    add $a2, $zero, $v0

    lw $a0, BOX_Y
    addi $a0, $a0, 1
    push()
    sw $a0, 0($sp)
    jal y_pos_to_address
    add $a2, $a2, $v0

    add $a2, $t0, $a2
    push()
    sw $a2, 0($sp)

    addi $a1, $zero, 20
    push()
    sw $a1, 0($sp)
    
    addi $a0, $zero, 15
    push()
    sw $a0, 0($sp)
    jal draw_rectangle


    # Draw pot neck
    
    # Creating black color into $t4
    lw $t4, WHITE
    push()
    sw $t4, 0($sp)
    
    # Set X pos
    lw $a0, BOX_X
    addi $a0, $a0, 6
    push()
    sw $a0, 0($sp)
    jal x_pos_to_address
    add $a2, $zero, $v0
    add $a2, $t0, $a2
    
    # Set Y pos
    lw $a0, BOX_Y
    subi $a0, $a0, 2
    push()
    sw $a0, 0($sp)
    jal y_pos_to_address
    add $a2, $a2, $v0

    push()
    sw $a2, 0($sp)
    
    addi $a1, $zero, 3
    push()
    sw $a1, 0($sp)
    addi $a0, $zero, 5
    push()
    sw $a0, 0($sp)
    jal draw_rectangle


    # Create black opening at top of Box

    # Creating black color into $t4
    lw $t4, BLACK
    push()
    sw $t4, 0($sp)
    
    # Set X pos
    lw $a0, BOX_X
    addi $a0, $a0, 7
    push()
    sw $a0, 0($sp)
    jal x_pos_to_address
    add $a2, $zero, $v0
    add $a2, $t0, $a2
    
    # Set Y pos
    lw $a0, BOX_Y
    subi $a0, $a0, 2
    push()
    sw $a0, 0($sp)
    jal y_pos_to_address
    add $a2, $a2, $v0
    push()
    sw $a2, 0($sp)
    
    addi $a1, $zero, 3
    push()
    sw $a1, 0($sp)
    addi $a0, $zero, 3
    push()
    sw $a0, 0($sp)
    jal draw_rectangle

    # Draw First capsule
    jal draw_capsule
    jal draw_virus
    jal draw_virus
    jal draw_virus
    
    j game_loop
    
    
game_loop:
    # Clear old capsule
    lw $t5, BLACK
    sw $t5, 0($s7)
    sw $t5, 0($s6)
    
    # 1a. Check if key has been pressed
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t5, 0($t0)                  # Load first word from keyboard
    beq $t5, 1, key_in      # If first word 1, key is pressed
    b pass_input
    
    key_in:
      jal keyboard_input

    b pass_input
      
    pass_input:

	# 2b. Update locations (capsules)
	# 3. Draw the screen

    # Redraw Capsule
    sw $s5, 0($s7)
    sw $s4, 0($s6)
    
    b not_landed
    landed:
      # Redraw Capsule
      sw $s5, 0($s7)
      sw $s4, 0($s6)
      
      jal check_and_delete
      
      jal draw_capsule

      
      j not_landed
    not_landed:
    
	# 4. Sleep
    li $v0, 32
    li $a0, 16
    
    syscall

    # 5. Go back to Step 1
    j game_loop
