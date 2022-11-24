
label: .EQU var1=100 ; associa a constante 100 à var1 (Diretiva)     
       .EQU var2=200 ; associa a constante 200 à var2 (Diretiva)
             
start: inc r16       ; incrementa o r16 (Instrução)
       rjmp start    ; salta para o rótulo ``start'' (Instrução)
                     ; linha com comentário
                     // outro comentário