; P2 -> Arquitetura de Computadores
; MáquinaV - Máquina Automática de Vendas

PLACE 0000H						; 1º Endereço de Memória
Begin:							
	JMP 		Startup 		; Salto Incondicional para inicializar a Máquina 
;_______________________________________________________________________________________________________________

PLACE 0070H
	;STRING  "ASCII converter"
DISPLAY_NUM1	EQU 009CH		; Display que representa um valor convertido em código ASCII
DISPLAY_NUM2	EQU 00ACH		; Display que representa um valor convertido em código ASCII
DISPLAY_NUM3	EQU 00BCH		; Display que representa um valor convertido em código ASCII
DISPLAY_NUM4	EQU 00CCH		; Display que representa um valor convertido em código ASCII
DISPLAY_NUM5	EQU 00DCH		; Display que representa um valor convertido em código ASCII
NR_TOT_CHAR		EQU 5			; Número total de carateres 
PASSWORD_I 		EQU 00B0H		; Inicio da palavra-passe  
PASSWORD_F 		EQU 00BFH 		; Fim da palavra-passe
VAZIO 			EQU 0020H		; Representa o carater vazio
PASSWORD_T      EQU 4			; Tamanho da palavra-passe
;Periféricos de Entrada 
;_______________________________________________________________________________________________________________
ON_OFF			EQU 0020H		; Periférico de Entrada que permite Ligar / Desligar o Display
PER_EN			EQU 0021H		; Periférico de Entrada
OK 				EQU 0022H		; Botão OK	-> Confirma o estado do Periférico de Entrada PER_EN
;PASSWORD 		EQU 01D0H   	; Posição de Memória onde inserimos a nossa Password para Autenticar ao MenuStock 
;_______________________________________________________________________________________________________________
	
;--------------------------
; O Ecrã Principal é composto por 7x16 (7 Linhas e 16 Carateres - Bytes)
DISPLAY			EQU	0080H		; Início do Display
DISPLAY_END		EQU	00EFH		; Fim do Display 
EMPTY_BYTE		EQU	0020H		; Carater Vazio (equivalente a 1 Byte) -> Limpa o Carater do Display
;--------------------------

DISPLAYSTR		EQU 00A0H 		; Endereço onde a STRING vai ser mostrada no DISPLAY (Bebida Brisa)
DISPLAYSTR1		EQU 00A0H 		; Endereço onde a STRING vai ser mostrada no DISPLAY (Bebida Coca-Cola)
DISPLAYSTR2		EQU 00A0H 		; Endereço onde a STRING vai ser mostrada no DISPLAY (Bebida Água Luso)

DISPLAYSTR3     EQU 00A0H 		; Endereço onde a STRING vai ser mostrada no DISPLAY (Snack Kinder Bueno)
DISPLAYSTR4     EQU 00A0H 		; Endereço onde a STRING vai ser mostrada no DISPLAY (Snack Kit-Kat)
DISPLAYSTR5 	EQU 00A0H 		; Endereço onde a STRING vai ser mostrada no DISPLAY (Snack Bounty)

;---------------------------
StackPointer	EQU	1FFEH		; Endereço do Apontador de Stack 
;---------------------------

PLACE 0200H 					

; Rotina para Limpar o Display
EraseDisplay:
	PUSH R0						; É armazenado o valor de R0 na stack 
	PUSH R1						; É armazenado o valor de R1 na stack 
	PUSH R3						; É armazenado o valor de R3 na stack 
	MOV R0, DISPLAY				; R0 guarda o endereço do DISPLAY
	MOV R1, DISPLAY_END			; R1 guarda o endereço do DISPLAY_END
Erase_Cycle:
	MOV R2, EMPTY_BYTE			; R2 guarda o endereço EMPTY_BYTE
	MOVB [R0], R2				; RTL: M[R0] <- R2
	ADD R0, 1					; Incrementa uma unidade a R0
	CMP R0, R1					; Compara o valor de R0 com o valor de R1
	JLE Erase_Cycle				; Salto Condicional para a etiqueta Erase_Cycle
	; POP -> repõe o valor de PUSH
	POP R3						; É retirado o valor de R3 da stack 	
	POP R1 						; É retirado o valor de R1 da stack 
	POP R0 						; É retirado o valor de R0 da stack 
RET								; Retorno da Rotina EraseDisplay

; Rotina para Limpar os Periféricos
ErasePeripherals:
	PUSH R0						; É armazenado o valor de R0 na stack 
	PUSH R1						; É armazenado o valor de R1 na stack 
	PUSH R2						; É armazenado o valor de R2 na stack 
	MOV R0, ON_OFF				; R0 guarda o valor de ON/OFF
	MOV R1, PER_EN				; R1 guarda o valor do Periférico de Entrada
	MOV R2, OK					; R2 guarda o valor do Botão OK
	MOV R3, 0					; RTL: R3 <- 0
	MOVB [R0], R3  				; RTL: M[R0] <- R3
	MOVB [R1], R3				; RTL: M[R1] <- R3
	MOVB [R2], R3				; RTL: M[R2] <- R3
	; POP -> repõe o valor de PUSH
	POP R2						; É retirado o valor de R2 da stack 
	POP R1						; É retirado o valor de R1 da stack 
	POP R0						; É retirado o valor de R0 da stack 
RET								; Retorno da Rotina ErasePeripherals

; Rotina para Mostrar o Display
ShowDisplay:
	PUSH R0 					; É armazenado o valor de R0 na stack 
	PUSH R1 					; É armazenado o valor de R1 na stack 
	PUSH R3						; É armazenado o valor de R3 na stack 
	MOV R0, DISPLAY				; R0 guarda o endereço DISPLAY
	MOV R1, DISPLAY_END			; R1 guarda o endereço DISPLAY_END
