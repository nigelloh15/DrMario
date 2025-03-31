################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Nigel Loh, 1009837713
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
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

BOX_BOTTOM_LEFT:
  .word 0x10008e10

PILL_POS1:
  .word 0x1000832C
  
PILL_POS2:
  .word 0x100083AC

SPEED:
  .space 4
GRAVITY_ROUND:
  .space 4
  
PITCHES:
    .word 76,76,76, 0,72,76,79, 0,67,0,   # ^E ^E ^E (rest) ^C ^E ^G (rest) G
          72,0, 67,0, 64, 0,                   # ^C G E (rest)
          69,71,70,69, 0,                # A B Bb A (rest)
          67,76,79,81, 0,                # G ^E ^G ^A (rest)
          77,79,76,72,74,71, 0,          # ^F ^G ^E ^C ^D B (rest)
          
          # Repeat Section with rests
          72,67,64, 0,                   # ^C G E (rest)
          69,71,70,69, 0,                # A B Bb A (rest)
          67,76,79,81, 0,                # G ^E ^G ^A (rest)
          77,79,76,72,74,71, 0,          # ^F ^G ^E ^C ^D B (rest)
          
          # Bridge with phrase pauses
          79,78,77,74,76, 0,             # ^G ^F# ^F ^D ^E (rest)
          67,69,72, 0,                   # G A ^C (rest)
          69,72,74, 0,                   # A ^C ^D (rest)
          79,78,77,74,76, 0,             # ^G ^F# ^F ^D ^E (rest)
          84,84,84, 0,                   # *C *C *C (rest)
          
          # Final Section with cadence
          72,72,72, 0,                   # ^C ^C ^C (rest)
          72,74,76,72,69,67, 0,          # ^C ^D ^E ^C A G (rest)
          72,72,72, 0,                   # ^C ^C ^C (rest)
          72,74,76, 0,                   # ^C ^D ^E (rest)
          
          # Coda with final rest
          67,64,60, 0                   # G E C (rest)

DURATION:
    .word 167,167,167,83,333,333,333,667,333,  # Triplets + 32nd rest + quarters
          333,333, 333,333, 667, 83,                  # Quarters + eighth rest
          333,333,333,667, 83, 
          333,333,333,667, 83,
          333,333,333,333,333,667, 83,
          
          # Repeat durations
          333,333,667, 83,
          333,333,333,667, 83,
          333,333,333,667, 83,
          333,333,333,333,333,667, 83,
          
          # Bridge timing
          333,333,333,333,667, 83,
          333,667,667, 83,
          667,667,667, 83,
          333,333,333,333,667, 83,
          500,500,500, 83,
          
          # Final section
          167,167,167, 83,
          333,333,333,333,333,667, 83,
          167,167,167, 83,
          500,500,500, 83,
          
          # Coda
          500,500,1000, 500,
          
PITCH_COUNT:
  .space 4

PLAY:
  .space 4

