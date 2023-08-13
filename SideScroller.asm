; Include memorymap, header info and SNES init routines
.INCLUDE "header.inc"

; Include library routines
.INCLUDE "InitSNES.asm"
.INCLUDE "LoadGraphics.asm"

; ==EQUates==
.EQU PalNum $0000		; Use some RAM

; ==Main Code==

.MACRO Stall
	.REPT 14
		WAI
	.ENDR
.ENDM

; 0400 = 0000 0100 0000 0000
; E.g. SetTile $0400, $01	Set tile in top-left
;----------------------------------------------------
; In: POSITION - Flipped, palette & position
;     TILE_ID - What tile to use
;----------------------------------------------------
.MACRO SetTile
	ldx #\1		; High: vhopppcc Low: cccccccc
	stx $2116	; c: Starting character (tile) number
	lda #\2		; h: horizontal flip	v: vertical flip
	sta $2118	; p: palette number	o: priority bit
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
	LoadPalette BG_Palette, 0, 28		; Palette: BG_Palette, Start Color: 0, Size: 28 (number of colors NOT BPP)

	; Load tile data to VRAM
	LoadBlockToVRAM Tiles, $0000, $0050	; 1 tile = 16 bytes (0010)

	; Now, load up some data into our tilemap
	; (If you had a full map, you could use LoadBlockToVRAM)
	; Remember that in the default map, all entries point to tile #0
	lda #$80
	sta $2115
	
	;ldx #$0400
	;stx $2116
	;lda #$01
	;sta $2118
	
	SetTile $0400, $01
	SetTile $0401, $01
	SetTile $0402, $02
	SetTile $0403, $01
	SetTile $0404, $01
	SetTile $0405, $01
	SetTile $0406, $03
	SetTile $0407, $01
	SetTile $0408, $02
	SetTile $0409, $01
	SetTile $040A, $01
	SetTile $040B, $01
	SetTile $040C, $01
	SetTile $040D, $01
	SetTile $040E, $01
	SetTile $040F, $01
	
	SetTile $0410, $02
	SetTile $0411, $01
	SetTile $0412, $01
	SetTile $0413, $01
	SetTile $0414, $01
	SetTile $0415, $02
	SetTile $0416, $03
	SetTile $0417, $01
	SetTile $0418, $03
	SetTile $0419, $01
	SetTile $041A, $01
	SetTile $041B, $02
	SetTile $041C, $01
	SetTile $041D, $01
	SetTile $041E, $00
	SetTile $041F, $01
	
	SetTile $0420, $01
	SetTile $0421, $01
	SetTile $0422, $01
	SetTile $0423, $00
	SetTile $0424, $01
	SetTile $0425, $01
	SetTile $0426, $02
	SetTile $0427, $01
	SetTile $0428, $01
	SetTile $0429, $01
	SetTile $042A, $01
	SetTile $042B, $03
	SetTile $042C, $01
	SetTile $042D, $01
	SetTile $042E, $02
	SetTile $042F, $01
	
	SetTile $0430, $01
	SetTile $0431, $01
	SetTile $0432, $02
	SetTile $0433, $01
	SetTile $0434, $01
	SetTile $0435, $01
	SetTile $0436, $01
	SetTile $0437, $01
	SetTile $0438, $01
	SetTile $0439, $01
	SetTile $043A, $01
	SetTile $043B, $01
	SetTile $043C, $01
	SetTile $043D, $01
	SetTile $043E, $03
	SetTile $043F, $02
	
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

