Cycle:							; Etiqueta que representa o Ciclo para Mostrar o Display
	MOV R3, [R2]				; O endereço de Memória em R2 é guardado em R3
	MOV [R0], R3				; RTL: [R0] <- R3
	ADD R2, 2 					; Incrementa duas unidades em R2
	ADD R0, 2					; Incrementa duas unidades em R0
	CMP R0, R1					; Compara o valor de R0 com o valor de R1
	JLE Cycle					; Salto Condicional para a etiqueta Cycle
	; POP -> repõe o valor de PUSH
	POP R3						; É retirado o valor de R3 na stack 
	POP R1						; É retirado o valor de R1 na stack 
	POP R0 						; É retirado o valor de R0 na stack 
RET								; Retorno da Rotina ShowDisplay

; Rotina de ERRO
RotinaERRO:
	PUSH R0						; É armazenado o valor de R0 na stack 
	PUSH R1  					; É armazenado o valor de R1 na stack 
	PUSH R2						; É armazenado o valor de R2 na stack 
	MOV R2, MenuERRO			; R2 guarda o Endereço de MenuERRO
	CALL ShowDisplay			; Chamada a Rotina para Mostrar o DISPLAY
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; R0 guarda o valor do Periférico de Entrada
ERRO:						
	MOVB R1, [R0]				; RTL: R1 <- M[R0] 
	CMP R1, 1					; Compara se R1 = 1 
	JNE ERRO					; Salto Condicional para a etiqueta ERRO
	; POP -> repõe o valor de PUSH
	POP R2 						; É retirado o valor de R2 na stack 					
	POP R1 						; É retirado o valor de R1 na stack 
	POP R0 						; É retirado o valor de R0 na stack 
RET

;------------------------------------------------
; Rotina para converter um valor em código ASCII
;------------------------------------------------
converter:
	PUSH R0 					; É armazenado o valor de R0 na stack 
	;PUSH R1 					; não realizamos PUSH em R1 como é o registo com o valor lido do P_IN
	PUSH R2						; É armazenado o valor de R2 na stack 
	PUSH R3 					; É armazenado o valor de R3 na stack 
	PUSH R4 					; É armazenado o valor de R4 na stack 
	PUSH R5 					; É armazenado o valor de R5 na stack 
	
	MOV R0, 10		
	MOV R2, DISPLAY_NUM1 		;R2 fica com a base do display 
	ADD R2, 2					;posição do carater a preencher
	MOV R3, 0					;R3 tem o nº de carateres já preenchidos 
proximoCarater:	
	MOV R4, R1 					;R4 fica com uma cópia do valor lido de X 
	MOD R4, R0 					;Calcula o D - resto da divisão inteira por 10 
	DIV R1, R0 					;Atualiza X - quociente da divisão inteira por 10 
	
	MOV R5, 48					;Passamos para R5 o valor 48 devido a ser um valor "grande"
	ADD R5, R4 					;Calcula C = D + 48
	MOVB [R2], R5 				;escreve o carater - BYTE no display a preencher 
	
	SUB R2, 1					;próxima posição do display a preencher 
	ADD R3, 1 					;incrementa o nº de carateres preenchidos 

	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JNE proximoCarater			; Salto Jump if not Equal para a Etiqueta proximoCarater
cicloVazios:
	CMP R3, NR_TOT_CHAR			; RTL: R3 <- guarda o endereço de NR_TOT_CHAR
	JEQ fimrotina 				; Salto Jump if equal para a Etiqueta fimrotina 
	MOV R5, EMPTY_BYTE			; RTL: R5 <- guarda o endereço de EMPTY_BYTE
	MOVB [R2], R5 				; RTL: 
	SUB R2, 1					;próxima posição do display a preencher 
	ADD R3, 1 					;incrementa o nº de carateres preenchidos 
	JMP cicloVazios 
	
fimrotina:						;etiqueta que indica o fim da rotina 
	POP R5 						; É retirado o valor de R5 da stack 
	POP R4 						; É retirado o valor de R4 da stack 
	POP R3 						; É retirado o valor de R3 da stack 
	POP R2 						; É retirado o valor de R2 da stack 
	;POP R1 
	POP R0 						; É retirado o valor de R0 da stack 
RET								;retorno da rotina 

; Programa Principal
;----------------------------	; Iniciamos o Programa Principal no Endereço de Memória 3000
Startup:
	MOV SP, StackPointer		; Instrução de Transferência de Dados que Guarda o Endereço do Apontador da Pilha 
	CALL EraseDisplay			; Chamada a Rotina para Limpar o Display
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
	MOV R0, ON_OFF 				; R0 guarda o valor de ON_OFF
SwitchON:
	MOVB R1, [R0]				; Leitura onde R1 guarda o endereço de memória de R0
	CMP R1, 1					; Compara se ON_OFF = 1
	JNE SwitchON				; Salto Condicional para a etiqueta SwitchON
ON:
	MOV R2, MenuPrincipal		; RTL: R2 <- guarda o endereço do Menu Principal
	CALL ShowDisplay			; Chamada a Rotina para Mostrar o Display
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
Read_Option:
	MOV R0, PER_EN				; R0 guarda o endereço corresponde à opção 
	MOVB R1, [R0]				; R1 guarda o valor lido da respetiva opção escolhida
	CMP R1, 0					; Compara se R1 = 0
	JEQ Read_Option				; Salto Condicional para a etiqueta Read_Option
	;------------------
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OProdutos				; Salto Condicional (Jump if equal) para a etiqueta OProdutos
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OStockAutenticar1		; Salto Condicional (Jump if equal) para a etiqueta OStockAutenticar
	;------------------
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP ON						; Salto Incondicional para a etiqueta ON

; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
OStockAutenticar1:				
	JMP OStockAutenticar		; Salto Incondicional para a etiqueta OStockAutenticar
	
;-----------------------------
; Rotina para o Menu Produtos
;-----------------------------
OProdutos:
	MOV R2, MenuProdutos		; R2 guarda o endereço MenuProdutos
	CALL ShowDisplay			; Chamada a Rotina para Mostrar o Display
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; Compara o valor do Periférico de Entrada com R0
Cycle_Produtos:
	MOVB R1, [R0]				; RTL: R1 <- M[R0]
	CMP R1, 0					; Compara se R1 = 0
	JEQ Cycle_Produtos			; Salto Condicional para a etiqueta Cycle_Produtos
	;----------------------
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OBebidas				; Salto Condicional para a etiqueta OBebidas
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OSnacks					; Salto Condicional para a etiqueta OSnacks
	CMP R1, 3 					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ ON 						; Salto Condicional Jump if equal para a etiqueta ON -> retrocede para o Menu Principal 
	;----------------------
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP OProdutos				; Salto Incondicional para a etiqueta OProdutos

; Rotina para o Menu das Bebidas
;----------------------------------------------------
OBebidas:
	MOV R2, MenuBebidas			; R2 guarda o endereço MenuBebidas
	CALL ShowDisplay			; Chamada a Rotina para Mostrar o Ecrã
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_Bebidas:					; Etiqueta que representa o Ciclo da Rotina OBebidas
	MOVB R1, [R0]				; RTL: R1 <- [R0]
	CMP R1, 0					; Compara se R1 = 0
	JEQ Cycle_Bebidas			; Salto Condicional para a etiqueta Cycle_Bebidas
	;----------------------
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OBrisa					; Salto Condicional Jump if equal para a Opção Brisa
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OCocaCola				; Salto Condicional Jump if equal para a Opção CocaCola
	CMP R1, 3					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ OAguaLuso				; Salto Condicional Jump fi equal para a Opção AguaLuso
	CMP R1, 4 					; RTL: IF R1 = 4 ? (PER_EN = 4)
	JEQ OProdutos 				; Salto Condicional Jump if equal para retroceder ao Menu dos Produtos
	;----------------------
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP OBebidas				; Salto Incondicional para a etiqueta OBebidas

; Rotina para a Opção Brisa
OBrisa:
	MOV R2, MenuEscolhaBebida	; R2 guarda o endereço do MenuEscolhaBebida
	CALL ShowDisplay			; Chamada a Rotina para Mostrar o Display
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN
Cycle_Brisa:
	MOVB R1, [R0]				; RTL: R1 <- M[R0]
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_Brisa				; Salto Condicional para a etiqueta Cycle_Brisa
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OPT_Pagamento1 			; Salto Condicional Jump if equal para a Opção de Pagamento 
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OBebidas 				; Salto Condicional Jump if equal para retroceder ao Menu das Bebidas 
	CMP R1, 3 					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ StringDisplayBrisa		; Salto Jump if equal para a Etiqueta StringDisplayBrisa
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP OBrisa					; Salto Incondicional para a etiqueta OBrisa

; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
OPT_Pagamento1:					
	JMP OPT_Pagamento			; Salto Incondicional para a Etiqueta OPT_Pagamento 

;TrocoBrisa:
	;display do menu
	;meter R6 em ascii na posição de memória inserido caso diferente de 0 substituir o menu default
	;SUB R6, 100
	;meter R6 em ascii na posição de memória troco
	;ler periférico botão ok e voltar ao menu principal
	;JMP TrocoBrisa

; Rotina para Apresentar a informação da bebida escolhida (Brisa)
;----------------------------------------------------------------------
StringDisplayBrisa: 
	MOV R6, TableBrisa 			; RTL: R6 <- guarda o endereço de origem TableBrisa
	MOV R7, DISPLAYSTR			; RTL: R7 <- guarda o endereço de Destino DISPLAYSTR
	MOV R8, 32 					; RTL: R8 <- guarda o número total de carateres da String 
cyclestring:
	MOVB R9, [R6]				; Guarda o Byte de menor peso de R6 em R9 
	MOVB [R7], R9				; RTL: M[R7] <- R9 
	ADD R6, 1 					; RTL: R6 <- R6 + 1 (Incrementa uma unidade em R6) 
	ADD R7, 1 					; RTL: R7 <- R7 + 1 (Incrementa uma unidade em R7) 
	SUB R8, 1					; RTL: R8 <- R8 - 1 (Decrementa uma unidade em R8) 
	CMP R8, 0 					; RTL: IF R8 = 0 ? (PER_EN = 0)
	JNZ cyclestring 			; Salto Jump if not Zero para a etiqueta de ciclo cyclestring
fora:
	MOV R9, PER_EN 				; RTL: R9 <- guarda o valor do Periférico de Entrada PER_EN 
	MOVB R10, [R9] 				; RTL: R10 <- M[R9]
	CMP R10, 0					; RTL: IF R10 = 0 ? (PER_EN = 0)
	JZ OPT_Pagamento1			; Salto Jump if Zero para a opção OPT_Pagamento
		
	JMP fora 					; Salto Incondicional para a Etiqueta fora 

; Rotina para a Opção Coca-Cola
OCocaCola:
	;MOV R6, 0
	;MOV R7, 100
	MOV R2, MenuEscolhaBebida	; R2 guarda o endereço do MenuEscolhaBebida
	CALL ShowDisplay			; Chamada a Rotina para Mostrar o Display
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_CocaCola:
	MOVB R1, [R0]				; RTL: R1 <- [R0]
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_CocaCola			; Salto Condicional para a etiqueta Cycle_Brisa
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OPT_Pagamento2 			; Salto Condicional Jump if equal para a Opção de Pagamento 
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OBebidas 				; Salto Condicional Jump if equal para retroceder ao Menu das Bebidas 
	CMP R1, 3 					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ StringDisplayCocaCola	; Salto Jump if equal para a Etiqueta StringDisplayCocaCola
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP OCocaCola				; Salto Incondicional para a etiqueta OCocaCola
	
