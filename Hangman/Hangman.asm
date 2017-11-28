TITLE Hangman	(hangman.asm)
; Description:    A two-player ASCII art hangman game
; Authors: The Fighting Rutabagas featuring
;		Tersa Motbaynor Almaw
;		Andrew McNeill
;		Jude Battista

INCLUDE Irvine32.inc    

.data
defaultMaxAnswerLength DWORD 16
promptNamePlayer1 BYTE "Player 1, please enter your name: ",0
promptNamePlayer2 BYTE "Player 2, please enter your name: ",0
player1Name BYTE 16 DUP(0)
player2Name BYTE 16 DUP(0)
nameMaxLength DWORD 16
promptWordMaxLength BYTE "Input the maximum length of the words you wish to play with today: ",0
wordMaxLength DWORD 16
promptWinningScore BYTE "Input the score you would like to play to: ",0
winningScore DWORD 0
promptTargetWord BYTE "Input the target word: ",0
targetWord BYTE 100 DUP(0)
promptGuess BYTE "Input the letter you would like to guess: ",0
currentGuess BYTE 0

.code

;CallAndResponse uses eax, ecx, and edx
;It requires three parameters pushed to the stack:
;	address of the prompt you wish to display
;	address where you wish to store the answerAddress
;	max length of the answer
;It then displays the prompt and stores the answer
CallAndResponse proc USES eax ecx edx,
	promptAddress:DWORD,
	answerAddress:DWORD,
	answerMaxSize:DWORD

	mov edx, promptAddress
	call WriteString
	mov edx, answerAddress
	mov ecx, answerMaxSize
	call ReadString
	ret
CallAndResponse endp

;Uses CallAndResponse to store the name for each player
GetNames proc
	push nameMaxLength
	push OFFSET player1Name
	push OFFSET promptNamePlayer1
	Call CallAndResponse
	
	push nameMaxLength
	push OFFSET player2Name
	push OFFSET promptNamePlayer2
	Call CallAndResponse
	ret
GetNames endp

GetNames1 proc USES eax ecx edx
	mov edx, offset promptNamePlayer1
	call WriteString
	mov edx, OFFSET player1Name
	mov ecx, 16
	call ReadString
	mov edx, offset promptNamePlayer2
	call WriteString
	mov ecx, 16
	mov edx, offset player2Name
	call ReadString
	ret
GetNames1 endp

;Uses CallAndResponse to store the maximum word length for this session
GetMaxWordLength proc
	push OFFSET defaultMaxAnswerLength
	push OFFSET wordMaxLength
	push OFFSET promptWordMaxLength
	call CallAndResponse
GetMaxWordLength endp

;Uses CallAndResponse to store the winning score for this session
GetWinningScore proc
	push OFFSET defaultMaxAnswerLength
	push OFFSET winningScore
	push OFFSET promptWinningScore
	call CallAndResponse
GetWinningScore endp

;Uses CallAndResponse to store the target word for this round
GetTargetWord proc
	push OFFSET wordMaxLength
	push OFFSET targetWord
	push OFFSET promptTargetWord
	call CallAndResponse
GetTargetWord endp

;Gets a letter from the guesser and store it in currentGuess
GetGuess proc
	mov edx, OFFSET promptGuess
	call WriteString
	call ReadChar
	mov currentGuess, al
GetGuess endp


CheckGuess proc

CheckGuess endp

main proc
	call GetNames
	mov edx, OFFSET player1Name
	call WriteString
	call Crlf
	mov edx, OFFSET player2Name
	call WriteString
	call Crlf
	invoke ExitProcess,0
main endp
end main
