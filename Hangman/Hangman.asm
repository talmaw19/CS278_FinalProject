TITLE Hangman	(hangman.asm)
; Description:    A two-player ASCII art hangman game
; Authors: The Fighting Rutabagas featuring
;		Tersa Motbaynor Almaw
;		Andrew McNeill
;		Jude Battista

INCLUDE Irvine32.inc    

.data

;Test data
guessSugar BYTE "The current guess is: ",0
playerNameSugar BYTE "The player's name is: ",0
targetWordSugar BYTE "The target word is: ",0
winningScoreSugar BYTE "The winning score is: ",0
wordMaxLengthSugar BYTE "The max word length is: ",0

;Production data
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

alphabet BYTE "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
alphaLeft BYTE "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0

.code

;CallAndResponseString uses eax, ecx, and edx
;It requires three parameters pushed to the stack:
;	address of the prompt you wish to display
;	address where you wish to store the answerAddress
;	max length of the answer
;It then displays the prompt and stores the answer
CallAndResponseString proc USES eax ecx edx,
	promptAddress:DWORD,
	answerAddress:DWORD,
	answerMaxSize:DWORD

	mov edx, promptAddress
	call WriteString
	mov edx, answerAddress
	mov ecx, answerMaxSize
	call ReadString
	ret
CallAndResponseString endp

;CallAndResponseInt uses eax, ecx, and edx
;It requires three parameters pushed to the stack:
;	address of the prompt you wish to display
;	address where you wish to store the answerAddress
;	max length of the answer
;It then displays the prompt and stores the answer
CallAndResponseInt proc USES eax ecx edx,
	promptAddress:DWORD,
	answerAddress:DWORD

	mov edx, promptAddress
	call WriteString
	call ReadInt
	mov ecx, answerAddress
	mov [ecx], eax
	ret
CallAndResponseInt endp


;Uses CallAndResponse to store the name for each player
GetNames proc
	push nameMaxLength
	push OFFSET player1Name
	push OFFSET promptNamePlayer1
	Call CallAndResponseString
	
	push nameMaxLength
	push OFFSET player2Name
	push OFFSET promptNamePlayer2
	Call CallAndResponseString
	ret
GetNames endp

;Uses CallAndResponse to store the maximum word length for this session
GetWordMaxLength proc
	push OFFSET wordMaxLength
	push OFFSET promptWordMaxLength
	call CallAndResponseInt
	ret
GetWordMaxLength endp

;Uses CallAndResponse to store the winning score for this session
GetWinningScore proc
	push OFFSET winningScore
	push OFFSET promptWinningScore
	call CallAndResponseInt
	ret
GetWinningScore endp

;Uses CallAndResponse to store the target word for this round
GetTargetWord proc
	push wordMaxLength
	push OFFSET targetWord
	push OFFSET promptTargetWord
	call CallAndResponseString
	ret
GetTargetWord endp

;Gets a letter from the guesser and store it in currentGuess
GetGuess proc
	;First we need to get the guess from the user
	mov edx, OFFSET promptGuess
	call WriteString
	call ReadChar			;store the guess in al
	and al, 0DFh			;render the letter uppercase
	mov currentGuess, al	;store the uppercase letter in currentGuess
	ret
GetGuess endp


CheckGuess proc USES eax
	;Find the index of the letter
	xor eax, eax
	mov al, currentGuess
	sub al, 41h				;A is alphabet[0] with ASCII code 41h
	;check to see whether it has been guessed yet
	mov ah, alphaLeft[eax]
	mov al, ah
	call WriteChar
	ret
CheckGuess endp

TestGetNames proc
	call GetNames
	mov edx, OFFSET playerNameSugar
	call WriteString
	mov edx, OFFSET player1Name
	call WriteString
	call Crlf
	mov edx, OFFSET playerNameSugar
	call WriteString
	mov edx, OFFSET player2Name
	call WriteString
	call Crlf
	ret
TestGetNames endp

TestGetWordMaxLength proc
	call GetWordMaxLength
	mov edx, OFFSET wordMaxLengthSugar
	call WriteString
	mov eax, wordMaxLength
	call WriteDec
	call Crlf
	ret
TestGetWordMaxLength endp

TestGetWinningScore proc
	call GetWinningScore
	mov edx, OFFSET winningScoreSugar
	call WriteString
	mov eax, winningScore
	call WriteDec
	call Crlf
	ret
TestGetWinningScore endp

TestGetTargetWord proc
	call GetTargetWord
	mov edx, OFFSET targetWordSugar
	call WriteString
	mov edx, OFFSET targetWord
	call WriteString
	call Crlf
	ret
TestGetTargetWord endp

TestGetGuess proc
	call GetGuess
	xor eax, eax
	mov al, currentGuess
	call WriteChar
	call Crlf
	call CheckGuess
	ret
TestGetGuess endp

TestIo PROC
	;call TestGetNames
	call TestGetWordMaxLength
	call TestGetWinningScore
	call TestGetTargetWord
	call TestGetGuess
	ret
TestIo ENDP

main proc
	call TestIo
	invoke ExitProcess,0
main endp
end main
