.EQU BUTTON = PD2
.DEF AUX = R16

.DSEG
.ORG SRAM_START
  A1: .BYTE 6
 
.CSEG

;------------------------------------------------------------
; TODO: FIX IO PORTS SETUP
;------------------------------------------------------------
SETUP:
; Sets PORTB as output
LDI AUX,0xFF
OUT DDRB,AUX
  
; Sets PD2 as input
LDI AUX, 0b11111011
OUT DDRB, AUX
  
; Enable pull-up to PORTD
LDI AUX, 0xFF
OUT PORTB, AUX

INTIALIZE_SRAM:
LDI AUX, 0b00000001
LDI XH, HIGH(A1)
LDI XL, LOW(A1)

SRAM_LOOP:
  ST X+, AUX
  ROL AUX
  CPI AUX, 0b00000001
  RJMP INTIALIZE_SRAM


;------------------------------------------------------------
; MAIN LOOP
;------------------------------------------------------------
START:
  ; Turn off all LEDs
  LDI AUX, 0xFF
  OUT PORTB, AUX


  BUTTON_PRESSED:

  

; If BUTTON is pressed turn on LEDs
BUTTON_PRESSED:
  SBIC PIND, BUTTON
  RJMP START
  LDI AUX, 0x00
  OUT PORTB, AUX

  
  RJMP START