
label: .EQU var1=100 ; associa a constante 100 � var1 (Diretiva)     
       .EQU var2=200 ; associa a constante 200 � var2 (Diretiva)
             
start: inc r16       ; incrementa o r16 (Instru��o)
       rjmp start    ; salta para o r�tulo ``start'' (Instru��o)
                     ; linha com coment�rio
                     // outro coment�rio