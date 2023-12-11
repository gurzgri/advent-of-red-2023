Red [
	title:  "Advent of Code 2023 - Day 8: Haunted Wasteland"
	file:   %day8.red
	author: "Christian Ensel"
	usage: {
		>> do/args %day8.red [first  %day8.sample]                              ;-- answers first or ...
		>> do/args %day8.red [second %day8.input ]                              ;   ... second puzzle question
	}
]

day8: context [

	letter:    charset [#"A" - #"Z"]
	direction: charset "LR"

	set 'travel-from-AAA-to-ZZZ function [map [string!]] [
		foreach [char with] ["," "" "(" "[" ")" "]" "=" ""] [
			replace/all map char with
		]
		turns: parse map [collect [remove any ["L" keep ('first) | "R" keep ('second)]]]
		bind turns system/words 
		map: load map

		step: 'AAA count: 0
		until [
			append turns go: take turns
			go: get :go

			further: select map step	
			step:    go further
			count:   count + 1

			step = 'ZZZ
		]

		count
	]

	set 'lcm function ["Returns the lowest common multiple of two values." a [number!] b [number!]] [
		a-multiple: a * m: 1.0 
		b-multiple: b * n: 1.0

		while [a-multiple <> b-multiple] [case [
			a-multiple < b-multiple [
				delta: b-multiple - a-multiple
				m: m + (factor: round/ceiling delta / a)
				a-multiple: a-multiple + (factor * a)
			]
			b-multiple < a-multiple [
				delta: a-multiple - b-multiple
				n: n + (factor: round/ceiling delta / b)
				b-multiple: b-multiple + (factor * b)
			]
		]]

		print replace/all form reduce ['lcm a b '= a-multiple] ".0" "" 
		a-multiple
	]

	set 'glide-from-As-to-Zs function [map [string!]] [
		foreach [char with] ["," "" "(" "[" ")" "]" "=" ""] [replace/all map char with]
		bind turns: parse map [collect [remove any ["L" keep ('first) | "R" keep ('second)]]] system/words
		map: load map

		print form steps: remove-each step extract map 2 [
			not equal? #"A" last form step
		]
		print form values: collect [
			foreach step steps [
				count: 0
				until [
					append turns go: take turns
					go: get :go

					further: select map step	
					step:    go further
					count:   count + 1
				
					parse form step [skip skip "Z"] 
				]
				keep count
			]
		]
		while [not tail? next values] [
			values: next insert values 'lcm
		]	
		do head values
	]

]


;======================================================================= main ==
;

file: first find args: compose [(system/script/args)] file!
case [
	find args 'first  [travel-from-AAA-to-ZZZ read file]                     ;--          16271
	find args 'second [glide-from-As-to-Zs    read file]                     ;-- 14265111103729
]

