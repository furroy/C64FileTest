
/*
** Loading game assets into the program
*/

.disk [filename="disk1.d64", name="HIRED II", id="D1" ]
{
		[name="----------------", type="rel" ],
		[name="HIRED", type="prg", segments="SEGMENT_GAME" ],
		[name="MAIN", type="prg", segments="SEGMENT_MAIN" ],
		[name="CHARS", type="prg", segments="SEGMENT_CHARS" ],
		[name="MAP1", type="prg", segments="SEGMENT_MAP1" ],
		[name="TITLE", type="prg", segments="SEGMENT_TITLE" ],
		[name="----------------", type="rel" ]
}

.segment SEGMENT_MAP1 []
//* = $7200
	.import binary "assets/map.bin"

.segment SEGMENT_TITLE []
//* = $7200
	.import binary "assets/title.bin"

.segment SEGMENT_MAIN []
//* = $7000
	CHAR_COLORS:
		.import binary "assets/colors.bin"
		.import binary "assets/letters_attrs.bin"
	MAP_TILES:
		.import binary "assets/tiles.bin"
	EXTRA_PLAYER_TILE:
		.byte $00, $00, $00, $00

.segment SEGMENT_CHARS []
	//* = $f000 "Charset"
		CHARACTERS:
			.import binary "assets/chars.bin"
		LETTERS:
			.import binary "assets/letters.bin"


			.segment SEGMENT_GAME []

			BasicUpstart2(Entry)
			#import "libs/vic.asm"

			.label TITLE_SCREEN = $7200
			.label MAP_1 = $7200
				Entry: {

								lda #$7f	//Disable CIA IRQ's to prevent crash because
								sta $dc0d
								sta $dd0d

								lda $01
								and #%11111000
								ora #%00000101
								sta $01

											jsr $ff81

										:LoadBank("MAIN");
										:CopyPages($7000, 2);

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

						/* :LoadBank("TITLE");
						:CopyPages(TITLE_SCREEN, 2)

						:LoadBank("CHARS");
						:CopyPages($f000, 2); */

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
