Red [
	title:  "Day 10: Pipe Maze"
	file:   %day10.red
	author: "Christian Ensel"
	usage: {
		>> do/args %day10.red [first  %day10.sample]                            ;-- answers first or ...
		>> do/args %day10.red [second %day10.input ]                            ;   ... second puzzle question
	}
]

day10: context [

	maze: wide: path: home: none 
	away: 0                                                                     ;-- steps away from home

	main: object [pos: dir: none]                                               ;-- they face and move in 
	anti: object [pos: dir: none]                                               ;   opposite directions
	both: reduce [main anti]

	set 'solve function [                                                       ;-- entry point
		"Solve the maze." 
		maze [string!] "puzzle input"
		what [word!]   "maximum STEPS from home or AREA enclosed"
	][ 
		init maze    show

		until [move  self/away: away + 1  main/pos = anti/pos]

		clean           show
		enclave: paint  show

		do select [steps away area enclave] what
	]

	show: func ["Show the maze."] [print [newline trim/with mold/only maze space]]

	init: function ["Init the maze." maze [string!]] [
		self/wide: 1 + index? find maze newline                                 ;-- STRING! to WORD! data translation
		edge: append/dup copy "" " ·" wide                                      ;
		parse maze [
			insert (edge)
			insert (" ·") any [
				change "F" (" ┌") | change "7" (" ┐") | change "L" (" └") | change "J" (" ┘") |
				change "|" (" │") | change "-" (" ─") | change "." (" ·") | change "S" (" ■") |
				change newline (" · ·")
			]
			insert (" ·")
			insert (edge)
		]
		self/path: append/only copy [] self/home: find self/maze: load maze '■

		change home case [                                                      ;-- replace home position
			n? [case [w? [[┘]] e? [[└]] s? [[│]]]]
			s? [case [w? [[┐]] e? [[┌]]]]
			e? [[─]]
		]
		main/dir: select [┌ e ┐ s ┘ w └ n │ n ─ e] first main/pos: home         ;-- init both maze walkers
		anti/dir: select [┌ s ┐ w ┘ n └ e │ s ─ w] first anti/pos: home         ; 

		new-line/skip/all self/maze on wide
	]

	n?: does [find [┐ │ ┌] first skip home negate wide]                         ;-- helpers for INIT used to translate the start
	s?: does [find [┘ │ └] first skip home wide]                                ;   pos to a pipe tile based on neighbours
	e?: does [find [┘ ─ ┐] first next home]
	w?: does [find [└ ─ ┌] first back home]

	move: function ["Move to next pos."] [foreach one both [
		one/dir: switch first one/pos: do reduce [one/dir one] [                ;-- note that ONE/POS is not a function, but a word
			┌ [select [n e w s] one/dir] ┐ [select [e s n w] one/dir]
			└ [select [w n s e] one/dir] ┘ [select [s w e n] one/dir]
			│ [select [n n s s] one/dir] ─ [select [w w e e] one/dir]
		]
		append/only path one/pos
	]]

	n:  func [one] [one/pos: skip one/pos negate wide]                          ;-- helpers for MOVE calculating the new 
	s:  func [one] [one/pos: skip one/pos wide]                                 ;   position based on direction to move into
	e:  func [one] [one/pos: next one/pos]
	w:  func [one] [one/pos: back one/pos]

	pipe?: func ["Truthy if here's a pipe." here [block!]] [find [┌ ┐ └ ┘ │ ─] first here]
	path?: func ["Truthy if path crosses."  here [block!]] [find/only path here]

	set 'clean function ["Clean maze from excess pipes."] [forall maze [all [
		pipe? maze
		not path? maze
		change maze '·
	]]]

	set 'paint function ["Paint area enclosed by path."] [
		paint: 0 inside: no
		forall maze [switch first maze [
			  ·   [all [inside  change maze '■  paint: paint + 1]]
			└ │ ┘ [inside: not inside]
		]]
		paint 
	]
]


;======================================================================= main ==
;

file: first find args: compose [(system/script/args)] file!
case [
	find args 'first  [solve read file 'steps]                                  ;--    8 / 80 / 6903
	find args 'second [solve read file 'area ]                                  ;--    1 / 10 /  256
]

