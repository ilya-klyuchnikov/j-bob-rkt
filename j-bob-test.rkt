#lang racket/base

(require rackunit
         (submod "j-bob.rkt" j-bob))

(define simple-defs-0
  '((defun id (x) x)
    (defun id2 (x) (id2 x))
    (defun first (x y) x)
    (defun second (x y) y)))

(define simple-defs
  '((defun id (x) x)
    (defun first (x y) x)
    (defun second (x y) y)
    (dethm car/cons (a b)
           (equal (car (cons a b)) a))))

(test-case
 "tagging (tag, untag and tag?)"
 (check-equal? (tag 'tag 'data) '(tag . data))
 (check-equal? (untag '(tag . data)) 'data)
 (check-equal? (tag? 'tag '(tag . data)) 't)
 (check-equal? (tag? 'tag1 '(tag . data)) 'nil))

(test-case
 "quoting and unquoting"
 (check-equal? (quote 'nil) '(quote nil))
 (check-equal? (quote? '(quote nil)) 't)
 (check-equal? (quote? '(quote a b)) 'nil)
 (check-equal? (quote.value '(quote value)) 'value))


(test-case
 "quoting and unquoting if"
 (check-equal? (if-c 't 'nil 't) '(if t nil t))
 (check-equal? (if? '(if t nil t)) 't)
 (check-equal? (if? '(if t nil)) 'nil)
 (check-equal? (if.Q '(if q a e)) 'q)
 (check-equal? (if.A '(if q a e)) 'a)
 (check-equal? (if.E '(if q a e)) 'e)
 )

(test-case
 "quoting and unquoting app"
 (check-equal? (app-c 'n '(arg1 arg2)) '(n arg1 arg2))
 (check-equal? (app? '(n arg1 arg2)) 't)
 (check-equal? (app? '(quote app nil)) 't)
 (check-equal? (app? '(quote nil)) 'nil)
 (check-equal? (app? '(quote nil)) 'nil)
 (check-equal? (app? '(if q a e)) 'nil))

(test-case
 "var?"
 (check-equal? (var? 'n) 't)
 (check-equal? (var? 't) 'nil)
 (check-equal? (var? 'nil) 'nil)
 (check-equal? (var? '0) 'nil)
 (check-equal? (var? '()) 't)
 )

(test-case
 "defun-c"
 (check-equal? (defun-c 'id '(x) 'x) '(defun id (x) x))
 (check-equal? (defun-c 'id '(x) '(id x)) '(defun id (x) (id x)))
 (check-equal? (defun? '(defun id (x) (id x))) 't)
 (check-equal? (defun? '(defun id (x))) 'nil)
 (check-equal? (defun.name '(defun id (x) (id x))) 'id)
 (check-equal? (defun.formals '(defun id (x) (id x))) '(x))
 (check-equal? (defun.body '(defun id (x) (id x))) '(id x)))

(test-case
 "dethm-c"
 (check-equal? (dethm-c 'id '(x) 'x) '(dethm id (x) x))
 (check-equal? (dethm-c 'id '(x) '(id x)) '(dethm id (x) (id x)))
 (check-equal? (dethm? '(dethm id (x) (id x))) 't)
 (check-equal? (dethm? '(dethm id (x))) 'nil)
 (check-equal? (dethm.name '(dethm id (x) (id x))) 'id)
 (check-equal? (dethm.formals '(dethm id (x) (id x))) '(x))
 (check-equal? (dethm.body '(dethm id (x) (id x))) '(id x)))

(test-case
 "if-QAE and QAE-if"
 (check-equal? (if-QAE '(if q a e)) '(q a e))
 (check-equal? (QAE-if '(q a e)) '(if q a e)))

(test-case
 "member?"
 (check-equal? (member? 'a '(if q a e)) 't)
 (check-equal? (member? 1 '(q a e)) 'nil))

(test-case
 "rator? (operators)"
 (check-equal? (rator? 'atom) 't)
 (check-equal? (rator? 'car) 't)
 (check-equal? (rator? 'cdr) 't)
 (check-equal? (rator? 'cons) 't)
 (check-equal? (rator? 'natp) 't)
 (check-equal? (rator? 'size) 't)
 (check-equal? (rator? '+) 't)
 (check-equal? (rator? '<) 't)
 (check-equal? (rator? 'a) 'nil))

(test-case
 "defun operations"
 (check-equal? (def.name '(defun id (x) (id x))) 'id)
 (check-equal? (def.name '(dethm id (x) (id x))) 'id)
 ; it returns the original expression by default
 (check-equal? (def.name '(app id)) '(app id))
 (check-equal? (def.formals '(defun id (x) (id x))) '(x))
 (check-equal? (def.formals '(dethm id (x) (id x))) '(x))
 ; it returns an empty list by default
 (check-equal? (def.formals '(app id)) '())
 )

(test-case
 "if-c-when-necessary"
 (check-equal? (if-c-when-necessary 'q 1 1) '1)
 (check-equal? (if-c-when-necessary 'q 1 2) '(if q 1 2 )))

(test-case
 "conjunction and implication"
 (check-equal? (conjunction '(a b c))
               '(if a (if b c 'nil) 'nil))
 (check-equal? (implication '(a) 'd)
               '(if a d 't))
 (check-equal? (implication '(a b c) 'd)
               '(if a (if b (if c d 't) 't) 't)))

(test-case
 "lookup and other ops"
 (check-equal? (lookup 'id simple-defs)
               '(defun id (x) x))
 ; it returns the name by default
 (check-equal? (lookup 'id1 simple-defs)
               'id1)
 (check-equal? (undefined? 'id1 simple-defs)
               't)
 ; arity? returns true if the lists are of equal lengths
 (check-equal? (arity? '() '()) 't)
 (check-equal? (arity? '(1) '()) 'nil)
 (check-equal? (arity? '() '(1)) 'nil)
 ; the first argument is operator or definition
 (check-equal? (args-arity? 'cons '(x y)) 't)
 (check-equal? (args-arity? (lookup 'first simple-defs) '(x y)) 't)
 )

(test-case
 "syntax checks"
 (check-equal? (app-arity? simple-defs '(cons x y)) 't)
 (check-equal? (app-arity? simple-defs '(cons x)) 'nil)
 (check-equal? (app-arity? simple-defs '(first x y)) 't)
 (check-equal? (app-arity? simple-defs '(first y)) 'nil)
 (check-equal? (app-arity? simple-defs '(undefined y)) 'nil)
 ;---
 (check-equal? (bound? 'x 'any) 't)
 (check-equal? (bound? 'x '()) 'nil)
 (check-equal? (bound? 'a '()) 'nil)
 (check-equal? (bound? 'a '(a)) 't)
 ;-- check that expressions are valid
 (check-equal? (expr? simple-defs '(x) 'x) 't)
 (check-equal? (expr? simple-defs '(x) '(id x)) 't)
 (check-equal? (expr? simple-defs '(x) '(id y)) 'nil)
 (check-equal? (expr? simple-defs '(x y) '(cons x y)) 't)
 (check-equal? (expr? simple-defs '(x y) '(cons x)) 'nil)
 (check-equal? (expr? simple-defs '(x y) ''t) 't)
 (check-equal? (expr? simple-defs '(x y) ''nil) 't)
 ;-- checking defs
 (check-equal? (defs? '() '((defun id (x) x))) 't)
 ; -- it checks that defun is well-formed
 (check-equal? (defs? '() '((defun id (x)))) 'nil)
 ; -- it checks arity of applications!
 (check-equal? (defs? '() '((defun id (x) (id x)))) 't)
 (check-equal? (defs? '() '((defun id (x) (id x x)))) 'nil)

 (check-equal? (defs? '() '((dethm id (x) x))) 't)
 ; -- theorems are not reqursive
 (check-equal? (defs? '() '((dethm id (x) (id x)))) 'nil)
 (check-equal? (defs? '() simple-defs) 't))

(test-case
 "step? checks the syntax of path and substitution"
 (check-equal? (path? '()) 't)
 (check-equal? (path? '(1)) 't)
 (check-equal? (path? '(1 A Q E 1)) 't)
 (check-equal? (step? simple-defs '(() (id 'nil))) 't)
 (check-equal? (step? simple-defs '(() (id x))) 't)
 (check-equal? (step? simple-defs '(() (cons 'nil 'nil))) 't)
 ; -- call to operators should be always quoted values!!
 (check-equal? (step? simple-defs '(() (cons x 'nil))) 'nil)
 )

(test-case
 "seed? for functions checks that application is an application of some formal vars"
 (check-equal? (seed? simple-defs (lookup 'id simple-defs) '(id x)) 't)
 (check-equal? (seed? simple-defs (lookup 'first simple-defs) '(first x y)) 't)
 (check-equal? (seed? simple-defs (lookup 'first simple-defs) '(first y x)) 't)
 (check-equal? (seed? simple-defs (lookup 'first simple-defs) '(first y y)) 't)
 (check-equal? (seed? simple-defs (lookup 'first simple-defs) '(first y)) 'nil)
 (check-equal? (seed? simple-defs (lookup 'first simple-defs) '(first y z)) 'nil))

(test-case
 "seed? for theorems checks that it is an application of some function to some formals of th"
 (check-equal? (seed? simple-defs (lookup 'car/cons simple-defs) '(first a b)) 't)
 (check-equal? (seed? simple-defs (lookup 'car/cons simple-defs) '(id a)) 't))

(test-case
 "proof? checks the syntax of proof. proof is a def, seed and steps"
 (check-equal? (proof? simple-defs-0
                       (list2 (lookup 'car/cons simple-defs) '(first a b)))
               't)
 (check-equal? (proof? simple-defs-0
                       (list3 (lookup 'car/cons simple-defs) '(first a b) '(() (id 'nil))))
               't))

(test-case
 "sub-es"
 (check-equal? (sub-es '(x) '(y) '(x)) '(y))
 (check-equal? (sub-es '(x y) '(1 2) '(x y)) '(1 2)))

(test-case
 "expr-recs"
 (check-equal? (expr-recs 'f '(f x)) '((f x)))
 (check-equal? (expr-recs 'f '(f (f y))) '((f (f y)) (f y)))
 )

(test-case
 "totality/claim constructs a claim for a seed (measure)"
 (check-equal?
  (totality/claim '(id x) '(defun id2 (x) (if (atom x) x (id2 (cdr x)))))
  '(if (natp (id x)) (if (atom x) 't (< (id (cdr x)) (id x))) 'nil)
  )
(check-equal?
  (totality/claim '(size x) '(defun induct2 (x y) (if (atom x) y (induct2 (g (const (cdr x) 'nil)) (car 'a y)))))
  '(if (natp (size x)) (if (atom x) 't (< (size (g (const (cdr x) 'nil))) (size x))) 'nil)
  )

 )

(test-case
 "induction/claim constracts a claim for a seed (function call/induction scheme)"
 ; it uses 
 (check-equal?
  (induction/claim '((defun induct (x) (if (atom x) x (induct (cdr x)))))
                   '(induct x)
                   '(dethm t1 (x y) (equal x y)))
  '(if (atom x) (equal x y) (if (equal (cdr x) y) (equal x y) 't)))
(check-equal?
  (induction/claim '((defun f (x) (if (atom x) '0 '1))
                     (defun const (x y) y)
                     (defun induct2 (x) (if (atom x)
                                              '0
                                              (if (atom (cdr x)) '0
                                              (induct2 (f (const (cdr (cdr x))s 'nil)) '0)))))
                   '(induct2 x y)
                   '(dethm t1 (x) (equal (f x) '0)))
  '(if (atom x) ; '()
       (equal (f x) '0)
       (if
        (atom (cdr x)) ; '(x)
        (equal (f x) '0)
        (if (equal (f (f (const (cdr (cdr x)) s 'nil))) '0) (equal (f x) '0) 't))))
 )

;----------------
(test-case
 "J-Bob/step - simple steps over values: everything should be quoted"
 (check-equal? (J-Bob/step '()
                           '(car (cons 'ham '(eggs)))
                           '(((1) (cons 'ham '(eggs)))))
               '(car '(ham eggs)))
 (check-equal? (J-Bob/step '()
                           '(car '(ham eggs))
                           '((() (car '(ham eggs)))))
               ''ham)
 (check-equal? (J-Bob/step '((defun first (x) (car x)))
                           '(first '(ham eggs))
                           '((() (first '(ham eggs)))))
               '(car '(ham eggs)))
 ;-- J-Bob/step can apply a theorem/axiom
 (check-equal? (J-Bob/step
                '((defun first (x) (car x))
                  (dethm first-thm (x) (equal (first x) x)))
                '(first x)
                '((() (first-thm x))))
               'x)
 (check-equal? (J-Bob/step
                '((defun first (x) (car x))
                  (dethm first-thm (x) (equal (first x) x)))
                'x
                '((() (first-thm x))))
               '(first x))
 
 (check-equal? (J-Bob/step
                '((defun first (x) (car x))
                  (dethm first-thm (x) (equal (first x) x)))
                '(if (first x) y z)
                '(((Q) (first-thm x))))
               '(if x y z))

 ;-- for user-defined function vars can be used
 (check-equal? (J-Bob/step '((defun first (x) (car x)))
                           '(first x)
                           '((() (first x))))
               '(car x))

 (check-equal? (J-Bob/step (prelude)
                           '(if X (cons (if X (cons n '(answer)) (cons n '(else))) cell) e)
                           '(((A 1) (if-nest-A X (cons n '(answer)) (cons n '(else))))))
               '(if X (cons (cons n '(answer)) cell) e))

 ; -- if premise of the theorem holds, then consequence of theorem holds
 (check-equal? (J-Bob/step '((dethm th1 (x y z) (if x (equal y z) 't)))
                           '(if x 'a 'b)
                           '(((A) (th1 x 'a 'b))))
               '(if x 'b 'b))
 ; premises can be in any order
 (check-equal? (J-Bob/step '((dethm th1 (x y z) (if x (if y (equal z 'a) 't) 't)))
                           '(if x (if y z '2) '1)
                           '(((A A) (th1 x y z))))
               '(if x (if y 'a '2) '1))
 (check-equal? (J-Bob/step '((dethm th1 (x y z) (if x (if y (equal z 'a) 't) 't)))
                           '(if x (if y z '2) '1)
                           '(((A A) (th1 y x z))))
               '(if x (if y 'a '2) '1)))

(define list-ind
  '(defun list-induction (x)
                       (if (atom x)
                           '()
                           (cons (car x)
                                 (list-induction (cdr x))))))

(test-case
 "totality/claim constructs a claim for a seed (measure)"
 (check-equal?
  (totality/claim '(id x) '(defun id2 (x) (if (atom x) x (id2 (cdr x)))))
  '(if (natp (id x)) (if (atom x) 't (< (id (cdr x)) (id x))) 'nil)
  ))

(test-case
 "induction/claim constracts a claim for a seed (function call/induction scheme)"
 (check-equal?
  (induction/claim '((defun id2 (x) (if (atom x) x (id2 (cdr x)))))
                   '(id2 x)
                   '(dethm t1 (x y) (equal x y)))
  '(if (atom x) (equal x y) (if (equal (cdr x) y) (equal x y) 't))))

