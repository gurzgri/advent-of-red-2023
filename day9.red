Red [
	title:  "Advent of Code 2023 - Day 9: Mirage Maintenance"
	file:   %day9.red
	author: "Christian Ensel"
	usage: {
		>> do/args %day9.red [first  %day9.sample]                              ;-- answers first or ...
		>> do/args %day9.red [second %day9.input ]                              ;   ... second puzzle question
	}
]

day9: context [

	set 'environmental-report function [survey [string!] /past] [
		survey: load replace/all rejoin ["[" survey "]"] newline "] ["
		sum:    0
		foreach history survey [sum: sum + apply :extrapolate [history /past past]]
		sum
	]

	set 'extrapolate function [history [block!] /past] [
		from:    get pick [first last] past 
		values:  reduce [from history]
		offsets: history
		while [not parse history [some quote 0]] [
			offsets: copy []
			forall history [
				append offsets (second history) - (first history)
				if last? next history [break]
			]
			insert values from history: offsets
		]
		sign: pick [-1 1] past
		until [tail? change values result: (sign * take values) + (first values)]
		result
	]

]


;======================================================================= main ==
;

file: first find args: compose [(system/script/args)] file!
case [
	find args 'first  [environmental-report      read file]                     ;-- 114 / 1757008019 
	find args 'second [environmental-report/past read file]                     ;--   2 /        995
]

