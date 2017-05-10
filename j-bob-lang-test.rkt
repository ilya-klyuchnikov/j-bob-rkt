#lang racket/base

(require rackunit
         (submod "j-bob-lang.rkt" j-bob-lang))

(test-case
 "'nil is falsy, everything else is truthy"
 (check-equal? (if 'nil 1 2) 2)
 (check-equal? (if '() 1 2) 1))

(test-case
 "atom returns 'nil for non-empty lists and 't for everything else"
 (check-equal? (atom '()) 't)
 (check-equal? (atom 't) 't)
 (check-equal? (atom '(1 2)) 'nil))

(test-case
 "car return empty list for bad lists"
 (check-equal? (car 1) '())
 (check-equal? (car '(1)) '1)
 (check-equal? (car '(1 2)) '1))

(test-case
 "cdr return empty list for bad lists"
 (check-equal? (cdr 1) '())
 (check-equal? (cdr '()) '())
 (check-equal? (cdr '(1)) '())
 (check-equal? (cdr '(1 2)) '(2)))

(test-case
 "equal returns 't or 'nil"
 (check-equal? (equal 1 1) 't)
 (check-equal? (equal 1 2) 'nil))

(test-case
 "natp returns 't or 'nil"
 (check-equal? (natp 1) 't)
 (check-equal? (natp 0) 't)
 (check-equal? (natp -1) 'nil)
 (check-equal? (natp 'a) 'nil)
 (check-equal? (natp '(1 2 3)) 'nil))

(test-case
 "non-numerical values are treated as zero for + and <"
 (check-equal? (+ 1 'a) '1)
 (check-equal? (+ '() 'a) '0)
 (check-equal? (+ 1 1) '2)
 (check-equal? (< 1 1) 'nil)
 (check-equal? (< 1 2) 't)
 (check-equal? (< '() 2) 't))
