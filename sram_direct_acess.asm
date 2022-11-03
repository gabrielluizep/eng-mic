.DSEG
.ORG SRAM_START
  A: .BYTE 1
  B: .BYTE 1
  C: .BYTE 1
 
.CSEG
START:
  ; Carrega 1 para A
  LDI R16, 1
  STS A, R16
    
  ; Carrrega 2 para B
  LDI R16, 2
  STS B, R16
    
  ; Carrrega 2 para B
  LDI R16, 255
  STS C, R16
    
  ; C = A + B
  LDS R0, A
  LDS R1, B
  ADD R0, R1
  STS C, R0
    
  RJMP START
    