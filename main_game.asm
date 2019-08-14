

BasicUpstart2(Entry)
#import "libs/vic.asm"

// where to copy everything we want
.label CHAR_COLORS = $7000
.label MAP_1 = $7200
.label TITLE_SCREEN = $7200
.label CUSTOM_CHARS = $f000

	Dumb: {
		// dumb simple test fails to autorun under debugger
		lda #BLACK
		sta VIC.BACKGROUND_COLOR
		lda #LIGHT_BLUE
		sta VIC.BORDER_COLOR
		rts
	}

	Entry: {
			.break
			sei
			lda #$7f	//Disable CIA IRQ's to prevent crash because
			sta $dc0d
			sta $dd0d

			// don't know if needed to help file loading?? jsr $ff81

			// dynamically load in all our custom data to show title screen
			:LoadBank("MAIN");
			:CopyPages(CHAR_COLORS, 2);

			:LoadBank("TITLE");
			:CopyPages(TITLE_SCREEN, 4)

			:LoadBank("CHARS");
			:CopyPages(CUSTOM_CHARS, 6);

			// bank out kernal now we're done loading
			lda $01
			and #%11111000
			ora #%00000101
			sta $01

			//Set VIC BANK 3
			lda $dd00
			and #%11111100
			sta $dd00

			//Set screen and character memory
			lda #%00001100
			sta VIC.MEMORY_SETUP

			lda #BLACK
			sta VIC.BACKGROUND_COLOR
			lda #LIGHT_BLUE
			sta VIC.BORDER_COLOR

			// disable multicolor char mode
			lda VIC.CONTROL_2
			and #%01111
			sta VIC.CONTROL_2

			cli
			jsr TITLE.ClearScreen
			jsr TITLE.ShowTitleScreen
/*
		!TitleScreenPause:
			// show title screen
			jsr MOVE.WaitForJoystick
			jsr MOVE.WaitForNoJoystick
			jsr TITLE.ClearScreen
*/
		!Loop:
			jmp !Loop-
	}
	#import "diskloader.asm"
	#import "zeropage.asm"
	#import "title.asm"
	/*
	#import "move.asm"
	#import "dialog.asm"
	#import "inventory.asm"
	#import "map_loader.asm"
	#import "sounds.asm"
*/