MARIO: .word
    0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x795548, 0x000000,
    0x000000, 0x000000, 0x000000, 0x000000, 0x795548, 0x795548, 0x795548, 0x795548, 0x795548, 0x9E9E9E, 0xFFFFFF, 0x795548, 0x000000,
    0x000000, 0x000000, 0x000000, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x9E9E9E, 0xFFFFFF, 0x000000, 0x000000,
    0x000000, 0x000000, 0x000000, 0x795548, 0x795548, 0x795548, 0xFFCC80, 0xFFCC80, 0x000000, 0xFFCC80, 0x000000, 0x000000, 0x000000,
    0x000000, 0x000000, 0x795548, 0xFFCC80, 0x795548, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000,
    0x000000, 0x000000, 0x795548, 0xFFCC80, 0x795548, 0x795548, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000, 0xFFCC80, 0xFFCC80, 0xFFCC80,
    0x000000, 0x000000, 0x795548, 0x795548, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000,
    0x000000, 0x000000, 0x000000, 0x000000, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0xFFCC80, 0x000000, 0x000000,
    0x000000, 0x000000, 0x000000, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0xFFFFFF, 0xF44336, 0xF44336, 0x000000, 0x000000, 0x000000, 0x000000,
    0x000000, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0xF44336, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x000000,
    0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF,
    0x607D8B, 0x607D8B, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0x607D8B, 0xFFFFFF, 0xFFFFFF, 0x607D8B, 0x607D8B,
    0x9E9E9E, 0x9E9E9E, 0x9E9E9E, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x9E9E9E, 0x9E9E9E, 0x9E9E9E,
    0x9E9E9E, 0x9E9E9E, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x9E9E9E, 0x9E9E9E,
    0x000000, 0x000000, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x000000, 0x000000,
    0x000000, 0x000000, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x000000, 0x000000, 0x000000, 0x3F51B5, 0x3F51B5, 0x3F51B5, 0x000000, 0x000000,
    0x000000, 0x795548, 0x795548, 0x795548, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x795548, 0x795548, 0x795548, 0x000000,
    0x795548, 0x795548, 0x795548, 0x795548, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x795548, 0x795548, 0x795548, 0x795548
    
MARIO_START:
  .word 0x100086CC

PAUSED_WORD:
  .word
  0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0x000000,
  0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0x000000, 0x000000, 0xffffff, 0x000000, 0x000000, 0x000000, 0xffffff, 0x000000, 0xffffff,
  0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0x000000, 0x000000, 0xffffff, 0x000000, 0xffffff,
  0xffffff, 0x000000, 0x000000, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0x000000, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0x000000, 0x000000, 0xffffff, 0x000000, 0xffffff,
  0xffffff, 0x000000, 0x000000, 0x000000, 0xffffff, 0x000000, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0xffffff, 0x000000, 0xffffff, 0xffffff, 0x000000,

PAUSE_LOCATION:
  .word 0x10008090

NEXT_PILL_LOCATION:
  .word 0x10008464

# Place to store links of pills
LINKS:
  .space 4096

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

draw_paused:

  push()
  sw $ra, 0($sp)

  jal play_sound

  la $t3, PAUSED_WORD
  lw $t4, PAUSE_LOCATION

  li $t1, 0
  draw_paused_column:
    beq $t1, 5, draw_paused_column_end
    
    li $t2, 0
    draw_paused_row:
      beq $t2, 23, draw_paused_row_end

      lw $t5, 0($t3)
      sw $t5, 0($t4)

      addi $t3, $t3, 4
      addi $t4, $t4, 4
      
      addi $t2, $t2, 1
      j draw_paused_row
    draw_paused_row_end:

    subi $t4, $t4, 92
    addi $t4, $t4, 128
    addi $t1, $t1, 1
    j draw_paused_column
  draw_paused_column_end:

  lw $ra, 0($sp)
  pop()
  jr $ra
draw_paused_end:

remove_paused:
  
  lw $t4, PAUSE_LOCATION
  
  li $t1, 0
  remove_paused_column:
    beq $t1, 5, remove_paused_column_end
    
    li $t2, 0
    remove_paused_row:
      beq $t2, 23, remove_paused_row_end

      sw $zero, 0($t4)

      addi $t3, $t3, 4
      addi $t4, $t4, 4
      
      addi $t2, $t2, 1
      j remove_paused_row
    remove_paused_row_end:

    subi $t4, $t4, 92
    addi $t4, $t4, 128
    addi $t1, $t1, 1
    j remove_paused_column
  remove_paused_column_end:

  jr $ra
remove_paused_end:

# Play sound
play_sound:
  li $v0, 31
  li $a0, 60
  li $a1, 100
  li $a2, 10
  li $a3, 50
  syscall
  jr $ra
play_sound_end:

