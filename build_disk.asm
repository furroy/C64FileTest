
/*
** Loading game assets into the program
*/

.disk [filename="disk1.d64", name="HIRED SWORD II", id="D1" ]
{
		[name="----------------", type="rel" ],
		[name="HIRED SWORD II", type="prg", segments="SEGMENT_GAME" ],
		[name="TITLE", type="prg", segments="SEGMENT_TITLE" ],
		[name="MAIN", type="prg", segments="SEGMENT_MAIN" ],
		[name="CHARS", type="prg", segments="SEGMENT_CHARS" ],
		[name="MAP1", type="prg", segments="SEGMENT_MAP1" ],
		[name="----------------", type="rel" ]
}

.segment SEGMENT_GAME [] "Game Code"
	//* = $0801
#import "main_game.asm"


.segment SEGMENT_MAP1 [] "First Map"
//* = $7200
	.import binary "assets/map.bin"

.segment SEGMENT_TITLE [] "Title Screen"
//* = $7200
	.import binary "assets/title.bin"

.segment SEGMENT_MAIN [] "Colors & Tiles"
//* = $7000
	//CHAR_COLORS:
		.import binary "assets/colors.bin"
		.import binary "assets/letters_attrs.bin"
	//MAP_TILES:
		.import binary "assets/tiles.bin"
	//EXTRA_PLAYER_TILE:
		.byte $00, $00, $00, $00

.segment SEGMENT_CHARS [] "Custom Chars"
//* = $f000 "Charset"
		//CHARACTERS:
			.import binary "assets/chars.bin"
		//LETTERS:
			.import binary "assets/letters.bin"
