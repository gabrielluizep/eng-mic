;DEFINIÇÕES
.equ BOTAO = PD2
.equ BOTAO2 = PD3
.equ L0 = PB0
.equ L1 = PB1
.def AUX = R16

.ORG 0x0000 ; Reset vector
  RJMP setup

.ORG 0x0002 ; Vetor (endereddço na Flash) da INT0
  RJMP isr_int0 

.ORG 0x0004 ; Vetor (endereddço na Flash) da INT1
  RJMP isr_int1 

.ORG 0x0020 ; Temporizador
  RJMP isr_tc0b

.ORG 0x0034 ; primeira end. livre depois dos vetores
setup:
  ldi R16, 0b00000101 ;TC0 com prescaler de 1024,a 16 MHz gera
  out TCCR0B, R16; uma interrup¸c~aoa cada 16,384 ms13 LDI R16, 114
  sts TIMSK0, R16; habilita int. do TC0B(TIMSK0(0)=TOIE0 <- 1)

  ldi AUX,0x03 ; 0b00000011
  out DDRB,AUX ; configura PB3/2 como saída
  out PORTB,AUX ; desliga os LEDs
  cbi DDRD, BOTAO ; configura o PD2 como entrada
  cbi DDRD, BOTAO2 ; configura o PD3 como entrada
  sbi PORTD, BOTAO ; liga o pull-up do PD2
  sbi PORTD, BOTAO2 ; liga o pull-up do PD2

  LDI AUX, 0b00001010 ;
  STS EICRA, AUX ; config. INT0 sensível a borda
  SBI EIMSK, INT0 ; habilita a INT0
  SBI EIMSK, INT1 ; habilita a INT0

  SEI ; habilita a interrupddção global ...
  ; ... (bit I do SREG)
main:
  rjmp main

;-------------------------------------------------
; Rotina de Interrupddção (ISR) da INT0
;-------------------------------------------------
isr_int0:
  push R16 ; Salva o contexto (SREG)
  in R16, SREG
  push R16

  cbi PORTB,L1 ; liga L1
  
  pop R16 ; Restaura o contexto (SREG)
  out SREG,R16
  pop R16
  reti

;-------------------------------------------------
; Rotina de Interrupddção (ISR) da INT1
;-------------------------------------------------
isr_int1:
  push R16 ; Salva o contexto (SREG)
  in R16, SREG
  push R16

  sbi PORTB,L1 ; desliga L1

  pop R16 ; Restaura o contexto (SREG)
  out SREG,R16
  pop R16
  reti

isr_tc0b:
  ; PUSH R16
  ; IN R16, SREG
  ; PUSH R16

  INC R16
  CPI R16, 62
  BRNE END
  SBI PINB, L0
  LDI R16, 0

  END:
    ; POP R16
    ; OUT SREG, R16
    ; POP R16 
    RETI
