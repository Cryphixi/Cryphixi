.globl _start
_start:
    # ========================================
    # LOAD/STORE INSTRUCTIONS TEST
    # ========================================
    
    # Setup: Create a data section in memory
    # We'll use x31 as a base pointer to a memory location
    lui x31, 0x10000        # x31 = 0x10000000 (base address)
    
    # Test sw (store word) and lw (load word)
    addi x5, x0, 1234       # x5 = 1234
    sw x5, 0(x31)           # Store 1234 at address x31+0
    lw x1, 0(x31)           # x1 = load word from x31+0 (should be 1234)
    
    # Test sh (store halfword) and lh (load halfword)
    addi x5, x0, 255        # x5 = 255
    sh x5, 4(x31)           # Store halfword 255 at address x31+4
    lh x2, 4(x31)           # x2 = load halfword from x31+4 (should be 255)
    
    # Test lhu (load halfword unsigned)
    addi x5, x0, -1         # x5 = -1 (0xFFFFFFFF)
    sh x5, 8(x31)           # Store halfword at x31+8 (0xFFFF)
    lhu x3, 8(x31)          # x3 = load halfword unsigned (should be 65535)
    
    # Test sb (store byte) and lb (load byte)
    addi x5, x0, 127        # x5 = 127
    sb x5, 12(x31)          # Store byte at x31+12
    lb x4, 12(x31)          # x4 = load byte from x31+12 (should be 127)
    
    # Test lbu (load byte unsigned)
    addi x5, x0, -1         # x5 = -1
    sb x5, 16(x31)          # Store byte at x31+16 (0xFF)
    lbu x5, 16(x31)         # x5 = load byte unsigned (should be 255)
    
    # Test multiple store/load with offsets
    addi x6, x0, 100        # x6 = 100
    addi x7, x0, 200        # x7 = 200
    addi x8, x0, 300        # x8 = 300
    sw x6, 20(x31)          # Store at offset 20
    sw x7, 24(x31)          # Store at offset 24
    sw x8, 28(x31)          # Store at offset 28
    lw x9, 20(x31)          # x9 = 100
    lw x10, 24(x31)         # x10 = 200
    lw x1, 28(x31)          # x1 = 300
    
    # ========================================
    # JUMP INSTRUCTIONS TEST
    # ========================================
    
    # Test jal (jump and link)
    addi x2, x0, 0          # x2 = 0 (will be used to track execution)
    jal x3, test_jal        # Jump to test_jal, save return address in x3
    addi x2, x2, 1          # x2 = 1 (executed after return)
    jal x0, after_jal       # Jump over the function
    
test_jal:
    addi x4, x0, 42         # x4 = 42 (mark that we were here)
    jalr x0, x3, 0          # Return using jalr (jump to address in x3)
    
after_jal:
    # At this point: x2 = 1, x4 = 42
    
    # Test jalr (jump and link register)
    addi x5, x0, 0          # x5 = 0 (counter)
    la x6, test_jalr        # Load address of test_jalr into x6
    jalr x7, x6, 0          # Jump to address in x6, save return in x7
    addi x5, x5, 10         # x5 = 10 (executed after return)
    jal x0, after_jalr      # Skip over function
    
test_jalr:
    addi x8, x0, 99         # x8 = 99 (mark that we were here)
    jalr x0, x7, 0          # Return to saved address in x7
    
after_jalr:
    # At this point: x5 = 10, x8 = 99
    
    # Test forward jump with jal
    addi x9, x0, 5          # x9 = 5
    jal x10, skip_section   # Jump forward
    addi x9, x9, 100        # This should be skipped
    addi x9, x9, 100        # This should be skipped
    
skip_section:
    addi x9, x9, 1          # x9 = 6 (5 + 1, not 205)
    
    # ========================================
    # U-TYPE INSTRUCTIONS TEST
    # ========================================
    
    # Test lui (load upper immediate)
    lui x1, 305             # x1 = 305 << 12 = 1249280
    
    # Test lui with different values
    lui x2, 1               # x2 = 1 << 12 = 4096
    lui x3, 1048575         # x3 = 1048575 << 12 = 4294963200 (max 20-bit value)
    
    # Combine lui with addi to create full 32-bit values
    lui x4, 1               # x4 = 4096
    addi x4, x4, 2048       # x4 = 4096 + 2048 = 6144
    
    # Test auipc (add upper immediate to PC)
    auipc x5, 0             # x5 = PC (current program counter)
    auipc x6, 1             # x6 = PC + 4096
    auipc x7, 10            # x7 = PC + 40960
    
    # Use auipc to calculate relative addresses
    auipc x8, 0             # x8 = current PC
    addi x9, x8, 16         # x9 = PC + 16 (address 16 bytes ahead)
    
    # Test combining lui and auipc
    lui x10, 256            # x10 = 256 << 12 = 1048576
    auipc x1, 256          # x1 = PC + 1048576
    
    # Test with zero
    lui x2, 0               # x2 = 0
    auipc x3, 0             # x3 = PC
    
    # Final test: use lui to set up a large constant
    lui x4, 4660            # x4 = 4660 << 12 = 19087360
    addi x4, x4, 1311       # x4 = 19087360 + 1311 = 19088671
    
    # Exit (infinite loop for emulator)
    jal x0, _start          # Loop back to start or could use an exit mechanism
