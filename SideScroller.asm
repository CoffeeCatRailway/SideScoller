; Include memorymap, header info and SNES init routines
.INCLUDE "header.inc"

; Include SNES initializations & graphics
.INCLUDE "InitSNES.asm"
.INCLUDE "LoadGraphics.asm"

; ==Main Code==

.BANK 0 SLOT 0
.ORG 0
.SECTION "MainCode"

Start:
	InitSNES		; Init SNES
	
	; Load palette for tiles
	LoadPalette BG_Palette, 0, 2

	; Load tile data to VRAM
	LoadBlockToVRAM Tiles, $0000, $0020

	; Now, load up some data into our tilemap
	; (If you had a full map, you could use LoadBlockToVRAM)
	; Remember that in the default map, all entries point to tile #0
	lda #$80
	sta $2115
	ldx #$0400
	stx $2116
	lda #$01
	sta $2118
	
;	stz $2121		; Edit color 0 - snes' screen color you can write it in binary or hex
;	lda #%00011111		; binary is more visual, but if you wanna be cool use hex
;	sta $2122
;	stz $2122		; Secon byte has no data, so we write a 0

;	lda #$0F		; = 00001111
;	sta $2100		; Turn on screen, full brightness
	
	; Setup video modes and other stuff, then turn on screen
	jsr SetupVideo

forever:
	jmp forever

; ==Setup Video==
SetupVideo:
	php
	
	lda #$00
	sta $2105		; Set video mode 0, 8x8 tiles, 4 color BG1/BG2/BG3/BG4
	
	lda #$04		; Set BG1's tile map offset to $0400 (word address)
	sta $2107		; And the tile map size to 32x32
	
	stz $210B		; Set BG1's character VRAM offset to $0000 (word address)
	
	lda #$01		; Enable BG1
	sta $212C
	
	lda #$FF
	sta $210E
	sta $210E
	
	lda #$0F
	sta $2100		; Turn on screen, full brightness
	
	plp
	rts

.ENDS ; ==End Main Code==

; ==Character Data==
.BANK 1 SLOT 0
.ORG 0
.SECTION "CharacterData"

	.INCLUDE "sprites/Rosy-42.inc"

.ENDS ; ==End Character Data==
