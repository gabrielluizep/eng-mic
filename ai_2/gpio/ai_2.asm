.EQU BUTTON = PD2
.DEF AUX = R16
.DEF COUNTER = R17

.DSEG
.ORG SRAM_START
  A1: .BYTE 6
 
.CSEG

;------------------------------------------------------------
; TODO: FIX IO PORTS SETUP
;------------------------------------------------------------
SETUP:
LDI AUX,0xFF

; Sets PORTB as output
OUT DDRB,AUX
; Enable pull-up to PORTD
OUT PORTD, AUX
  
; Sets PD2 as input
LDI AUX, 0x00
OUT DDRD, AUX

INTIALIZE_SRAM:
LDI AUX, 0b00000001
LDI XH, HIGH(A1)
LDI XL, LOW(A1)
LDI COUNTER, 0b01000000

SRAM_LOOP:
  ST X+, AUX
  ROL AUX
  CPSE AUX, COUNTER
  RJMP SRAM_LOOP

LDI XH, HIGH(A1)
LDI XL, LOW(A1)

; MAIN LOOP
START:

BUTTON_PRESSED:
  ; Se pressionado liga o proximo LED
  SBIC PIND, BUTTON
  RJMP START
  ; Pega valor em X
  ; PROBLEMA acessa posição maior que o vetor
  LD AUX, X+
  ; Ligar LED
  OUT PORTB, AUX
  STILL_PRESSED:
    ; Se ainda estiver pressionado, espera
    SBIS PIND, BUTTON
    RJMP STILL_PRESSED
  
RJMP START