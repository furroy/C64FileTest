
/*
:LoadBank(MUSIC__1, "MUSIC__1");
:CopyPages($1000,16)
*/


DISKCOPY: {
		//sei

		// ensuring the processor port is writable
		lda #$ff
		sta $00

		ldy #$00
	!:
		ldx #$37
		stx $01
	BANK_SOURCE:
		lda $BE00, y
		ldx #$30
		stx $01
	BANK_DEST:
		sta $BE00, y
		iny
		bne !-
		inc [BANK_SOURCE] + 2
		inc [BANK_DEST] + 2
		dec [BANK_PAGES]
		bne !-

		lda #$35            //Bank out kernal and basic $a000-$bfff & $e000-$ffff
		sta $01

		//cli
		rts
	BANK_PAGES:
		.byte $00
}

DISKLOADER: {
			sei
			lda #$37  //Turn kernal on
			sta $01

			lda #$00
			sta $d020
			sta $d021

			//Accumulate IRQ for flashing border routine
			lda #<flashload
			ldx #>flashload
			sta $0328
			stx $0329

			cli
			lda #$08
			// ldx $ba //Read from current disk drive present (Always use this instead of ldx #$08)
			ldx #8
			ldy #$00 //Allow loading to address
			jsr $ffba //Is device present?

			lda fname_size //File length
			ldx loadname
			ldy loadname + 1    //Set the load name
			jsr $ffbd          //Disk drive searches/loads the loadname

			ldx #$00
			ldy #$80
			lda #$00
			jsr $ffd5

			bcs onerror

			ldx #$08
			jsr $ffc3
			jsr $ffcc
			// jsr $ff81

			rts
	onerror:
			sta $d020
			//sta $0400
			rts
	flashload:
			inc borderCol
			lda borderCol
			sta $d020
			sta $d021
			lda #$00
			sta $d020
			sta $d021
			jmp $f6fe

	load_address:
			.byte $00, $00
	loadname:
			.byte $00, $00
			// !text"flname*"
	borderCol:
			.byte $00
	fname_size:
		.byte $00
}

.macro LoadBank(name) {
			.var sz = name.size()
			ldx #sz
			stx DISKLOADER.fname_size
			ldx #<fname
			stx DISKLOADER.loadname
			ldy #>fname
			sty DISKLOADER.loadname + 1
			jmp !+
		fname:
			.text name
			//.text "*"
		!:
		jsr DISKLOADER
}

.macro CopyPages(Dest, Pages) {

		// moved label into macro so we have access to it
		.label LOAD_ADDRESS = $8000
		.if(Dest != LOAD_ADDRESS) {
			// shallan, i added this here so can call multiple times and reset the BANK_SOURCE each time
			lda #>LOAD_ADDRESS
			sta [DISKCOPY.BANK_SOURCE]+2
			lda #>Dest
			sta [DISKCOPY.BANK_DEST]+2

			lda #Pages
			sta [DISKCOPY.BANK_PAGES]

			jsr DISKCOPY
		}
}
