Red [
	title:  "Advent of Code 2023 - Day 1: Trebuchet?!"
	file:   %day1.red
	author: "Christian Ensel"
]

;   ██████   █████  ██    ██      ██               ████████ ██████  ███████ ██████  ██    ██  ██████ ██   ██ ███████ ████████ ██████  ██ 
;   ██   ██ ██   ██  ██  ██      ███                  ██    ██   ██ ██      ██   ██ ██    ██ ██      ██   ██ ██         ██         ██ ██ 
;   ██   ██ ███████   ████        ██     █████        ██    ██████  █████   ██████  ██    ██ ██      ███████ █████      ██      ▄███  ██ 
;   ██   ██ ██   ██    ██         ██                  ██    ██   ██ ██      ██   ██ ██    ██ ██      ██   ██ ██         ██      ▀▀       
;   ██████  ██   ██    ██         ██                  ██    ██   ██ ███████ ██████   ██████   ██████ ██   ██ ███████    ██      ██    ██ 

day1: context [

	sum-of: function [values [block!]] [
		sum: 0 parse values [any [set val integer! (sum: sum + val) | skip]] sum
	]

	calibration-values-of: function [document [string!] /numerals] [
		digit:        charset "1234567890"
		digit-rule:   [copy number digit (value: load number)]
		numeral:      ["one" | "two" | "three" | "four" | "five" | "six" | "seven" | "eight" | "nine"]
		numbers:      replace/all copy numeral '| []
		numeral-rule: [copy number numeral (value: index? find numbers number)]
		value-rule:   pick [[numeral-rule | digit-rule] [digit-rule]] numerals
		values-rule:  [collect [any [
			(values: copy []) collect into values [any [pos: value-rule keep (value) :pos skip | not "^/" skip]]
			opt [if (not empty? values) keep (load rejoin [first values last values])]
			"^/"
		]]]
		parse document values-rule
	]

	do [
		probe sum-of calibration-values-of          document: read %day1.dat            ;-- 54605
		probe sum-of calibration-values-of/numerals document                            ;-- 55429
	]
]

