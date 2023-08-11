; Include memorymap, header info and SNES init routines
.INCLUDE "header.inc"

; Include library routines
.INCLUDE "InitSNES.asm"
.INCLUDE "LoadGraphics.asm"

; ==EQUates==
.EQU PalNum $0000		; Use some RAM

; ==Main Code==

.MACRO Stall
	.REPT 7
		WAI
	.ENDR
.ENDM

.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
	InitSNES				; Init SNES
	
	rep #$10
	sep #$20
	
	stz PalNum
	
	; Load palette for tiles
	LoadPalette BG_Palette, 0, 28		; Palette: BG_Palette, Start Color: 0, Size: 4 (number of colors NOT BPP)

	; Load tile data to VRAM
	LoadBlockToVRAM Tiles, $0000, $0040	; 2 tiles, 2bpp = 32 bytes

	; Now, load up some data into our tilemap
	; (If you had a full map, you could use LoadBlockToVRAM)
	; Remember that in the default map, all entries point to tile #0
	lda #$80
	sta $2115
	
	; ==Display tile #1 in top left==
	ldx #$0400
	stx $2116
	
	lda #$00
	sta $2118
	; ===============================
	
	jsr SetupVideo				; Setup video modes and other stuff, then turn on screen
	
	lda #$80
	sta $4200				; Enable NMI

forever:
	Stall
	
	lda PalNum
	clc
	adc #$04
	and #$1C				; If Palette starting color > 28 (00011100), make 0
	sta PalNum

_done:
	jmp forever

VBlank:
	rep #$10				; X/Y=16 bits
	sep #$20				; A/mem=8 bit
	
	stz $2115				; Setup VRAM
	ldx #$0400
	stx $2116				; Set VRAM address
	lda PalNum
	sta $2119				; Write to VRAM
	
	lda $4210				; Clear NMI flag
	
	rti

; ==Setup Video==
SetupVideo:
	;php
	
	lda #$00
	sta $2105		; Set video mode 0, 8x8 tiles, 4 color BG1/BG2/BG3/BG4
	
	lda #$04		; Set BG1's tile map offset to $0400 (word address)
	sta $2107		; And the tile map size to 32x32
	
	stz $210B		; Set BG1's character VRAM offset to $0000 (word address)
	
	lda #$01		; Enable BG1
	sta $212C
	
	;lda #$FF
	;sta $210E
	;sta $210E
	
	lda #$0F
	sta $2100		; Turn on screen, full brightness
	
	;plp
	rts

.ENDS ; ==End Main Code==

; ==Character Data==
.BANK 1 SLOT 0
.ORG 0
.SECTION "CharacterData"

.INCLUDE "sprites/Rosy-42.inc"

;Tiles:
;	.DW $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
;	.DB $00,$00,$24,$00,$24,$00,$24,$00
;	.DB $00,$00,$81,$00,$FF,$00,$00,$00

;BG_Palette:
;	.DB $00, $00, $FF, $03
;	.DW $0000, $0000, $0000
;	.DB $1F, $00
;	.DW $0000, $0000, $0000
;	.DB $E0, $5D
;	.DW $0000, $0000, $0000
;	.DB $E0, $02

.ENDS ; ==End Character Data==

