# Gravity Function
gravity:

  addi $s7, $s7, 128
  addi $s6, $s6, 128

  addi $t1, $s7, 128
  addi $t2, $s6, 128

  lw $t1, 0($t1)
  lw $t2, 0($t2)

  bne $t1, $zero, landed  
  bne $t2, $zero, landed  

  jr $ra
end_gravity: 

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

      # Removing Link
      la $t5, LINKS
      lw $t4, ADDR_DSPL

      sub $t4, $a0, $t4
      add $t5, $t5, $t4

      lw $t6, 0($t5)

      # Setting link to zero
      sw $zero, 0($t5)

      # Checking if virus or no link
      li $t3, -1
      beq $t6, $t3, row_no_link
      beq $t6, $zero, row_no_link

      row_link:

        # Going to linked element and setting it to zero
        add $t5, $t5, $t6
        sw $zero, 0($t5)

      row_no_link:
      
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

      # Removing Link
      la $t5, LINKS
      lw $t4, ADDR_DSPL

      sub $t4, $a0, $t4
      add $t5, $t5, $t4

      lw $t6, 0($t5)

      # Setting link to zero
      sw $zero, 0($t5)
      
      # Checking if it is a virus or has no link   
      li $t3, -1
      beq $t6, $zero, column_no_link
      beq $t6, $t3, column_no_link

      column_link:

        # Going to linked element and setting it to zero
        add $t5, $t5, $t6
        sw $zero, 0($t5)

      column_no_link:
        
      addi $a0, $a0, 128
      addi $t1, $t1, 1
      
      j delete_column_loop
    delete_column_loop_end:

    jr $ra
delete_column_end:

# Function to drop the blocks above
# - $v0 - 1 if dropped something
drop:

  push()
  sw $ra, 0($sp)
  
  lw $t0, BOX_BOTTOM_LEFT
  # Move up one row as bottom row doesnt need to drop
  subi $t0, $t0, 128

  li $t1, 0
  li $s0, 0
  drop_column_loop:
    beq $t1, 19, drop_column_loop_end

    li $t2, 0
    drop_row_loop:
      beq $t2, 15, drop_row_loop_end

      # Don't drop if it is black on that pixel
      lw $t5, 0($t0)
      beq $t5, $zero, no_drop
      
      # Get links
      la $t9, LINKS
      lw $t8, ADDR_DSPL

      # Get corresponding link
      sub $t6, $t0, $t8
      add $t6, $t9, $t6

      # Get value of link
      lw $t5, 0($t6)

      # If virus don't drop
      beq $t5, -1, no_drop
      
      # If there is something below it
      addi $t4, $t0, 128
      lw $t7, 0($t4)
      bne $t7, $zero, something_below
      b nothing_below

      something_below:
        
        # Check if its the linked pixel
        add $t7, $t0, $t5
        bne $t7, $t4, no_drop

      nothing_below:

      # Get linked pixel
      add $t7, $t0, $t5
      # Get pixel below linked one
      addi $t7, $t7, 128

      # If not black don't drop
      lw $t8, 0($t7)
      bne $t8, $zero, no_drop

      # Move back to linked pixel
      subi $t7, $t7, 128

      drop_one:

        # Add one to drop count
        addi $s0, $s0, 1

        # Drop blocks visually
        lw $t3, 0($t0)
        lw $t4, 0($t7)

        sw $zero, 0($t0)
        sw $zero, 0($t7)

        addi $t0, $t0, 128
        addi $t7, $t7, 128

        sw $t3, 0($t0)
        sw $t4, 0($t7)

        # Drop links
        
        # Get linked pixel
        add $t7, $t6, $t5
        
        lw $t3, 0($t6)
        lw $t4, 0($t7)
        
        sw $zero, 0($t6)
        sw $zero, 0($t7)

        addi $t6, $t6, 128
        addi $t7, $t7, 128

        sw $t3, 0($t6)
        sw $t4, 0($t7)
        
      no_drop:
        
      # Go to next item in row
      addi $t0, $t0, 4

      # Iterate to +1 $t2
      addi $t2, $t2, 1
      j drop_row_loop
    drop_row_loop_end:

    # Go up to next row
    # Go back to 0th item
    subi $t0, $t0, 60 # (15 * 4)
    # Go up to next row
    subi $t0, $t0, 128

    # Iterate to +1 $t1
    addi $t1, $t1, 1
    j drop_column_loop
  drop_column_loop_end:

  beq $s0, $zero, nothing_dropped

  some_dropped:

    jal drop

  nothing_dropped:
    
  lw $ra, 0($sp)
  pop()

  jr $ra
