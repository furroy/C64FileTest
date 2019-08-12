
/*
** Title Screen
*/

.namespace TITLE {
	// we relocate chars here
	.const CHARACTERS = $f000
	// after 119 custom chars, we relocate letters here
	.const LETTERS = $f000 + 8 * 119
	// SPACE is the first custom letter
	.const SPACE = [LETTERS - CHARACTERS] / 8

	ShowTitleScreen: {
			.label Row = TEMP1
			.label Col = TEMP2

			//Initialize the screen/color ram self mod code
			lda #<VIC.SCREEN
			sta Screen + 1
			sta Color + 1
			lda #>VIC.SCREEN
			sta Screen + 2
			lda #>VIC.COLOR_RAM
			sta Color + 2
			// point map to title screen
			lda #<TITLE_SCREEN
			sta MapLookup + 1
			lda #>TITLE_SCREEN
			sta MapLookup + 2

			//Reset row counter
			lda	#$00
			sta Row
		!RowLoop:
			//Reset col counter
			lda	#$00
			sta Col

		!ColumnLoop:

		MapLookup:
			lda $BEEF
			// map has index into LETTERS, but we've loaded them at an offset we have to account that for now
			clc
			adc #SPACE
		Screen:
			sta $BEEF
			// now we have to lookup the color data
			tax
			lda CHAR_COLORS, x
		Color:
			sta $BEEF

			//Increment position in map data
			clc
			lda MapLookup + 1
			adc #1
			sta MapLookup + 1
			bcc !+
			inc MapLookup + 2
		!:

			//Increment position in screen and color ram
			clc
			lda Screen + 1
			adc #1
			sta Screen + 1
			sta Color + 1
			bcc !+
			inc Screen + 2
			inc Color + 2
		!:

			//Advance 1 column
			inc Col
			ldx Col
			cpx #40
			bne !ColumnLoop-

			inc Row
			ldx Row
			cpx #25
			bne !RowLoop-
			rts
	}

	ClearScreen: {
			ldx #0
		!clear:
			lda #SPACE
			sta VIC.SCREEN, x   // fill four areas with 256 spacebar characters
			sta VIC.SCREEN + $100,x
			sta VIC.SCREEN + $200,x
			sta VIC.SCREEN + $2e8,x
			lda #BLACK      // set foreground to black in Color Ram
			sta VIC.COLOR_RAM,x
			sta VIC.COLOR_RAM + $100,x
			sta VIC.COLOR_RAM + $200,x
			sta VIC.COLOR_RAM + $2e8,x
			inx            // increment X
			bne !clear-      // did X turn to zero yet?
							// if not, continue with the loop
			rts            // return from this subroutine
	}
}