;TrocoCocaCola:
	; Display do Menu 
	; Colocar R6 em ASCII na posição de Memória inserido caso diferente de 0 substituir o menu default 
	;JMP TrocoCocaCola
	
; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
OPT_Pagamento2:
	JMP OPT_Pagamento			; Salto Incondicional para a Etiqueta OPT_Pagamento 

; Rotina para Apresentar a informação da bebida escolhida (Coca-Cola)
;----------------------------------------------------------------------
StringDisplayCocaCola: 			
	MOV R6, TableCocaCola 		; RTL: R6 <- guarda o endereço de origem TableCocaCola 
	MOV R7, DISPLAYSTR1			; RTL: R7 <- guarda o endereço de Destino DISPLAYSTR1
	MOV R8, 32 					; RTL: R8 <- guarda o número total de carateres da String 
cyclestring1:
	MOVB R9, [R6]				; Guarda o Byte de menor peso de R6 em R9 
	MOVB [R7], R9				; RTL: M[R7] <- R9 
	ADD R6, 1 					; RTL: R6 <- R6 + 1 (Incrementa uma unidade em R6) 
	ADD R7, 1 					; RTL: R7 <- R7 + 1 (Incrementa uma unidade em R7) 
	SUB R8, 1					; RTL: R8 <- R8 - 1 (Decrementa uma unidade em R8) 
	CMP R8, 0 					; RTL: IF R8 = 0 ? (PER_EN = 0)
	JNZ cyclestring1 			; Salto Jump if not Zero para a etiqueta de ciclo cyclestring
fora1:
	MOV R9, PER_EN 				; RTL: R9 <- Guarda o valor do Periférico de Entrada PER_EN 
	MOVB R10, [R9] 				; RTL: R10 <- M[R9] 
	CMP R10, 0					; RTL: IF R10 = 0 ? (PER_EN = 0)
	JZ OPT_Pagamento2			; Salto Jump if Zero para a opção OPT_Pagamento
	
	JMP fora1 					; Salto Incondicional para a Etiqueta fora1 

; Rotina para a Opção Água Luso
OAguaLuso:
	MOV R2, MenuEscolhaBebida	; R2 guarda o endereço do MenuEscolhaBebida
	CALL ShowDisplay			; Chamada à Rotina para Mostrar o Ecrã
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; R0 guarda o valor do Periférico de Entrada
Cycle_AguaLuso:
	MOVB R1, [R0]				; RTL: R1 <- [R0]
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_AguaLuso			; Salto Condicional para a etiqueta Cycle_AguaLuso
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OPT_Pagamento3 			; Salto Condicional Jump if equal para a Opção de Pagamento 
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OBebidas 				; Salto Condicional Jump if equal para retroceder ao Menu das Bebidas 
	CMP R1, 3 					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ StringDisplayAguaLuso	; Salto Jump if equal para a Etiqueta StringDisplayAguaLuso
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP OAguaLuso				; Salto Incondicional para a etiqueta OAguaLuso

; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
OPT_Pagamento3:
	JMP OPT_Pagamento			; Salto Incondicional para a Etiqueta OPT_Pagamento 

; Rotina para Apresentar a informação da bebida escolhida (Água Luso)
;----------------------------------------------------------------------
StringDisplayAguaLuso: 			
	MOV R6, TableLuso 			; RTL: R6 <- guarda o endereço de origem TableLuso
	MOV R7, DISPLAYSTR2			; RTL: R7 <- guarda o endereço de Destino DISPLAYSTR2
	MOV R8, 32 					; RTL: R8 <- guarda o número total de carateres da String 
cyclestring2:
	MOVB R9, [R6]				; Guarda o Byte de menor peso de R6 em R9 
	MOVB [R7], R9				; RTL: M[R7] <- R9 
	ADD R6, 1 					; RTL: R6 <- R6 + 1 (Incrementa uma unidade em R6) 
	ADD R7, 1 					; RTL: R7 <- R7 + 1 (Incrementa uma unidade em R7) 
	SUB R8, 1					; RTL: R8 <- R8 - 1 (Decrementa uma unidade em R8) 
	CMP R8, 0 					; RTL: IF R8 = 0 ? (PER_EN = 0)
	JNZ cyclestring2 			; Salto Jump if not Zero para a etiqueta de ciclo cyclestring
fora2:
	MOV R9, PER_EN 				; RTL: R9 <- Guarda o valor do Periférico de Entrada PER_EN 
	MOVB R10, [R9] 				; RTL: R10 <- M[R9] 
	CMP R10, 0					; RTL: IF R10 = 0 ? (PER_EN = 0)
	JZ OPT_Pagamento3			; Salto Jump if Zero para a opção OPT_Pagamento
	
	JMP fora2 					; Salto Incondicional para a Etiqueta fora2 

