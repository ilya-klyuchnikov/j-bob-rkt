#lang racket

(require rackunit
         (submod "little-prover.rkt" little-prover))

(define (find-fun f-name defs)
  (findf (lambda (def) (and (equal? (first def) 'defun) (equal? (second def) f-name))) defs))

(define (find-thm t-name defs)
  (findf (lambda (def) (and (equal? (first def) 'dethm) (equal? (second def) t-name))) defs))

(test-case
 "chapter1"
 (check-equal?
  (chapter1.example1)
  ''ham)
 (check-equal?
  (chapter1.example2)
  ''t)
 (check-equal?
  (chapter1.example3)
  ''nil)
 (check-equal?
  (chapter1.example4)
  ''nil)
 (check-equal?
  (chapter1.example5)
  ''nil)
 (check-equal?
  (chapter1.example6)
  ''t)
 (check-equal?
  (chapter1.example7)
  ''t)
 (check-equal?
  (chapter1.example8)
  ''t)
 (check-equal?
  (chapter1.example9)
  '(equal (cons 'bagels '(and lox)) (cons x y)))
 (check-equal?
  (chapter1.example10)
  '(cons y (equal (cdr x) (equal (atom x) 'nil))))
 (check-equal?
  (chapter1.example11)
  '(cons y
         (equal
          (car (cons (car (cons (cdr x) (car y))) '(oats)))
          (equal (atom x) (atom (cons (atom b) (equal c (cons a b))))))))
 (check-equal?
  (chapter1.example12)
  '(atom (car a))))

(test-case
 "chapter2"
 (check-equal?
  (chapter2.example1)
  '(if (if (equal a 't) 't (equal 'or '(black coffee))) c c))
 (check-equal?
  (chapter2.example2)
  '(if
    (atom (car a))
    (if (equal (car a) (cdr a)) 'hominy 'grits)
    (if (equal (cdr (car a)) '(hash browns)) (cons 'ketchup (cons (car (car a)) '(hash browns))) (cons 'mustard (car a)))))
 (check-equal?
  (chapter2.example3)
  '(cons 'statement (if (equal a 'question) (cons (cons n '(answer)) (cons n '(other answer))) (cons (cons n '(else)) (cons n '(other else)))))))

(test-case
 "chapter3"

 (check-not-false
  (find-fun
   'pair
   (defun.pair)))

 (check-not-false
  (find-fun
   'first-of
   (defun.first-of)))

 (check-not-false
  (find-thm
   'first-of-pair
   (dethm.first-of-pair)))

 (check-not-false
  (find-thm
   'second-of-pair
   (dethm.second-of-pair)))

 (check-not-false
  (find-fun
   'in-pair?
   (defun.in-pair?)))

 (check-not-false
  (find-thm
   'in-first-of-pair
   (dethm.in-first-of-pair)))

 (check-not-false
  (find-thm
   'in-second-of-pair
   (dethm.in-second-of-pair))))

(test-case
 "chapter4"

 (check-not-false
  (find-fun
   'list0?
   (defun.list0?)))

 (check-not-false
  (find-fun
   'list1?
   (defun.list1?)))

 (check-equal?
  (unsound.contradiction)
  ''t)

 (check-not-false
  (find-fun
   'list?
   (defun.list?)))

 (check-not-false
  (find-fun
   'sub
   (defun.sub))))

(test-case
 "chapter5"

 (check-not-false
  (find-fun
   'memb?
   (defun.memb?)))

 (check-not-false
  (find-fun
   'remb
   (defun.remb)))

 (check-not-false
  (find-thm
   'memb?/remb0
   (dethm.memb?/remb0)))

 (check-not-false
  (find-thm
   'memb?/remb1
   (dethm.memb?/remb1)))

 (check-not-false
  (find-thm
   'memb?/remb2
   (dethm.memb?/remb2))))

(test-case
 "chapter6"

 (check-not-false
  (find-thm
   'memb?/remb
   (dethm.memb?/remb))))

(test-case
 "chapter7"

 (check-not-false
  (find-fun
   'ctx?
   (defun.ctx?)))

 (check-not-false
  (find-thm
   'ctx?/sub
   (dethm.ctx?/sub))))

(test-case
 "chapter8"

 (check-not-false
  (find-fun
   'member?
   (defun.member?)))

 (check-not-false
  (find-fun
   'set?
   (defun.set?)))

 (check-not-false
  (find-fun
   'add-atoms
   (defun.add-atoms)))

 (check-not-false
  (find-fun
   'atoms
   (defun.atoms))))

(test-case
 "chapter9"

 (check-not-false
  (find-thm
   'set?/atoms
   (dethm.set?/atoms))))

(test-case
 "chapter10"

 (check-not-false
  (find-fun
   'rotate
   (defun.rotate)))
 
 (check-not-false
  (find-thm
   'rotate/cons
   (dethm.rotate/cons)))

 (check-not-false
  (find-fun
   'wt
   (defun.wt)))

 (check-not-false
  (find-fun
   'align
   (defun.align))))
