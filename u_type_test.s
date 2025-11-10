.globl _start
_start:
    # ========================================
    # U-TYPE INSTRUCTIONS TEST
    # ========================================
    
    # Test lui (load upper immediate)
    lui x1, 1               # x1 = 1 << 12 = 4096
    lui x2, 5               # x2 = 5 << 12 = 20480
    lui x3, 10              # x3 = 10 << 12 = 40960
    
    # Test lui with zero
    lui x4, 0               # x4 = 0
    
    # Test lui with larger value
    lui x5, 100             # x5 = 100 << 12 = 409600
    
    # Test auipc (add upper immediate to PC)
    auipc x6, 0             # x6 = PC
    auipc x7, 1             # x7 = PC + 4096
    auipc x8, 5             # x8 = PC + 20480
    
    # Combine lui with addi
    lui x9, 1               # x9 = 4096
    addi x9, x9, 100        # x9 = 4096 + 100 = 4196
    
    # Combine auipc with addi
    auipc x10, 0            # x10 = PC
    addi x10, x10, 8        # x10 = PC + 8
    
    # Test lui with different values
    lui x1, 50              # x1 = 50 << 12 = 204800
    lui x2, 200             # x2 = 200 << 12 = 819200
    
    # Exit (infinite loop)
    jal x0, _start