;----------------------------------------------------
; Rotina para o Menu da Categoria dos Produtos Snacks
;----------------------------------------------------
OSnacks:
	MOV R2, MenuSnacks			; R2 guarda o endereço MenuSnacks
	CALL ShowDisplay			; Chamada à Rotina para Mostrar o Ecrã
	CALL ErasePeripherals		; Chamada à Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_Snacks:					; Etiqueta que representa o Ciclo da Rotina OSnacks
	MOVB R1, [R0]				; RTL: R1 <- M[R0]
	CMP R1, 0					; Compara se R1 = 0
	JEQ Cycle_Snacks			; Salto Condicional para a etiqueta Cycle_Snacks
	;----------------------
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OKinderBueno			; Salto Condicional Jump if equal para a etiqueta OKinderBueno
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OKitKat					; Salto Condicional Jump if equal para a etiqueta OKitKat
	CMP R1, 3					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ OBounty					; Salto Condicional Jump if equal para a etiqueta OBounty
	CMP R1, 4 					; RTL: IF R1 = 4 ? (PER_EN = 4)
	JEQ OProdutos1				; Salto Condicional Jump if equal para a etiqueta OProdutos 
	;----------------------
	CALL RotinaERRO				; Chamada à Rotina de Erro caso a opção selecionada seja incorreta
	JMP OSnacks					; Salto Incondicional para a etiqueta OSnacks

; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
OProdutos1:
	JMP OProdutos				; Salto Incondicional para a Etiqueta Produtos 

; Rotina para a Opção Kinder Bueno 
OKinderBueno:
	MOV R2, MenuEscolhaSnack	; R2 guarda o endereço do MenuEscolhaSnack
	CALL ShowDisplay			; Chamada a Rotina para Mostrar o Display
	CALL ErasePeripherals		; Chamada a Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_KinderBueno:
	MOVB R1, [R0]				; RTL: R1 <- M[R0]
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_KinderBueno		; Salto Condicional para a etiqueta Cycle_KinderBueno
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OPT_Pagamento4 			; Salto Condicional Jump if equal para a Opção de Pagamento 
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OSnacks 				; Salto Condicional Jump if equal para retroceder ao Menu dos Snacks 
	CMP R1, 3 					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ StringDisplayKinderBueno	; Salto Jump if equal para a Etiqueta StringDisplayKinderBueno
	CALL RotinaERRO				; Chamada à Rotina de Erro caso a opção selecionada seja incorreta
	JMP OKinderBueno			; Salto Incondicional para a etiqueta OKinderBueno

; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
OPT_Pagamento4:
	JMP OPT_Pagamento			; Salto Incondicional para a etiqueta OPT_Pagamento 

; Rotina para Apresentar a informação do snack escolhido (Kinder Bueno)
;----------------------------------------------------------------------
StringDisplayKinderBueno: 
	MOV R6, TableKinderBueno	; RTL: R6 <- guarda o endereço de origem TableKinderBueno
	MOV R7, DISPLAYSTR3			; RTL: R7 <- guarda o endereço de Destino DISPLAYSTR
	MOV R8, 32 					; RTL: R8 <- guarda o número total de carateres da String 
cyclestring3:
	MOVB R9, [R6]				; Guarda o Byte de menor peso de R6 em R9 
	MOVB [R7], R9				; RTL: M[R7] <- R9 
	ADD R6, 1 					; RTL: R6 <- R6 + 1 (Incrementa uma unidade em R6) 
	ADD R7, 1 					; RTL: R7 <- R7 + 1 (Incrementa uma unidade em R7) 
	SUB R8, 1					; RTL: R8 <- R8 - 1 (Decrementa uma unidade em R8) 
	CMP R8, 0 					; RTL: IF R8 = 0 ? (PER_EN = 0)
	JNZ cyclestring3			; Salto Jump if not Zero para a etiqueta de ciclo cyclestring
fora3:
	MOV R9, PER_EN 				; RTL: R9 <- guarda o valor do Periférico de Entrada PER_EN 
	MOVB R10, [R9] 				; RTL: R10 <- M[R9]
	CMP R10, 0					; RTL: IF R10 = 0 ? (PER_EN = 0)
	JZ OPT_Pagamento4			; Salto Jump if Zero para a opção OPT_Pagamento
		
	JMP fora3 					; Salto Incondicional para a Etiqueta fora3

; Rotina para a Opção Kit-Kat
OKitKat:
	MOV R2, MenuEscolhaSnack	; R2 guarda o endereço do MenuEscolhaSnack
	CALL ShowDisplay			; Chamada à Rotina para Mostrar o Ecrã
	CALL ErasePeripherals		; Chamada à Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_KitKat:
	MOVB R1, [R0]				; RTL: R1 <- [R0]
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_KitKat			; Salto Condicional para a etiqueta Cycle_KitKat
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OPT_Pagamento5 			; Salto Condicional Jump if equal para a Opção de Pagamento 
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OSnacks 				; Salto Condicional Jump if equal para retroceder ao Menu dos Snacks 
	CMP R1, 3 					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ StringDisplayKitKat		; Salto Jump if equal para a Etiqueta StringDisplayKitKat
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP OKitKat					; Salto Incondicional para a etiqueta OKitKat

; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
OPT_Pagamento5:
	JMP OPT_Pagamento			; Salto Incondicional para a Etiqueta OPT_Pagamento 

; Rotina para Apresentar a informação do snack escolhido (KitKat)
;----------------------------------------------------------------------
StringDisplayKitKat: 
	MOV R6, TableKitKat 		; RTL: R6 <- guarda o endereço de origem TableKitKat
	MOV R7, DISPLAYSTR4			; RTL: R7 <- guarda o endereço de Destino DISPLAYSTR
	MOV R8, 32 					; RTL: R8 <- guarda o número total de carateres da String 
cyclestring4:
	MOVB R9, [R6]				; Guarda o Byte de menor peso de R6 em R9 
	MOVB [R7], R9				; RTL: M[R7] <- R9 
	ADD R6, 1 					; RTL: R6 <- R6 + 1 (Incrementa uma unidade em R6) 
	ADD R7, 1 					; RTL: R7 <- R7 + 1 (Incrementa uma unidade em R7) 
	SUB R8, 1					; RTL: R8 <- R8 - 1 (Decrementa uma unidade em R8) 
	CMP R8, 0 					; RTL: IF R8 = 0 ? (PER_EN = 0)
	JNZ cyclestring4 			; Salto Jump if not Zero para a etiqueta de ciclo cyclestring