drop_end:

# Check Delete & Drop

check_delete_and_drop:

  # Push register onto stack
  push()
  sw $ra, 0($sp)

  # Get bottom left corner
  lw $t0, BOX_BOTTOM_LEFT

  # Delete Counter
  li $t5, 0
  
  li $t1, 0
  check_delete_drop_column:
    beq $t1, 20, check_delete_drop_column_end

    # Save loop variable
    push()
    sw $t1, 0($sp)

    li $t2, 0
    check_delete_drop_row:
      beq $t2, 15, check_delete_drop_row_end

      # Save loop variable
      push()
      sw $t2, 0($sp)
      
      # Save counter
      push()
      sw $t5, 0($sp)

      push()
      sw $t0, 0($sp)

      jal check_and_delete

      lw $t5, 0($sp)
      pop()

      add $t5, $t5, $v0

      # Move pointer
      addi $t0, $t0, 4
      
      # Get loop variable back
      lw $t2, 0($sp)
      pop()
      
      addi $t2, $t2, 1
      j check_delete_drop_row
    check_delete_drop_row_end:

    # Move pointer back to start column
    subi $t0, $t0, 60

    # Move pointer up one row
    subi $t0, $t0, 128
    
    # Get loop variable back
    lw $t1, 0($sp)
    pop()

    addi $t1, $t1, 1
    j check_delete_drop_column
  check_delete_drop_column_end:

  beq $t5, $zero, no_drop_needed
  drop_needed:
    
    jal drop 
    jal check_delete_and_drop
    
  no_drop_needed:


  lw $ra 0($sp)
  pop()
  
  jr $ra 
check_delete_and_drop_end:

# Function to check for line of 4 of the same color and delete
# - $a0 - Location of pixel
# - $v0 - 1 if deletion, 0 if no deletion
check_and_delete:

  # Variable to check if deleted anything
  li $s1, 0

  # Get location of pixel
  lw $a0, 0($sp)
  pop()

  # Check & Delete for Pixel 1 Row
  push()
  sw $ra, 0($sp)

  # Get color of pixel
  lw $t5, 0($a0)
  # Check if pixel is black
  beq $t5, $zero, black_check 
  
  # Put locatin of pixel back
  push()
  sw $a0, 0($sp)

  push()
  sw $t5, 0($sp)
  
  push()
  sw $a0, 0($sp)

  jal check_row

  addi $t1, $zero, 4
  blt $v1, $t1, p1_no_more_delete_row

  p1_delete_a_row:
    
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  jal delete_row

  # Need to recurse
  addi $s1, $s1, 1
  
  p1_no_more_delete_row:

  # Check & Delete for Pixel 1 Column

  # Get pixel location back
  lw $a0, 0($sp)
  pop()

  # Get color of pixel
  lw $t5, 0($a0)
  
  push()
  sw $t5, 0($sp)
  
  push()
  sw $a0, 0($sp)

  jal check_column
  
  addi $t1, $zero, 4
  blt $v1, $t1, p1_no_more_delete_column

  p1_delete_a_column:
    
  push()
  sw $v1, 0($sp)
  push()
  sw $v0, 0($sp)

  jal delete_column
  
  # Need to recurse
  addi $s1, $s1, 1

  p1_no_more_delete_column:

  add $v0, $zero, $s1

  la $t5, SPEED
  lw $t4, 0($t5)
  sll $s1, $s1, 2
  sub $t4, $t4, $s1
  bgt $t4, 15, not_min_speed

  min_speed_reached:

    li $t4, 15

  not_min_speed:

  sw $t4, 0($t5)

  black_check:
  
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

  # Add Virus to the links board
  la $t1, LINKS
  lw $t2, ADDR_DSPL
  sub $t3, $t5, $t2
  add $t1, $t1, $t3

  addi $t3, $zero, -1
  sw $t3, 0($t1)
  
  jr $ra
