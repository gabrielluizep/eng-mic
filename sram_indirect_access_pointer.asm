.DSEG
.ORG SRAM_START
  A: .BYTE 1
  B: .BYTE 1
  C: .BYTE 1
 
.CSEG
START:

  ; Carrega A para X
  LDI XH, HIGH(A)
  LDI XL, LOW(A)
   
  LD R0, X+
  LD R1, X+
   
  ADD R0, R1
  
  ST X+, R0
   
  RJMP START