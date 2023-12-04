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

	sum-of: function [vals [block!]] [                                              ;-- poor man's FOR
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
		pile: collect [foreach card split cards "^/" [all [
			parse card: load replace card ":" " |" [thru '| copy wins some integer! '| copy nums some integer!]
			keep/only compose/only [copies 1 wins (wins) nums (nums)]
		]]]
		forall pile [
			card: first pile
			gain: length? intersect card/wins card/nums
			foreach succ copy/part next pile gain [succ/copies: succ/copies + card/copies]
		]
		collect [foreach card pile [keep card/copies]] 
	]

	sample: {
		Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
		Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
		Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
		Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
		Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
		Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
	}

	do [
		probe sum-of probe points-for-scratchcards sample
		probe sum-of probe points-for-scratchcards puzzle: read %day4.dat
		probe sum-of probe  number-of-scratchcards sample
		probe sum-of probe  number-of-scratchcards puzzle
	]

]