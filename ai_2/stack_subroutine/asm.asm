.EQU A = PB0
.EQU B = PB1
.EQU C = PB2
.EQU D = PB3
.EQU E = PB4
.EQU F = PB5
.EQU G = PC4
.EQU DP = PC5

.DSEG
.ORG SRAM_START
   
values: .BYTE 10
 
.CSEG
start:
  RCALL ssd_init

  LDI XH, HIGH(values)
  LDI XL, LOW(values)

  LDI R16, 10
  initialization:
  DEC R16
  ST X+, R16
  CPI R16, 0
  BRNE initialization


  MAIN_LOOP:
  LDI XH, HIGH(values)
  LDI XL, LOW(values)

  FIRST_PART:
  ; Configura o delay para 200ms
  LDI R19, 16

  ; Escreve o valor no display após 200ms
  RCALL delay
  RCALL ssd_write_x
  
  ; Incrementa o valor e retorna ao inicio se o valor for 0
  LD R20, X+
  CPI R20, 0
  BRNE FIRST_PART

  SECOND_PART:
  ; Configura o delay para 1000ms
  LDI R19, 80
  
  ; Liga o DP, espera 1 segundo, desliga o DP
  RCALL ssd_dp_on
  RCALL delay
  RCALL ssd_dp_off
  
  ; Reinicia o loop
  RJMP MAIN_LOOP



ssd_init:
    ; Salva o contexto
    PUSH R16
    IN R16, SREG
    PUSH R16
    
    ; Configura A a F como saída e desliga
    LDI R16, 0b00111111 
    OUT DDRB, R16 
    LDI R16, 0xFF
    OUT PORTB, R16

    ; Configura G e DP como saída e desliga
    LDI R16, 0b00110000
    OUT DDRC, R16 
    LDI R16, 0xFF
    OUT PORTC, R16

    ; Recupera o contexto
    POP R16
    OUT SREG, R16
    POP R16

    ret

ssd_write_x:
    ; Salva o contexto
    PUSH R16
    IN R16, SREG
    PUSH R16
    
    LD R16, X
    RCALL ssd_decode

    ; Recupera o contexto
    POP R16
    OUT SREG, R16
    POP R16
    
    ret

ssd_dp_on:
    ; Salva o contexto
    PUSH R16
    IN R16, SREG
    PUSH R16

    ; Liga o DP -- 0 liga 1 desliga
    CBI PORTC, DP
    
    ; Recupera o contexto
    POP R16
    OUT SREG, R16
    POP R16

    ret

ssd_dp_off:
    ; Salva o contexto
    PUSH R16
    IN R16, SREG
    PUSH R16

    ; Liga o DP -- 0 liga 1 desliga
    SBI PORTC, DP
    
    ; Recupera o contexto
    POP R16
    OUT SREG, R16
    POP R16

    ret

;---------------------------------------------------------------------------
; SUB-ROTINA: Decodifica um valor de 0 a 15 passado como parâmetro no R16 e 
;             escreve em um display anodo comum com a seguinte ligação:
; Seguimento:  DP  G   F   ... A
; Pino:        PC5 PC4 PB5 ... PB0
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



;---------------------------------------------------------------
;SUB-ROTINA DE ATRASO Programável
; Descrição: Depende do valor de R19 carregado antes da chamada.
; Exemplos:  - R19 = 16 --> 200ms 
;            - R19 = 80 --> 1s 
;---------------------------------------------------------------
delay:           
  push r17       ; Salva os valores de r17,
  push r18       ; ... r18,
  in r17,SREG    ; ...
  push r17       ; ... e SREG na pilha.

  ; Executa sub-rotina :
  clr r17
  clr r18
loop:            
  dec  R17       ;decrementa R17, começa com 0x00
  brne loop      ;enquanto R17 > 0 fica decrementando R17
  dec  R18       ;decrementa R18, começa com 0x00
  brne loop      ;enquanto R18 > 0 volta decrementar R18
  dec  R19       ;decrementa R19
  brne loop      ;enquanto R19 > 0 vai para volta

  pop r17         
  out SREG, r17  ; Restaura os valores de SREG,
  pop r18        ; ... r18
  pop r17        ; ... r17 da pilha

  ret