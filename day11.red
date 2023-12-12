Red [
	title:  "Advent of Code 2023 - Day 11: Cosmic Expansion"
	file:   %day11.red
	author: "Christian Ensel"
]

day11: context [

	universe!: object [data: size: none]

	sum-of: function [values [block!]] [                                        ;-- poor man's SUM-OF
		sum: 0 parse values [any [set v number! (sum: sum + v) | skip]] sum
	]

	when: make op! function [code [block!] condition [any-type!]] [             ;-- sort of a post-conditional, always
		if condition [do code]                                                  ;   wanted to play with this
	]
	
	create: function [universe [string!]] [
		make universe! [
			size: index? back find universe newline
			data: trim/all universe
		]
	]

	galaxies-of: function [universe [object!]] [
		parse universe/data [collect [any ["." | galaxy: "#" keep (
			galaxy: index? galaxy
			reduce [
				(            galaxy - 1.0 % universe/size + 1)                  ;-- in another universe, I wouldn't
				(round/floor galaxy - 1.0 / universe/size + 1)                  ;   have made a mistake here
			]
		)]]]
	]

	drift: function [galaxies [block!] factor [integer!]] [
		foreach axis [1 2] [
			table: copy []
			foreach galaxy galaxies [
				any [
					lane: select table base: galaxy/:axis
					repend table [base lane: copy []]
				]
				append/only lane galaxy
			]
			sort/skip table 2
			forall table [
				[continue] when any [
					block? first table
					tail? drifting: next next table
				]
				drift: table/3 - table/1 - 1 * (factor - 1)
				forall drifting [
					base: first drifting
					change drifting base + drift 
					lane: first drifting: next drifting
					forall lane [
						galaxy: first lane
						galaxy/:axis: galaxy/:axis + drift 
					]
				]
			]
			galaxies: collect [foreach [base lane] table [keep lane]]
		]
		galaxies
	]

	distance?: function [galaxy [block!] other [block!]] [
		add (absolute galaxy/1 - other/1)
			(absolute galaxy/2 - other/2)
	]

	set 'sum-of-galaxy-distances function [universe [string!] /drifted factor [integer!]] [
		galaxies: drift galaxies-of create universe any [factor 2]
		
		sum-of collect [forall galaxies [
			galaxy: first galaxies
			foreach other next galaxies [
				keep distance? galaxy other
			] 
		]]
	]

]



;======================================================================= main ==
;

file: first find args: compose [(system/script/args)] file!
case [
	find args 'first  [sum-of-galaxy-distances         read file          ]     ;--  374 /      9805264
  ;	find args 'second [sum-of-galaxy-distances/drifted read file        10]     ;-- 1030 /
  ;	find args 'second [sum-of-galaxy-distances/drifted read file       100]     ;-- 8410 /
	find args 'second [sum-of-galaxy-distances/drifted read file 1'000'000]     ;--      / 779032247216
]

