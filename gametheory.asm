TITLE Game Theory     (gametheory.asm)

; Author: seag11
; Date: 3/2018
; Description: Game theory simulation using MASM

INCLUDE Irvine32.inc

.data
player_decision	DWORD	?
computer_decision DWORD	?
player_apples DWORD 10
player_oranges DWORD 0
computer_apples DWORD 0
computer_oranges DWORD 10
default_color DWORD ?
apples_label	BYTE "Apples: ",0
oranges_label	BYTE "Oranges: ",0
intro1		BYTE "Game Theory - Iterative Donation Game",0
intro3		BYTE "You are an apple farmer who engages in trade with an orange farmer",0
intro4		BYTE "You start with 10 bushels of apples and 0 bushels of oranges.",0
intro5		BYTE "For each round of trade, you may cooperate by sending a bushel of apples or defect by withholding bushel of apples.",0
prompt1		BYTE "Enter 1 to cooperate or 0 to defect: ",0
p_prompt	BYTE "You choose to ",0
c_prompt	BYTE "The computer chooses to ",0
cooperate	BYTE "cooperate",0
defect		BYTE "defect",0
produce		BYTE "Final Count of Produce:",0
computer	BYTE "Computer",0
player		BYTE "Player",0

.code
main PROC

	;store default foreground & background color
	call getTextColor
	mov default_color, eax

	;Introduction
	call Randomize
	call introduction
	
	mov		eax, 10
	inc		eax
	call	RandomRange
	mov		ecx, eax

top:
	;Prompt for player's choice
	call oranges
	
	;Generate computer's choice
	call apples

	;Outcome of donation game
	call outcome
	loop top

	;print inventory
	call inventory
	;call payoff
	
	exit	; exit to operating system
main ENDP

;---------------------------------------------------------
;Introduces program with title
;---------------------------------------------------------
introduction PROC
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro4
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro5
	call	WriteString
	call	CrLf
	ret
introduction ENDP

;---------------------------------------------------------
;Obtain player's move
;---------------------------------------------------------
oranges PROC
	call	CrLf
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadDec
	mov		player_decision, eax
	call	CrLf
	ret
oranges ENDP

;---------------------------------------------------------
;Generate computer's move
;---------------------------------------------------------
apples PROC
	mov		eax, 2
	call	RandomRange
	mov		computer_decision, eax
	ret
apples ENDP

;---------------------------------------------------------
;Determine outcome
;---------------------------------------------------------
outcome PROC
	mov edx, OFFSET p_prompt
	call WriteString
	mov eax, player_decision
	cmp eax, 0
	je player_defect
	mov eax, green
	call SetTextColor
	mov edx, OFFSET cooperate
	call WriteString
	call CrLf
	dec player_apples
	inc computer_apples
	mov eax, default_color
	call SetTextColor
	jmp	player_cooperate
player_defect:
	mov eax, red
	call SetTextColor
	mov edx, OFFSET defect
	call WriteString
	call CrLf
	mov eax, default_color
	call SetTextColor
player_cooperate:
	mov edx, OFFSET c_prompt
	call WriteString
	mov eax, computer_decision
	cmp eax, 0
	je computer_defect
	mov eax, green
	call SetTextColor
	mov edx, OFFSET cooperate
	call WriteString
	call CrLf
	dec computer_oranges
	inc player_oranges
	mov eax, default_color
	call SetTextColor
	jmp computer_cooperate
computer_defect:
	mov eax, red
	call SetTextColor
	mov edx, OFFSET defect
	call WriteString
	call CrLf
	mov eax, default_color
	call SetTextColor
computer_cooperate:
	ret
outcome ENDP

;---------------------------------------------------------
;Print inventory
;---------------------------------------------------------
inventory PROC
	call CrLf
	mov edx, OFFSET produce
	call WriteString
	call CrLf
	mov	edx, OFFSET apples_label
	call WriteString
	mov eax, player_apples
	call WriteDec
	call CrLf
	mov	edx, OFFSET oranges_label
	call WriteString
	mov eax, player_oranges
	call WriteDec
	call CrLf
	ret
inventory ENDP

;---------------------------------------------------------
;Payoff matrix
;---------------------------------------------------------
payoff PROC
	mov eax, 62
	call WriteChar
	mov edx, OFFSET computer
	call WriteString
	call CrLf
	mov eax, 118
	call WriteChar
	mov edx, OFFSET player
	call WriteString
	call CrLf
	;mov edx, OFFSET matrix1
	;call WriteString
	;mov eax, 179
	;call WriteChar
	;mov edx, OFFSET matrix2
	;call WriteString
	ret	
payoff ENDP

END main
