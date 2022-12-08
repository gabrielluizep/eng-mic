.ORG 0x0000 ; Reset vector
  RJMP setup

.ORG 0x0002 ; INT0 Vector (PD2)
  RJMP isr_int0 

.ORG 0x0020 ; Timer
  RJMP isr_tc0b

.ORG 0x0034 ; End
      
setup:
    ; Configura interrupção timer
    ldi R16, 0b00000101 ; TC0 com prescaler de 1024,a 16 MHz gera
    out TCCR0B, R16     ; uma interrupção cada 16,384 ms13 LDI R16, 114
    sts TIMSK0, R16     ; habilita int. do TC0B(TIMSK0(0)=TOIE0 <- 1)

    ; Configura interrupção botão
    LDI R20, 0b00001010 
    STS EICRA, R20      ; config. INT0 sensível a borda
    SBI EIMSK, INT0     ; habilita a INT0

    ; Habilita interrupção global
    SEI
    
    ; Configura PD4 como saída
    SBI DDRD, PD4

    ; Configura a PD2 como entrada com o pull-up ativo
    cbi DDRD, PD2
    sbi PORTD, PD2

    ; Inicializa o SSD
    sbi DDRC, PC4	      ; Configura PC5 (segmento G) como saída ...
    sbi PORTC, PC4	    ; ... e apaga 
    sbi DDRC, PC5	      ; Configura PC6 (DP) como saída ...
    sbi PORTc, PC5	    ; ... e apaga 
    
    ldi R17,0xFF	  
    out DDRB, R17	      ; configura PBx como saída ...
    out PORTB, R17	    ; ... e apaga os segmentos do display
    
    clr r16
    clr r17

main: 
  rjmp main    

; Reseta o valor do display e mostra
isr_int0:
  CLR R16
  RCALL ssd_decode
  RETI

isr_tc0b:
  INC R21
  CPI R21, 123
  BRNE END
  
  rcall ssd_decode
  inc r16
  cpi r16, 10
  brne END
  clr r16

  END:
    RETI

;---------------------------------------------------------------------------
; SUB-ROTINA: Decodifica um valor de 0 a 15 passado como parâmetro no R16 e 
;             escreve em um display anodo comum com a seguinte ligação:
; Seguimento:  G   F  ...  A
; Pino:       PB2 PC5 ... PC0
;---------------------------------------------------------------------------
ssd_decode:
  push ZH            ; Guarda contexto
  push ZL        
  push r0        
  in r0,SREG   
  push r0      

  ldi  ZH,HIGH(Tabela<<1) 
  ldi  ZL,LOW(Tabela<<1)  
  add  ZL,R16             
  brcc le_tab             
  inc  ZH    

le_tab:     
  lpm  R0,Z      ; Lê tabela de decoficação

  sbi PORTC, PC4 ; Escreve G
  sbrs R0, 6
  cbi PORTC, PC4

  out PORTB, R0  ; Escreve A .. F      

  pop r0         ; Recupera contexto
  out SREG, r0
  pop r0
  pop ZL
  pop ZH    

  ret

;---------------------------------------------------------------------------
;   Tabela p/ decodificar o display: como cada endereço da memória flash é 
; de 16 bits, acessa-se a parte baixa e alta na decodificação
;---------------------------------------------------------------------------
Tabela: .dw 0x7940, 0x3024, 0x1219, 0x7802, 0x1800, 0x0308, 0x2146, 0x0E06
;             1 0     3 2     5 4     7 6     9 8     B A     D C     F E  
;===========================================================================
