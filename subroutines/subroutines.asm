.EQU ADJUST_BUTTON = PB0
.EQU SELECTION_BUTTON = PB1

.DEF AUX_REG = R16
.DEF DELAY_REG = R19

MAIN:
  RCALL SETUP

START:

ADJUST_VALIDATOR:
  SBIS PINB, ADJUST_BUTTON
  RCALL ROTATE_RIGHT

SELECTION_VALIDATION:
  SBIS PINB, SELECTION_BUTTON
  RCALL ROTATE_LEFT
  RJMP START

;;; SUBROUTINES

; Rotate LEDs to the right
ROTATE_RIGHT:
  RCALL SAVE
  
  LDI DELAY_REG, 16
  ; Clear carry flag
  CLC
  RIGHT_LOOP:
  ; Rotate LEDs to the left and delays
  LD AUX_REG, PORTD
  ROR AUX_REG
  ST AUX_REG, PORTD
  RCALL DELAY
  ; If carry flag is set, jump to the beginning of the loop
  BRBS 0, RIGHT_LOOP
  
  RCALL RESTORE
  RET

; Rotate LEDs to the left
ROTATE_LEFT:
  RCALL SAVE
  
  LDI DELAY_REG, 80
  ; Clear carry flag
  CLC
  LEFT_LOOP:
  ; Rotate LEDs to the left and delays
  LD AUX_REG, PORTD
  ROL AUX_REG
  ST AUX_REG, PORTD
  RCALL DELAY
  ; If carry flag is set, jump to the beginning of the loop
  BRBS 0, LEFT_LOOP
  
  RCALL RESTORE
  RET

; Save current state of the microcontroller on the SRAM
SAVE:

  RET

; Restore the state of the microcontroller from the SRAM
RESTORE:

  RET

; Setup the GPIO pinout
SETUP:
  ; Sets PORTD as output
  LDI AUX_REG,0xFF
  OUT DDRD,AUX_REG

  ; Sets PORTB as input
  LDI AUX_REG, 0x00
  OUT DDRB, AUX_REG

  ; Enable pull-up to PORTD
  LDI AUX_REG,0xFF
  OUT PORTD,AUX_REG

  ; Enable pull-up to PORTB
  LDI AUX_REG, 0xFF
  OUT PORTB, AUX_REG
  
  RET

; Delay subroutine
; DELAY_REG is used to configure the delay
; DELAU_REG = 16 => 200ms
; DELAU_REG = 80 => 1000ms
DELAY:
  PUSH R17
  PUSH R18
  IN R17, SREG
  PUSH R17

  CLR R17
  CLR R18

  DELAY_LOOP:
  DEC R17
  BRNE DELAY_LOOP
  DEC R18
  BRNE DELAY_LOOP
  DEC DELAY_REG
  BRNE DELAY_LOOP

  POP R17
  OUT SREG, R17
  POP R18
  POP R17 

  RET