draw_viruses_end:

draw_pre_capsule:

  lw $t1, NEXT_PILL_LOCATION
  addi $t2, $t1, 128
  
  # Get Random Color of 3
  li $v0, 42
  li $a0, 0
  li $a1, 3
  syscall
  beq $a0, 0, p1_col_0
  beq $a0, 1, p1_col_1
  beq $a0, 2, p1_col_2
  
  p1_col_0:
    lw $t3, P_BLUE
    b p1_done_col
  p1_col_1:
    lw $t3, P_PINK
    b p1_done_col
  p1_col_2:
    lw $t3, P_PURP
    b p1_done_col
  p1_done_col:
  sw $t3, 0($t1)

  
  # Get Random Color of 3
  li $v0, 42
  li $a0, 0
  li $a1, 3
  syscall
  beq $a0, 0, p2_col_0
  beq $a0, 1, p2_col_1
  beq $a0, 2, p2_col_2
  
  p2_col_0:
    lw $t3, P_BLUE
    b p2_done_col
  p2_col_1:
    lw $t3, P_PINK
    b p2_done_col
  p2_col_2:
    lw $t3, P_PURP
    b p2_done_col
  p2_done_col:
  sw $t3, 0($t2)

  jr $ra
draw_pre_capsule_end:

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
  
  lw $t1, NEXT_PILL_LOCATION
  addi $t2, $t1, 128

  lw $s5, 0($t1)
  lw $s4, 0($t2)

  sw $s5, 0($s7)
  sw $s4, 0($s6)

  jr $ra
end_draw_capsule:

# Keyboard Input Function
keyboard_input:             # A key is pressed
    push()
    sw $ra, 0($sp)
    
    lw $a0, 4($t0)          # Load second word from keyboard
    beq $a0, 0x71, quit     # Check if the key q was pressed
    beq $a0, 0x77, key_w     # Check if the key w was pressed
    beq $a0, 0x61, key_a     # Check if the key a was pressed
    beq $a0, 0x73, key_s     # Check if the key s was pressed
    beq $a0, 0x64, key_d     # Check if the key d was pressed
    beq $a0, 0x70, key_p     # Check if the key p was pressed

    li $v0, 1               # ask system to print $a0
    syscall

    lw $ra, 0($sp)
    pop()
    
    jr $ra

  key_p:
    
    jal draw_paused

    key_p_loop:
      # 1a. Check if key has been pressed
      lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
      lw $a0, 4($t0)
      beq $a0, 0x63, key_p_loop_end

      j key_p_loop
    key_p_loop_end:

    jal remove_paused

    lw $ra, 0($sp)
    pop()
    jr $ra
  key_p_end:
  
  # 1b. Check which key has been pressed
  key_w:
    
    jal play_sound
  
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
          
          lw $ra, 0($sp)
          pop()
          
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

          lw $ra, 0($sp)
          pop()
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
          
          lw $ra, 0($sp)
          pop()
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
          
          lw $ra, 0($sp)
          pop()
          jr $ra
          
    jr $ra
  
    key_a:
      
      jal play_sound
  
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
      
      lw $ra, 0($sp)
      pop()
      jr $ra
      
    key_s:
       
      jal play_sound
      
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
     
      lw $ra, 0($sp)
      pop()

      jr $ra
      
    key_d:


      jal play_sound
  
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

      lw $ra, 0($sp)
      pop()
      
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
  
    # Draw Dr. Mario
    lw $t1, MARIO_START
    la $t4, MARIO

    li $t5, 0
    li $t2, 0
    mario_column_loop:
      beq $t2, 18, mario_column_loop_end

      li $t3, 0
      mario_row_loop:
        beq $t3, 13, mario_row_loop_end

        lw $t5, 0($t4)
        sw $t5, 0($t1)
        
        addi $t1, $t1, 4
        addi $t4, $t4, 4
        
        addi $t3, $t3, 1

        j mario_row_loop
      mario_row_loop_end:

      subi $t1, $t1, 52
      addi $t1, $t1, 128
      
      addi $t2, $t2, 1

      j mario_column_loop
    mario_column_loop_end:
      
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
    jal draw_pre_capsule
    jal draw_capsule
    jal draw_pre_capsule
    jal draw_virus
    jal draw_virus
    jal draw_virus

    # Gravity speed
    la $t1, SPEED
    li $t2, 60
    sw $t2, 0($t1)

    # Gravity loop variable
    la $t1, GRAVITY_ROUND
    li $t2, 0
    sw $t2, 0($t1)

    # Pitch and Duration
    la $t3, PITCH_COUNT
    li $t4, 0
    sw $t4, 0($t3)

    # Play constant
    la $t1, PLAY
    li $t2, 0
    sw $t2, 0($t1)
    
    j game_loop
    
    
