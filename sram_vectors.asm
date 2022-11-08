.DSEG
.ORG SRAM_START
  A1: .BYTE 12
  A2: .BYTE 12
  A3: .BYTE 12
  A4: .BYTE 4
 
.CSEG
START:
  ; Initialize counter with 1
  LDI R16, 1

  ; Set X to point to A2
  LDI XH, HIGH(A2)
  LDI XL, LOW(A2)

  ; Set Y to point to A3
  LDI YH, HIGH(A3)
  LDI YL, LOW(A3)
  
  LDI R17, 13
  
  LOOP1:
    ; Store counter in A2
    ST X+, R16

    ; Store counter in A3
    ST Y+, R16

    ; Increment counter
    INC R16
    
    ; If counter == 13 break loop
    CPSE R16, R17
    
    ; Jump back to LOOP1
    RJMP LOOP1
  
  ; Set X to point to A2
  LDI XH, HIGH(A2)
  LDI XL, LOW(A2)

  ; Set Y to point to A4
  LDI YH, HIGH(A4)
  LDI YL, LOW(A4)

  ; Set Z to point to A1
  LDI ZH, HIGH(A1)
  LDI ZL, LOW(A1)

  ; Set R16 to 1 to begin counting
  LDI R16, 1

  LOOP2:
    ; Load A2 into R16
    LD R18, X+

    ; Load A3 into R17
    LD R19, -Y

    ; Add A2 and A3
    ADD R18, R19

    ; Store result in A1
    ST Z+, R18

    ; Increment counter
    INC R16
    
    ; If A2 == 13 break loop
    CPSE R16, R17
    
    ; Jump back to LOOP2
    RJMP LOOP2

  ; Set X to point to A2
  LDI ZH, HIGH(A2)
  LDI ZL, LOW(A2)

  ; Set Y to point to A4
  LDI YH, HIGH(A3)
  LDI YL, LOW(A3)

  ; Set Z to point to A1
  LDI XH, HIGH(A4)
  LDI XL, LOW(A4)

  ; Sum of A2[2] and A3[3]
  LDD R16, Z+2
  LDD R18, Y+3
  
  ADD R16, R18
  
  ; Store in A4[0]
  ST X+, R16 

  ; Sum of A2[4] and A3[6]
  LDD R16, Z+4
  LDD R18, Y+6
  
  ADD R16, R18
  
  ; Store in A4[1]
  ST X+, R16 

  ; Sum of A2[7] and A3[5]
  LDD R16, Z+7
  LDD R18, Y+5
  
  ADD R16, R18
  
  ; Store in A4[2]
  ST X+, R16
  
  ; Sum of A2[9] and A3[11]
  LDD R16, Z+9
  LDD R18, Y+11
  
  ADD R16, R18
  
  ; Store in A4[1]
  ST X+, R16

RJMP START
  