fora4:
	MOV R9, PER_EN 				; RTL: R9 <- guarda o valor do Periférico de Entrada PER_EN 
	MOVB R10, [R9] 				; RTL: R10 <- M[R9]
	CMP R10, 0					; RTL: IF R10 = 0 ? (PER_EN = 0)
	JZ OPT_Pagamento5			; Salto Jump if Zero para a opção OPT_Pagamento
		
	JMP fora4					; Salto Incondicional para a Etiqueta fora4 
	
; Rotina para a Opção Bounty
OBounty:
	MOV R2, MenuEscolhaSnack	; RTL: R2 <- guarda o endereço do MenuEscolhaSnack
	CALL ShowDisplay			; Chamada à Rotina para Mostrar o Ecrã 
	CALL ErasePeripherals		; Chamada à Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_Bounty:
	MOVB R1, [R0]				; RTL: R1 <- [R0]
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_Bounty			; Salto Condicional para a etiqueta Cycle_Bounty
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OPT_Pagamento6 			; Salto Condicional Jump if equal para a Opção de Pagamento 
	CMP R1, 2					; RTL: IF R1 = 2 ? (PER_EN = 2)
	JEQ OSnacks					; Salto Condicional Jump if equal para retroceder ao Menu dos Snacks 
	CMP R1, 3 					; RTL: IF R1 = 3 ? (PER_EN = 3)
	JEQ StringDisplayBounty		; Salto Jump if equal para a Etiqueta StringDisplayBounty
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP OBounty					; Salto Incondicional para a etiqueta OBounty

; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
OPT_Pagamento6:
	JMP OPT_Pagamento			; Salto Incondicional para a Etiqueta OPT_Pagamento 

; Rotina para Apresentar a informação do snack escolhido (Bounty)
;----------------------------------------------------------------------
StringDisplayBounty: 
	MOV R6, TableBounty 		; RTL: R6 <- guarda o endereço de origem TableBounty
	MOV R7, DISPLAYSTR5			; RTL: R7 <- guarda o endereço de Destino DISPLAYSTR
	MOV R8, 32 					; RTL: R8 <- guarda o número total de carateres da String 
cyclestring5:
	MOVB R9, [R6]				; Guarda o Byte de menor peso de R6 em R9 
	MOVB [R7], R9				; RTL: M[R7] <- R9 
	ADD R6, 1 					; RTL: R6 <- R6 + 1 (Incrementa uma unidade em R6) 
	ADD R7, 1 					; RTL: R7 <- R7 + 1 (Incrementa uma unidade em R7) 
	SUB R8, 1					; RTL: R8 <- R8 - 1 (Decrementa uma unidade em R8) 
	CMP R8, 0 					; RTL: IF R8 = 0 ? (PER_EN = 0)
	JNZ cyclestring5 			; Salto Jump if not Zero para a etiqueta de ciclo cyclestring
fora5:
	MOV R9, PER_EN 				; RTL: R9 <- guarda o valor do Periférico de Entrada PER_EN 
	MOVB R10, [R9] 				; RTL: R10 <- M[R9]
	CMP R10, 0					; RTL: IF R10 = 0 ? (PER_EN = 0)
	JZ OPT_Pagamento6			; Salto Jump if Zero para a opção OPT_Pagamento
		
	JMP fora5 					; Salto Incondicional para a Etiqueta fora 
	
; Rotina de Pagamento 
;-----------------------
OPT_Pagamento:
	MOV R2, MenuPagamento 		; RTL: R2 <- guarda o endereço do MenuPagamento
	CALL ShowDisplay 			; Chamada à Rotina para Mostrar o Ecrã 
	CALL ErasePeripherals 		; Chamada à Rotina para Limpar os Periféricos
	MOV R0, PER_EN 				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_Pagamento:
	MOVB R1, [R0] 				; RTL: R1 <- M[R0]
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_Pagamento			; Salto Condicional Jump if equal para a Etiqueta Cycle_Pagamento 
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ OPT_Talao				; Salto Jump if equal para a opção OPT_Talao
	CALL RotinaERRO 			; Chamada à Rotina de Erro caso a opção selecionada seja incorreta
	JMP OPT_Pagamento 			; Salto Incondicional para a etiqueta OPT_Pagamento

; Rotina para Mostrar o Talão da Compra efetuada 
;-----------------------------------------------
OPT_Talao:
	MOV R2, MenuTalao 			; RTL: R2 <- guarda o endereço de MenuTalao 
	CALL ShowDisplay 			; Chamada à Rotina para Mostrar o Ecrã 
	CALL ErasePeripherals 		; Chamada à Rotina para Limpar os Periféricos
	MOV R0, PER_EN 				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_Talao:
	MOVB R1, [R0] 				; RTL: R1 <- M[R0]
	CMP R1, 0 					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_Talao				; Salto Jump if equal para a opção de ciclo Cycle_Talao
	CMP R1, 1 					; RTL: IF R1 = 1 ? (PER_EN = 1)
	JEQ ON2 					; Salto Jump if equal para a Etiqueta ON2 
	CALL RotinaERRO 			; Chamada à Rotina de Erro caso a opção selecionada seja incorreta
	JMP OPT_Talao 				; Salto Incondicional para a etiqueta OPT_Talao
ON2: 							; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
	JMP ON 						; Salto Incondicional para a etiqueta ON onde vai retornar para o Menu Principal da Máquina 

