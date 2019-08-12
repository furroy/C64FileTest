

BasicUpstart2(Entry)
#import "libs/vic.asm"

.label CHAR_DATA = $7000
.label TITLE_SCREEN = $7200
.label MAP_1 = $7200
.label CUSTOM_CHARS = $f000
	Entry: {
					//sei

					lda #$7f	//Disable CIA IRQ's to prevent crash because
					sta $dc0d
					sta $dd0d

					jsr $ff81

					:LoadBank("MAIN");
					:CopyPages(CHAR_DATA, 2);

					:LoadBank("TITLE");
					:CopyPages(TITLE_SCREEN, 2)

					:LoadBank("CHARS");
					:CopyPages(CUSTOM_CHARS, 2);


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

			lda #14
			sta VIC.BORDER_COLOR

/*
		!TitleScreenPause:
			// show title screen
			jsr TITLE.ShowTitleScreen
			jsr MOVE.WaitForJoystick
			jsr MOVE.WaitForNoJoystick
			jsr TITLE.ClearScreen
*/
		!Loop:
			jmp !Loop-
	}
	#import "diskloader.asm"
	/*
	#import "zeropage.asm"
	#import "title.asm"
	#import "move.asm"
	#import "dialog.asm"
	#import "inventory.asm"
	#import "map_loader.asm"
	#import "sounds.asm"
*/
