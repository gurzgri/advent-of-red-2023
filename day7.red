Red [
	title:  "Advent of Code 2023 - Day 7: Camel Cards"
	file:   %day7.red
	author: "Christian Ensel"
	usage: {
		>> do/args %day7.red [first  %day7.sample]                              ;-- answers first or ...
		>> do/args %day7.red [second %day7.input ]                              ;   ... second puzzle question
	}
]

day7: context [

	digit!: charset "1234567890"

	types: ["high card" "one pair" "two pair" "three of a kind" "full house" "four of a kind" "five of a kind"]
	rank: ranks: rules: none

	set 'name-of      func [type [integer!]] [pick types type]
	set 'type-of      func [hand [string! ]] [parse sort copy hand rules type]
	set 'strengths-of func [hand [string! ]] [collect [forall hand [keep index? find ranks first hand]]]

	normal-rules: [                                     ;-- expects already sorted hand
		ahead copy hand 5 rank!
		(kinds: length? uniq: unique sort hand)
		[
			if (kinds = 1) (type: 7)                    ;-- five of a kind
		|	if (kinds = 2)
			[	[	set a rank! a a a rank!
				|	rank! set a rank! a a a
				]
				(type: 6)                               ;-- four of a kind
			|	(type: 5)                               ;-- full house
			]
		|	if (kinds = 3)
			[	[	set a rank! a a rank! rank!
				|	rank! set a rank! a a rank!
				|	rank! rank! set a rank! a a
				]
				(type: 4)                               ;-- three of a kind
			|	(type: 3)                               ;-- two pair
			]
		|	if (kinds = 4) (type: 2) ; one pair
		|	if (kinds = 5) (type: 1) ; high card
		]
	]

	joker?: func [card] [#"J" = card]

	joker-rules: [
		ahead copy hand 5 rank! (
			jokers: length? remove-each card copy hand [not joker? card]
			others:         remove-each card      hand [    joker? card]
			kinds:  length? uniq: unique sort others
			runs:   sort/reverse parse others [collect [any [copy run [set a rank! any a] keep (length? run)]]]
		)
		[	if (jokers = 5) (type: 7)                   ;-- five jokers =>             five of a kind
		|	if (jokers = 4) (type: 7)                   ;-- four jokers => complete to five of a kind
		|	if (jokers = 3) [
				if (kinds = 1) (type: 7)                ;-- three jokers, one pair  => complete to five of kind
			|	if (kinds = 2) (type: 6)                ;                 two cards => complete to four of kind 
			]	
		|	if (jokers = 2) [
				if (kinds = 1) (type: 7)                ;-- two jokers, three of a kind => complete to five of a kind
			|	if (kinds = 2) (type: 6)                ;               one pair        => complete to four of a kind
			|	if (kinds = 3) (type: 4)                ;               three cards     => complete to three of a kind
			]
		|	if (jokers = 1) [
				if (kinds = 1) (type: 7)                ;-- joker, four of a kind  => complete to five of a kimd
			|	if (runs = [3 1]) (type: 6)             ;          three of a kind => complete to four of a kind
			|	if (runs = [2 2]) (type: 5)             ;          two pairs       => complete to full house
			|	if (runs = [2 1 1]) (type: 4)           ;          one pair        => complete to three of a kind
			|	if (runs = [1 1 1 1]) (type: 2)         ;          high card       => complete to pair
			]
		|	normal-rules
		]
	]

	set 'by-type-or-strength func [left [string!] right [string!]] [
		l: type-of left
		r: type-of right
		case [l < r [1] r < l [-1] l = r [
			left:  strengths-of left
			right: strengths-of right
			order: sort reduce [left right]
			pick [1 -1] order/1 = left
		]]
	]

	set 'play-game function [game] [
		game: parse game [collect [any [
			copy hand 5 rank! space copy bid some digit!
			keep pick (reduce [hand load bid])
			[newline | end]
		]]]

		sort/skip/compare game 2 :by-type-or-strength

		winnings: 0 rank: 0
		game: collect [foreach [hand bid] game [
			winnings: add winnings bid * rank: rank + 1 
			keep reduce [name-of type-of hand hand bid]
		]]

		new-line/skip/all game on 3
		probe game

		winnings
	]

	set 'play-camel-cards func [hands [string!]] [
		rank!: charset ranks: "23456789TJQKA"
		rules: normal-rules
		play-game hands
	]

	set 'play-joker-cards func [hands [string!]] [
		rank!: charset ranks: "J23456789TQKA"
		rules: joker-rules
		play-game hands
	]
]


;======================================================================= main ==
;

file: first find args: compose [(system/script/args)] file!
case [
	find args 'first  [play-camel-cards read file]                              ;-- 6440 / 248836197
	find args 'second [play-joker-cards read file]                              ;-- 5905 / 251195607
]

