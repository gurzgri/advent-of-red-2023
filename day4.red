Red [
	title:  "Advent of Code 2023 - Day 4: Scratchcards"
	file:   %day4.red
	author: "Christian Ensel"
]

;   ██████   █████  ██    ██     ██   ██               ███████  ██████ ██████   █████  ████████  ██████ ██   ██  ██████  █████  ██████  ██████  ███████     
;   ██   ██ ██   ██  ██  ██      ██   ██               ██      ██      ██   ██ ██   ██    ██    ██      ██   ██ ██      ██   ██ ██   ██ ██   ██ ██          
;   ██   ██ ███████   ████       ███████     █████     ███████ ██      ██████  ███████    ██    ██      ███████ ██      ███████ ██████  ██   ██ ███████     
;   ██   ██ ██   ██    ██             ██                    ██ ██      ██   ██ ██   ██    ██    ██      ██   ██ ██      ██   ██ ██   ██ ██   ██      ██     
;   ██████  ██   ██    ██             ██               ███████  ██████ ██   ██ ██   ██    ██     ██████ ██   ██  ██████ ██   ██ ██   ██ ██████  ███████     

day4: context [

	set 'sum-of function [vals [block!]] [                                      ;-- poor man's FOR
		sum: 0 parse vals [any [set val integer! (sum: sum + val) | skip]] sum
	]

	digit: charset "1234567890"
	
	set 'points-for-scratchcards function [cards [string!]] [
		parse cards [collect [any [
			thru "Card" some space some digit ":" copy winning to "|" skip copy disclosed to ["^/" skip | end] (
				winning:   load winning
				disclosed: load disclosed
				correct:   intersect winning disclosed
				points:    to-integer power 2 (length? correct) - 1
			)
			keep (points)
		]]]
	]
	
	set 'number-of-scratchcards function [cards [string!]] [
		pile: collect [foreach card (split copy cards "^/") [all [
			card: load replace card ":" " |"                                    ;-- input format longs for block parsing  
			parse card [thru '| copy wins some integer! '| copy nums some integer!]
			keep/only compose/only [copies 1 wins (wins) nums (nums)]
		]]]
		collect [forall pile [
			card: first pile
			keep copies: card/copies
			gain: length? intersect card/wins card/nums
			after: copy/part next pile gain
			foreach card after [card/copies: card/copies + copies]
		]]
	]
]

probe sum-of points-for-scratchcards puzzle: read %day4.dat                     ;--   28538
probe sum-of number-of-scratchcards puzzle                                      ;-- 9425061

