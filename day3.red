Red [
	title:  "Advent of Code 2023 - Day 3: Gear Ratios"
	file:   %day3.red
	author: "Christian Ensel"
]

;   ██████   █████  ██    ██     ██████                 ██████  ███████  █████  ██████      ██████   █████  ████████ ██  ██████  ███████ 
;   ██   ██ ██   ██  ██  ██           ██               ██       ██      ██   ██ ██   ██     ██   ██ ██   ██    ██    ██ ██    ██ ██      
;   ██   ██ ███████   ████        █████      █████     ██   ███ █████   ███████ ██████      ██████  ███████    ██    ██ ██    ██ ███████ 
;   ██   ██ ██   ██    ██             ██               ██    ██ ██      ██   ██ ██   ██     ██   ██ ██   ██    ██    ██ ██    ██      ██ 
;   ██████  ██   ██    ██        ██████                 ██████  ███████ ██   ██ ██   ██     ██   ██ ██   ██    ██    ██  ██████  ███████ 

day3: context [

	set 'sum-of function [vals [block!]] [                                      ;-- poor man's SUM-OF
		sum: 0 parse vals [any [set val integer! (sum: sum + val) | skip]] sum
	]

	for: function ['word from upto step code] [                                 ;-- poor man's FOR
		bind code word: in context compose [(to set-word! word: to word! word) from] word
		until [do code greater? set word step + get word upto]
	]

	parse-schematic: function [lines [block!]] [
		blank:  head insert/dup copy "" "." width: 2 + length? first lines      ;-- drawing a border of "."-dots around lines eliminates edge cases 
		lines:  collect [forall lines [keep rejoin ["." copy first lines "."]]] ;
		lines:  new-line/all compose [(blank) (lines) (blank)] on
		
		other:  complement digit: charset "1234567890"                          ;-- grammar
		symbol: complement union digit point: charset "."

		parts: copy [] stars: copy [] ratios: copy []                           ;-- collect into these ...

		for row 2 (length? lines) - 1 1 [
			set [prev: line: succ:] back at lines row

			parse line [collect [any [some other before: copy number some digit beyond: (
				before: (index? before) - 1
				beyond: (index? beyond) + 1
				number:  load number
				all [
					find nearby: rejoin [
						head change at copy blank before copy/part at prev before at prev beyond 
						head change at copy blank before copy/part at line before at line beyond 
						head change at copy blank before copy/part at succ before at succ beyond 
					] symbol
					append parts number                                         ;-- ... any part number
					parse nearby [any [not ahead "*" skip | pos: "*" (
						col: (pos: index? pos) % width
						rel: (to integer! pos / width) - 1
						pos: as-pair col row + rel
						unless star: select stars pos [repend stars [pos star: copy []]]
						append star number                                      ;--- ... all part numbers next to a star
					)]]
				]
			)]]] 
		]

		foreach [star numbers] stars [all [                                     ;-- "gear" is * next to exactly two part numbers
			equal? 2 length? numbers                                            ;
			set [one: two:] numbers
			append ratios ratio: multiply one two                               ;--- ... a gear ratio
		]]

		reduce [parts ratios]
	]

	set [part-numbers gear-ratios] parse-schematic document: read/lines %day3.dat
]

probe sum-of part-numbers                                                       ;--   542012
probe sum-of gear-ratios                                                        ;-- 87605697

