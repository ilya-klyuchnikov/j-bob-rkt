#lang racket/base

; a language comprised of variables,
; quoted literals,
; if expressions, and function applications.
; Functions include nine built-in operators: atom, car, cdr, cons, equal, natp, +, <, size
; as user-defined functions (via defun and dethm)
; only 'nil acts as false
(module j-bob-lang racket/base
  (provide
   (rename-out [jbob/atom atom])
   (rename-out [jbob/car car])
   (rename-out [jbob/cdr cdr])
   (rename-out [jbob/cons cons])
   (rename-out [jbob/equal equal])
   (rename-out [jbob/natp natp])
   (rename-out [jbob/+ +])
   (rename-out [jbob/< <])
   (rename-out [jbob/if if])
   (rename-out [jbob/defun defun])
   (rename-out [jbob/dethm dethm])
   (rename-out [jbob/size size])
   ; to be able to apply functions
   #%app
   ; to be able to create symbols (quoting)
   quote
   ; to be able to create modules
   #%module-begin
   provide
   all-defined-out
   all-from-out)

  (define (num x) (if (number? x) x 0))

  ;---- basis
  (define (jbob/atom x) (if (pair? x) 'nil 't))
  (define (jbob/car x) (if (pair? x) (car x) '()))
  (define (jbob/cdr x) (if (pair? x) (cdr x) '()))
  (define (jbob/equal x y) (if (equal? x y) 't 'nil))
  (define (jbob/natp x)
    (if (integer? x) (if (< x 0) 'nil 't) 'nil))
  (define (jbob/+ x y) (+ (num x) (num y)))
  (define (jbob/< x y)
    (if (< (num x) (num y)) 't 'nil))

  (define (jbob/cons a b) (cons a b))

  ; --- syntax/macros
  (define-syntax jbob/defun
    (syntax-rules ()
      ((_ name (arg ...) body)
       (define (name arg ...) body))))

  (define-syntax jbob/dethm
    (syntax-rules ()
      ((_ name (arg ...) body)
       (define (name arg ...) body))))

  (define-syntax jbob/if
    (syntax-rules ()
      ((_ Q A E)
       (if (equal? Q 'nil) ((lambda () E)) ((lambda () A))))))

  (jbob/defun jbob/size (x)
              (if (jbob/atom x)
                  '0
                  (jbob/+ '1 (jbob/+ (jbob/size (jbob/car x)) (jbob/size (jbob/cdr x)))))))
