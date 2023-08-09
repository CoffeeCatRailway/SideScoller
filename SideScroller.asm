; Include memorymap, header info and SNES init routines
.INCLUDE "header.inc"

; Include SNES initializations & graphics
.INCLUDE "InitSNES.asm"

; ==Main Code==

.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
	InitSNES		; Init SNES
	
;	stz $2121		; Edit color 0 - snes' screen color you can write it in binary or hex
;	lda #%00011111		; binary is more visual, but if you wanna be cool use hex
;	sta $2122
;	stz $2122		; Secon byte has no data, so we write a 0

;	lda #$0F		; = 00001111
;	sta $2100		; Turn on screen, full brightness

forever:
	jmp forever

.ENDS ; ==End Main Code==

