UTILS: {
	GetCharacterIndexAt: {
		//x register = x char position
		//y register = y char position
		// find the character code on the screen
		// and return the index of the character in the character table
		.label COLLISION_LOOKUP = TEMP1

		lda ScreenRowLSB, y
		sta COLLISION_LOOKUP
		lda ScreenRowMSB, y
		sta COLLISION_LOOKUP + 1

		// COLLISION_LOOKUP now has the address for the start of current row we're looking into
		txa
		tay
		lda (COLLISION_LOOKUP), y
		rts
	}

	// https://codebase64.org/doku.php?id=base:small_fast_8-bit_prng
	seed: .byte $32

	RNG: {
			lda seed
			beq doEor
			asl
			beq noEor // if the input was $80, skip the EOR
			bcc noEor
		doEor:
			eor #$1d
		noEor:
			sta seed
			rts
	}
}