;--------------------------------------------
; Rotina para o Menu de Autenticação do Stock
;--------------------------------------------
OStockAutenticar:
	MOV R2, MenuStockAutenticar	; RTL: R2 <- guarda o endereço de MenuStockAutenticar 
	CALL ShowDisplay			; Chamada à Rotina para Mostrar o Ecrã 
	CALL ErasePeripherals		; Chamada à Rotina para Limpar os Periféricos
	MOV R0, PER_EN				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
Cycle_StockAutenticar:
	MOVB R1, [R0]				; RTL: R1 <- M[R0]
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ Cycle_StockAutenticar 	; Salto Jump if equal para a etiqueta Cycle_StockAutenticar
	;------------------------------
	CMP R1, 1					; RTL: IF R1 = 1 ? (PER_EN = 1) 
	JEQ VerificarPassword       ; confirmação password
	JEQ OStockMoedas			; Salto Jump if equal para a etiqueta OStockMoedas
	CMP R1, 2 					; RTL: IF R1 = 2 ? (PER_EN = 2) 
	JEQ ON1						; Salto Jump if equal para a Etiqueta ON1 
	;------------------------------
	CALL RotinaERRO				; Chamada a Rotina de Erro caso a opção selecionada seja incorreta
	JMP OStockAutenticar		; Salto Incondicional para a etiqueta OStockAutenticar
ON1:							; executamos este salto pois o PEPE possui uma limitação apenas conseguindo saltar de 128 a 128 instruções 
	JMP ON 						; Salto Incondicional para a etiqueta ON onde vai retornar para o Menu Principal da Máquina 

; Rotina para Verificar Password inserida 
;-----------------------------------------
VerificarPassword:
	MOV R1, PASSWORD_I			; Guarda a posição inicial da palavra-passe
	MOV R2, PASSWORD_F			; Guarda a posição final da palavra-passe
	MOV R3, Password			; Guarda o valor da password do registo
	MOV R6, PASSWORD_T			; Guarda o tamanho  da palavra-passe
CicloDeComparacao:
	MOVB R4, [R1]				; Guarda o byte de menor peso de R1 em R4
	MOVB R5, [R3]				; Guarda o byte de menor peso de R3 em R5 
	CMP R4, R5					; Compara se o início da palavra-passe está vazio
	JNE PasswordIncorreta		; Salto condicional para a label PasswordIncorreta
	ADD R1, 1  					; RTL: R1 <- R1 + 1 
	SUB R6, 1					; RTL: R6 <- R6 - 1 
	JZ Confirmacao				; Salto Condicional Jump if Zero para confirmar a inserção da Password 
	ADD R3, 1					; RTL: R3 <- R3 + 1
	JMP CicloDeComparacao		; Salto incondicional para a label CicloDeComparacao

PasswordIncorreta:
	MOV R2,MenuStockPasswordIncorreta	; RTL: R2 <- guarda o endereço de MenuStockPasswordIncorreta
	CALL ShowDisplay			; Chamada à Rotina para Mostrar o Ecrã 
	CALL ErasePeripherals		; Chamada à Rotina para Limpar os Periféricos
TentarNovamente:
	MOV R0, PER_EN				; R0 guarda o endereço corresponde à opção 
	MOVB R1, [R0]				; R1 guarda o valor lido da respetiva opção escolhida
	CMP R1, 1					; Compara se R1 = 1
	JEQ OStockAutenticar		; Salto Jump if equal para a etiqueta OStockAutenticar
	JMP TentarNovamente			; Salto Jump if not equal para retroceder ao menu de Autenticação
Confirmacao:
	MOVB R4, [R1]				; Guarda o byte de menor peso de R1 em R4
	MOV R2,VAZIO				; RTL: R2 <- guarda o endereço VAZIO 
	CMP R2, R4					; RTL: IF R2 = R4 ? (Compara o valor de R2 com R4)
	JNE PasswordIncorreta		; Salto Jump if not equal caso a Password inserida seja incorreta 

; Rotina para Mostrar o Stock das Moedas 
;---------------------------------------
OStockMoedas:
	MOV R2, MenuStockMoedas		; RTL: R2 <- guarda o endereço de MenuStockMoedas 
	CALL ShowDisplay			; Chamada à Rotina para Mostrar o Ecrã 
	CALL ErasePeripherals		; Chamada à Rotina para Limpar os Periféricos 
	CALL converter 				; Chamada à Rotina para converter um valor em código ASCII 
	MOV R0, PER_EN 				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN 
CycleStockMoedas:
	MOVB R1, [R0]				; RTL: R1 <- M[R0] 
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ CycleStockMoedas		; Salto Jump if equal para a etiqueta CycleStockMoedas
	CMP R1, 1 					; RTL: IF R1 = 1 ? (PER_EN = 1) 
	JEQ OPT_StockProdutos		; Salto Jump if equal para a etiqueta OPT_StockProdutos
	CMP R1, 2 					; RTL: IF R1 = 2 ? (PER_EN = 2) 
	JEQ OStockAutenticar		; Salto Jump if equal para a etiqueta OStockAutenticar
	CALL RotinaERRO				; Chamada à Rotina de ERRO caso a opção selecionada no PER_EN seja incorreta 
	JMP OStockMoedas			; Salto Incondicional para a etiqueta OStockMoedas

; Rotina para Mostrar o Stock dos Produtos 
;-----------------------------------------
OPT_StockProdutos:				 
	MOV R2, MenuStockProdutos	; RTL: R2 <- guarda o endereço de MenuStockProdutos 
	CALL ShowDisplay			; Chamada à Rotina para Mostrar o Ecrã 
	CALL ErasePeripherals		; Chamada à Rotina para Limpar os Periféricos
	CALL converter 			    ; Chamada à Rotina para converter um valor em código ASCII 
	MOV R0, PER_EN 				; RTL: R0 <- guarda o valor do Periférico de Seleção PER_EN
