TITLE Game Theory     (gametheory.asm)

; Author: seag11
; Date: 3/2018
; Description: Game theory simulation using MASM.  Each round, Player 1 (user) is prompted to cooperate with or defect
; against Player 2 (computer).  Players are credited or debited a pre-specified amount based upon the cited payoff matrix.
; The number of rounds varies between 1 and 10.

INCLUDE Irvine32.inc

.data
player_decision	DWORD	?
computer_decision DWORD	?
player_cents DWORD 0
computer_cents DWORD 0
default_color DWORD ?
cents_p1	BYTE "Your Score:     ",0
cents_p2	BYTE "Player 2 Score: ",0
intro1		BYTE "Game Theory - Iterative Prisoner's Dilemma",0
matrix0		BYTE "                           Player2",0
matrix1		BYTE "                      Cooperate   Defect",0
matrix2		BYTE "           Cooperate  P1:+40c     P1:-20c",0
matrix3		BYTE "Player1               P2:+40c     P2:+80c",0
matrix4		BYTE "           Defect     P1:+80c     P1:0c",0
matrix5		BYTE "                      P2:-20c     P2:0c",0
intro3		BYTE "For each round, you may cooperate or defect.",0
intro2		BYTE "Player 1 and Player 2 both begin with 0 cents.",0
prompt1		BYTE "Enter 1 to cooperate or 0 to defect: ",0
p_prompt	BYTE "You choose to ",0
c_prompt	BYTE "The computer chooses to ",0
cooperate	BYTE "cooperate",0
defect		BYTE "defect",0
final_label	BYTE "===  Game over  ===",0
community	BYTE "            Community Game",0
wallst		BYTE "            Wall Street Game",0

.code
main PROC

	;Store default foreground & background color
	call getTextColor
	mov default_color, eax

	;Introduction
	call Randomize
	call introduction
	call game
	
	;Generate number of rounds between 1-10
	mov		eax, 10
	call	RandomRange
	inc		eax
	mov		ecx, eax

top:
	;Prompt for player's choice
	call p1
	
	;Generate computer's choice
	call p2

	;Outcome of round
	call report
	call outcome
	loop top

	;print score
	call score
	
	exit	; exit to operating system
main ENDP

;---------------------------------------------------------
;Introduces program with title
;---------------------------------------------------------
introduction PROC
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET matrix0
	call	WriteString
	call	CrLf
	mov		edx, OFFSET matrix1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET matrix2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET matrix3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET matrix4
	call	WriteString
	call	CrLf
	mov		edx, OFFSET matrix5
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro3
	call	WriteString
	call	CrLf
	ret
introduction ENDP

;---------------------------------------------------------
;Print Title - 'Community Game' or 'Wall Street Game'
;---------------------------------------------------------
game PROC
	mov	eax, 2
	call RandomRange
	cmp	eax, 0
	jne	c1
	mov eax, yellow
	call SetTextColor
	mov edx, OFFSET wallst
	call CrLf
	call WriteString
	call CrLf
	mov eax, default_color
	call SetTextColor
	jmp w1
c1:
	mov eax, yellow
	call SetTextColor
	mov edx, OFFSET community
	call CrLf
	call WriteString
	call CrLf
	mov eax, default_color
	call SetTextColor
w1:
	ret
game ENDP

;---------------------------------------------------------
;Obtain player's move
;---------------------------------------------------------
p1 PROC
	call	CrLf
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadDec
	mov		player_decision, eax
	call	CrLf
	ret
p1 ENDP

;---------------------------------------------------------
;Generate computer's move
;---------------------------------------------------------
p2 PROC
	mov		eax, 2
	call	RandomRange
	mov		computer_decision, eax
	ret
p2 ENDP

;---------------------------------------------------------
;Determine outcome
;---------------------------------------------------------
outcome PROC
	;if both players cooperate
	mov eax, player_decision
	and eax, computer_decision
	cmp eax, 1
	jne else_if1
	add	player_cents, 40
	add	computer_cents, 40
	jmp	finish
else_if1:
	;if both players defect
	mov eax, player_decision
	mov ebx, computer_decision
	add eax,ebx
	cmp eax,0
	jg else_if2
	jmp finish
else_if2:
	;if p1 cooperates and p2 defects
	mov eax, player_decision
	mov ebx, computer_decision
	not ebx
	and eax, ebx
	cmp eax, 1
	jne else_if3
	sub player_cents, 20
	add computer_cents, 80
	jmp finish
else_if3:
	;if p1 defects and p2 cooperates
	mov eax, player_decision
	mov ebx, computer_decision
	not eax
	and eax, ebx
	cmp eax, 1
	jne finish
	add player_cents, 80
	sub computer_cents, 20
finish:
	ret
outcome ENDP

;---------------------------------------------------------
;Report outcome
;---------------------------------------------------------
report PROC
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
report ENDP


;---------------------------------------------------------
;Print Final Score
;---------------------------------------------------------
score PROC
	call CrLf
	mov edx, OFFSET final_label
	call WriteString
	call CrLf
	mov edx, OFFSET cents_p1
	call WriteString
	mov eax, player_cents
	call WriteInt
	mov eax, 99
	call WriteChar
	call CrLf
	mov edx, OFFSET cents_p2
	call WriteString
	mov eax, computer_cents
	call WriteInt
	mov eax, 99
	call WriteChar
	call CrLf
	ret
score ENDP

END main
