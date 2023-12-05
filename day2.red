Red [
	title:  "Advent of Code 2023 - Day 2: Cube Conundrum"
	file:   %day2.red
	author: "Christian Ensel"
]

;   ██████   █████  ██    ██     ██████          ██████ ██    ██ ██████  ███████      ██████  ██████  ███    ██ ██    ██ ███    ██ ██████  ██████  ██    ██ ███    ███ 
;   ██   ██ ██   ██  ██  ██           ██ ██     ██      ██    ██ ██   ██ ██          ██      ██    ██ ████   ██ ██    ██ ████   ██ ██   ██ ██   ██ ██    ██ ████  ████ 
;   ██   ██ ███████   ████        █████         ██      ██    ██ ██████  █████       ██      ██    ██ ██ ██  ██ ██    ██ ██ ██  ██ ██   ██ ██████  ██    ██ ██ ████ ██ 
;   ██   ██ ██   ██    ██        ██      ██     ██      ██    ██ ██   ██ ██          ██      ██    ██ ██  ██ ██ ██    ██ ██  ██ ██ ██   ██ ██   ██ ██    ██ ██  ██  ██ 
;   ██████  ██   ██    ██        ███████         ██████  ██████  ██████  ███████      ██████  ██████  ██   ████  ██████  ██   ████ ██████  ██   ██  ██████  ██      ██ 
                                                                                                                                                                   
day2: context [
	
	set 'sum-of function [values [block!]] [                                    ;-- poor man's SUM-OF
		sum: 0 parse values [any [set val integer! (sum: sum + val) | skip]] sum
	]

	set 'map function [function [any-function!] values [any-block!]] [          ;-- poor man's MAP
		collect [foreach value values [keep function value]]
	]

	space: [any " "]
	colon: [space ":" space]
	comma: [space "," space]
	semicolon: [space ";" space]
	digit: charset "1234567890"

	set 'bagged-games? function [games [string!] bag [block!]] [
		parse games [collect [any "^/"
			some [
				"Game" space copy game some digit
				(	game: load game)
				colon
				some [
					some [
						copy count some digit space
						(	count: load count)
						copy color ["red" | "green" | "blue"]
						(	color: load color
							if count > bag/:color [game: none]
						)
						opt comma
					]
					opt semicolon
				]
				some "^/"
				keep (game)
			]
		]
	]]

	set 'power-of-bag func [bag [block!]] [
		(any [bag/red 0]) * (any [bag/green 0]) * (any [bag/blue 0])
	]

	set 'minimal-bags? function [games [string!]] [
		parse games [collect [any "^/"
			some [
				"Game" space copy game some digit
				(	game: load game
					bag:  copy [red 0 green 0 blue 0]
				)
				colon
				some [
					some [
						copy count some digit space
						(	count: load count)
						copy color ["red" | "green" | "blue"]
						(	color: load color
							if count > bag/:color [bag/:color: count]
						)
						opt comma
					]
					opt semicolon
				]
				[some "^/" | end]
				keep (bag)
			]
		]
	]]
]

probe sum-of bagged-games? games: read %day2.dat [red 12 green 13 blue 14]      ;--  2406
probe sum-of map :power-of-bag minimal-bags? games                              ;-- 78375

