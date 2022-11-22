;DEFINIÇõES
.equ BOTAO = PD2
.equ L0 = PB0
.equ L1 = PB1
.def AUX = R16

.ORG 0x0000 ; Reset vector
  RJMP setup

.ORG 0x0002 ; Vetor (endereÇo na Flash) da INT0
  RJMP isr_int0 

.ORG 0x0034 ; primeira end. livre depois dos vetores
setup:
  ldi AUX,0x03 ; 0b00000011
  out DDRB,AUX ; configura PB3/2 como sa´ıda
  out PORTB,AUX ; desliga os LEDs
  cbi DDRD, BOTAO ; configura o PD2 como entrada
  sbi PORTD, BOTAO ; liga o pull-up do PD2

  LDI AUX, 0x01 ;
  STS EICRA, AUX ; config. INT0 sens´ıvel a borda
  SBI EIMSK, INT0 ; habilita a INT0

  SEI ; habilita a interrupção global ...
  ; ... (bit I do SREG)
main:
  sbi PORTB,L0 ; desliga L0
  ldi r19, 80
  rcall delay ; delay 1s
  cbi PORTB,L0 ; liga L0
  ldi r19, 80
  rcall delay ; delay 1s
  rjmp main

;-------------------------------------------------
; Rotina de Interrupção (ISR) da INT0
;-------------------------------------------------
isr_int0:
  push R16 ; Salva o contexto (SREG)
  in R16, SREG
  push R16

  sbic PIND,BOTAO ; botao press. salta a próxima inst.
  rjmp desliga
  cbi PORTB,L1 ; liga L1
  rjmp fim

desliga:
  sbi PORTB,L1 ; desliga L1

fim:
pop R16 ; Restaura o contexto (SREG)
out SREG,R16
pop R16
reti ; retorna da interrupcao

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