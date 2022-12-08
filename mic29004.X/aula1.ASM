.ORG 0x0000 ; Reset vector
  RJMP setup

.ORG 0x0002 ; INT0 Vector (PD2)
  RJMP isr_int0 

.ORG 0x0020 ; Timer
  RJMP isr_tc0b

.ORG 0x0034 ; End  

.DSEG
.ORG SRAM_START
   
value:    .BYTE 1
counter:  .BYTE 1
 
.CSEG
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

    ; Aponta X para a variavel "value" e zera a variavel
    LDI XH, HIGH(value)
    LDI XL, LOW(value)
    ST X, R16

    ; Aponta X para a variavel "counter" e zera a variavel
    LDI XH, HIGH(counter)
    LDI XL, LOW(counter)
    ST X, R16

    ; Mostra value na tela
    rcall ssd_decode
  

main: 
  rjmp main    

; Reseta o valor do display e mostra
isr_int0:
  ; Salva o contexto
  PUSH R16
  IN R16, SREG
  PUSH R16

  ; Aponta X para a variavel "value"
  LDI XH, HIGH(value)
  LDI XL, LOW(value)

  ; Zera R16 e armazena na variavel
  CLR R16
  ST X, R16

  ; Mostra na tela o valor
  RCALL ssd_decode

  ; Recupera o contexto
  POP R16
  OUT SREG, R16
  POP R16

  RETI

isr_tc0b:
  ; Salva o contexto
  PUSH R16
  IN R16, SREG
  PUSH R16

  ; Aponta X para a variável "counter"
  LDI XH, HIGH(counter)
  LDI XL, LOW(counter)

  ; Carrega counter para R16
  LD R16, X
  ; Incrementa e salva R16
  INC R16
  ST X, R16

  ; Se R16 !== 123 Vai para o fim
  CPI R16, 123
  BRNE END
  
  ; Aponta X para a variável "value"
  LDI XH, HIGH(value)
  LDI XL, LOW(value)

  ; Carrega value para R16
  LD R16, X
  ; Mostra value na tela
  rcall ssd_decode
  ; Incrementa R16 e salva em value
  INC R16
  ST X, R16
  
  ; Se R16 !== 10 vai para o fim
  cpi r16, 10
  brne END
  ; Senão zera e salva em value
  clr r16
  ST X, R16

  END:
    ; Recupera o contexto
    POP R16
    OUT SREG, R16
    POP R16

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