game_loop:

    la $t6, PLAY
    la $t2, DURATION
    lw $t7, 0($t6)

    sll $t9, $t7, 2
    add $t2, $t2, $t9
    lw $t8, 0($t2)
    srl $t8, $t8, 4
    
    blt $t7, $t8, sound_end
    sound:
    # Sound
    la $t1, PITCHES
    la $t2, DURATION

    la $t3, PITCH_COUNT

    lw $t5, 0($t3)

    add $t1, $t1, $t5
    lw $t1, 0($t1)
    
    add $t2, $t2, $t5
    lw $t2, 0($t2)

    li $v0, 31
    add $a0, $t1, $zero
    add $a1, $t2, $zero
    li $a2, 0
    li $a3, 50
    syscall

    addi $t5, $t5, 4

    li $t7, 0

    blt $t5, 392, no_reset_counter

    li $t5, 0

    no_reset_counter:
    
    sw $t5, 0($t3)

    sound_end:

    addi $t7, $t7, 1
    sw $t7, 0($t6)

    
	# 4. Sleep
    li $v0, 32
    li $a0, 16
    
    syscall
    
    # Clear old capsule
    lw $t5, BLACK
    sw $t5, 0($s7)
    sw $t5, 0($s6)

    la $t3, GRAVITY_ROUND
    lw $t1, 0($t3)
    
    # Get speed constant
    la $t2, SPEED
    lw $t2, 0($t2)
    blt $t1, $t2, no_gravity_round
    
    gravity_round:
      jal gravity
      li $t1, 0
    no_gravity_round:
      
    addi $t1, $t1, 1

    sw $t1, 0($t3)
    
    
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

      # Adding links to linkboard
      
      la $t1, LINKS
      lw $t2, ADDR_DSPL

      sub $t3, $s6, $t2
      sub $t4, $s7, $t2

      # Getting link address
      add $t3, $t1, $t3
      add $t4, $t1, $t4

      # Getting distance to other linked pixel
      sub $t5, $s7, $s6
      sub $t6, $s6, $s7

      # Linking pixels
      sw $t5, 0($t3)
      sw $t6, 0($t4)


      jal check_delete_and_drop
      jal draw_capsule
      jal draw_pre_capsule
      
      j not_landed
    not_landed:
    

    # 5. Go back to Step 1
    j game_loop