CycleStockProdutos:			
	MOVB R1, [R0]				; RTL: R1 <- M[R0] 
	CMP R1, 0					; RTL: IF R1 = 0 ? (PER_EN = 0)
	JEQ CycleStockProdutos		; Salto Jump if equal para a etiqueta CycleStockProdutos
	CMP R1, 1 					; RTL: IF R1 = 1 ? (PER_EN = 1) 
	JEQ OStockMoedas			; Salto Jump if equal para a etiqueta OStockMoedas
	CALL RotinaERRO				; Chamada à Rotina de ERRO caso a opção selecionada no PER_EN seja incorreta 
	JMP OPT_StockProdutos		; Salto Incondicional para a etiqueta OPT_StockProdutos

; Ecras

;password
;DB
PLACE 1000H
	; Bebidas 
	TableBrisa:
		STRING  " Opcao: Brisa   "
		STRING  " Preco: 1.00    "
		
PLACE 1030H
	TableCocaCola:
		STRING  " Opcao:Coca-Cola"
		STRING  " Preco: 1.00    "
	
PLACE 1060H
	TableLuso:
		STRING  " Opcao: Luso    "
		STRING  " Preco: 0.50    "

PLACE 1090H 
	; Snacks 
	TableKinderBueno:
		STRING  " Opcao: KBueno  "
		STRING  " Preco: 1.00    "

PLACE 1120H
	TableKitKat:
		STRING  " Opcao: Kit-Kat "
		STRING  " Preco: 1.00    "

PLACE 1150H 
	TableBounty:
		STRING  " Opcao: Bounty  "
		STRING  " Preco: 1.00    "

; MENUS 
PLACE 2000H	
	
	MenuPrincipal:
		STRING 	" -------------- "
		STRING  " MAQUINA MADEIRA"
		STRING  " BEM-VINDO      "
		STRING  " -------------- "
		STRING  " 1)Produtos     "
		STRING  " 2)Stock        "
		STRING  " ---------------"
		
	MenuProdutos:
		STRING  " -------------- "
		STRING  " Produtos       "
		STRING  " -------------- "
		STRING  " 1)Bebidas      "
		STRING  " 2)Snacks       "
		STRING  " 7)Cancelar     "
		STRING  " -------------- "
		
	MenuERRO:				
		STRING  " -- ATENCAO --- "
		STRING  " -------------- "
		STRING  "    OPCAO       "
		STRING  "    ERRADA      "
		STRING  " -------------- "
		STRING  "Tente  Novamente"
		STRING  " -------------- "

	MenuBebidas:
		STRING  " Bebidas:       "
		STRING  " -------------- "
		STRING  " 1)Brisa        "
		STRING  " 2)Coca-Cola    "
		STRING  " 3)Agua Luso    "
		STRING  " 7)Voltar       "
		STRING  " ---------------"
	
	MenuEscolhaBebida:
		STRING  "Bebida escolhida"
		STRING  " -------------- "
		STRING  "                "	; Aparece a informação da tabela para a respetiva bebida escolhida 
		STRING  "                "
		STRING  " 1- Confirmar   "
		STRING  " 2- Voltar      "
		STRING  " ---------------"

	MenuSnacks:
		STRING  " Snacks:        "
		STRING  " -------------- "
		STRING  " 1)Kinder Bueno "
		STRING  " 2)Kit-Kat      "
		STRING  " 3)Bounty       "
		STRING  " 7)Voltar       "
		STRING  " -------------- "
		
	MenuEscolhaSnack:
		STRING  "Snack escolhido:"
		STRING  " -------------- "
		STRING  "                "	; Aparece a informação da tabela para o respetivo snack escolhido 
		STRING  "                "
		STRING  " 1- Confirmar   "
		STRING  " 2- Voltar      "
		STRING  " ---------------"

	MenuPagamento:
		STRING  " Val.Monetarios "
		STRING  " 0.10           "
		STRING  " 0.20           "
		STRING  " 0.50           "
		STRING  " 1.00           "
		STRING  " 2.00           "
		STRING  " 5.00           "
		
	MenuTalao:
		STRING  "----------------"
		STRING  "     TALAO      "
		STRING  "----------------"
		STRING  "                "	; Inserir nome do Produto
		STRING  "Inserido:       "	; Valor inserido
		STRING  "Troco:          "	; Inserir Troco (Valor Inserido - Preço Produto)
		STRING  "----------------"

;----------------------------------
	MenuStockAutenticar:
		STRING  "--- Stock ------"
		STRING  "                "
		STRING  "Insira Password:"
		STRING  "                "	; 00B0H -> Inserir Password em código ASCII 
		STRING  " 1- Confirmar   "
		STRING  " 2- Voltar      "
		STRING  "----------------"

	MenuStockPasswordIncorreta:
		STRING  " ---- Stock --- "
		STRING  " -------------- "
		STRING  "    Password    "
		STRING  "   Incorreta!   "
		STRING  " -------------- "
		STRING  " 1- Voltar      "
		STRING  " -------------- " 

	MenuStockMoedas:
		STRING 	"Stock-Moedas 1/2"
		STRING  " 0.10:          "
		STRING  " 0.20:          "
		STRING 	" 0.50:          "
		STRING  " 1.00:          "
		STRING  " 2.00:          "
		STRING  " 5.00:          "
		
	MenuStockProdutos:
		STRING 	"  Produtos   2/2"
		STRING  " Brisa:         "
		STRING  " CocaCola:      "
		STRING 	" Luso:          "
		STRING  " KBueno:        "
		STRING  " Kit-Kat:       "
		STRING  " Bounty:        "
		
	Password:
		STRING "1Aa-"	; Palavra-passe - hexa 31 41 61 2D	